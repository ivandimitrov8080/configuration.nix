{
  pkgs,
  config,
  lib,
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
    defaultUserShell = pkgs.bash;
    mutableUsers = false;
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth = {
      theme = "catppuccin-mocha";
      themePackages = [
        (pkgs.catppuccin-plymouth.override { variant = "mocha"; })
      ];
    };
    loader = {
      efi.canTouchEfiVariables = true;
      grub =
        let
          grubTheme = pkgs.catppuccin-grub.override {
            flavor = "mocha";
          };
        in
        {
          useOSProber = true;
          efiSupport = true;
          device = "nodev";
          theme = grubTheme;
          splashImage = "${grubTheme}/background.png";
        };
    };
  };
  environment = {
    systemPackages = with pkgs; [
      bat
      cryptsetup
      eza
      fd
      file
      nixos-install-tools
      openssh
      openssl
      procs
      ripgrep
      srm
      tshark
      unzip
      uutils-coreutils-noprefix
      wget
      zip
    ];
    shells = with pkgs; [
      bash
      zsh
      nushell
      xonsh
    ];
    shellAliases = {
      sc = "systemctl";
      flip = "shuf -r -n 1 -e Heads Tails";
    }
    // (
      if config.programs.zoxide.enable then
        {
          cd = "z";
          cdi = "zi";
        }
      else
        { }
    )
    // (
      if builtins.elem pkgs.eza config.environment.systemPackages then
        {
          eza = "eza --long --header --icons --smart-group --mounts --group-directories-first --octal-permissions --git";
          ls = "eza";
          la = "eza --all -a";
          lt = "eza --git-ignore --all --tree --level=10";
        }
      else
        { }
    );
    variables = {
      SYSTEMD_LESS = "FRXMK";
    };
  };
  networking.useNetworkd = true;
  services = {
    dnscrypt-proxy.settings = {
      cache = false;
      ipv4_servers = true;
      ipv6_servers = true;
      dnscrypt_servers = true;
      doh_servers = false;
      odoh_servers = false;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;
      listen_addresses = [ "127.0.0.1:53" ];
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
  };
  programs = {
    zsh = {
      enableBashCompletion = true;
      vteIntegration = true;
      setOptions = [
        "INC_APPEND_HISTORY"
        "SHARE_HISTORY"
      ];
    };
    zoxide = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    git.config.safe.directory = "*";
    bash = {
      interactiveShellInit = ''
        ${lib.optionalString config.programs.bash.blesh.enable "set -o vi"}
      '';
      blesh.enable = true;
    };
  };
}
