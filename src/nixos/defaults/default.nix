{
  pkgs,
  ...
}:
{
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      trusted-users = [ "@wheel" ];
      auto-optimise-store = true;
      max-jobs = "auto";
    };
  };
  security.sudo.execWheelOnly = true;
  users = {
    mutableUsers = false;
    groups.ssh = { };
  };
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
  };
  i18n.defaultLocale = "en_US.UTF-8";
  systemd.network.wait-online.enable = false;
  environment = {
    systemPackages = with pkgs; [
      cryptsetup
      nixos-install-tools
    ];
    shells = with pkgs; [
      bash
      zsh
      nushell
    ];
    shellAliases = {
      sc = "systemctl";
      flip = "shuf -r -n 1 -e Heads Tails";
    };
    variables = {
      SYSTEMD_LESS = "FRXMK";
    };
  };
  networking.useNetworkd = true;
  services = {
    dnscrypt-proxy.settings = {
      ipv4_servers = true;
      ipv6_servers = true;
      dnscrypt_servers = true;
      doh_servers = false;
      odoh_servers = false;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;
      anonymized_dns.routes = [
        {
          server_name = "*";
          via = [ "sdns://gQ8yMTcuMTM4LjIyMC4yNDM" ];
        }
      ];
      sources.public-resolvers.urls = [
        "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
        "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
      ];
      sources.public-resolvers.cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
      sources.public-resolvers.minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
    };
    nginx = {
      recommendedGzipSettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedUwsgiSettings = true;
      recommendedBrotliSettings = true;
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
      appendHttpConfig = ''
        client_body_timeout 5s;
        client_header_timeout 5s;
      '';
    };
    pipewire = {
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    openssh = {
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AuthenticationMethods = "publickey";
        AllowGroups = [ "ssh" ];
        PermitRootLogin = "no";
      };
    };
    roundcube = {
      package = pkgs.roundcube.withPlugins (plugins: [ plugins.persistent_login ]);
      plugins = [ "persistent_login" ];
    };
  };
  programs = {
    zsh = {
      enableBashCompletion = true;
      vteIntegration = true;
    };
    zoxide = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    git.config.safe.directory = "*";
  };
}
