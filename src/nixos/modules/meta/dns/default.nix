# Single owner for "where does DNS come from". Replaces the duplicated
# networking.nameservers / services.resolved / services.dnscrypt-proxy settings
# that were spread over the old meta.dnscrypt module, the host wireguard
# modules and the vps integration test.
{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    mkEnableOption
    mkOption
    concatMapStringsSep
    types
    ;
  cfg = config.meta.dns;

  listenAddress = "${cfg.listen.address}:${toString cfg.listen.port}";

  # Everything but the configured resolvers is dropped, so a stray
  # resolv.conf/dnscrypt/doh client cannot bypass the tunnel.
  egressRules = ''
    table inet filter {
      chain output {
        type filter hook output priority 0; policy accept;

        meta oifname "lo" accept

        # Allow dns only to the configured resolvers
    ${concatMapStringsSep "\n" (server: ''
      ip daddr ${server} udp dport 53 accept
      ip daddr ${server} tcp dport 53 accept'') cfg.servers}

        # Block DNS to anywhere else
        udp dport 53 drop
        tcp dport 53 drop
        tcp dport 853 drop
      }
    }
  '';
in
{
  options.meta.dns = {
    servers = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Resolvers this host must use for both resolving and per-link DNS.
        Usually the wireguard hub address; kept as host data.
      '';
    };

    listen = {
      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address dnscrypt-proxy listens on.";
      };
      port = mkOption {
        type = types.port;
        default = 53;
        description = "Port dnscrypt-proxy listens on.";
      };
    };

    dnscrypt = {
      enable = mkEnableOption "dnscrypt-proxy on meta.dns.listen";
      settings = mkOption {
        type = types.attrs;
        default = { };
        description = "Extra services.dnscrypt-proxy.settings.";
      };
    };

    egress = {
      restrict = mkEnableOption "drop outgoing DNS that does not target meta.dns.servers";
    };
  };

  config = mkMerge [
    (mkIf (cfg.servers != [ ]) {
      networking.nameservers = cfg.servers;
      services.resolved = {
        enable = true;
        settings.Resolve.FallbackDNS = cfg.servers;
      };
    })

    (mkIf cfg.dnscrypt.enable {
      services.dnscrypt-proxy = {
        enable = true;
        settings = {
          cache = true;
          listen_addresses = [ listenAddress ];
        }
        // cfg.dnscrypt.settings;
      };
    })

    (mkIf cfg.egress.restrict {
      networking.nftables = {
        enable = true;
        ruleset = lib.mkDefault egressRules;
      };
    })
  ];
}
