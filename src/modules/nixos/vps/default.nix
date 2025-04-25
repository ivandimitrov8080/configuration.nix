{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkForce
    ;
  cfg = config.vps;
in
{
  options.vps = {
    enable = mkEnableOption "enable vps config";
  };

  config = mkIf cfg.enable {
    nixpkgs.hostPlatform = "x86_64-linux";
    networking = {
      nftables = {
        enable = true;
      };
      firewall = {
        interfaces = {
          wg0 = {
            allowedTCPPorts = [
              22
              53
              993
            ];
          };
        };
        allowedTCPPorts = mkForce [
          25 # smtp
          465 # smtps
          80 # http
          443 # https
        ];
        allowedUDPPorts = mkForce [
          25
          465
          80
          443
          51820 # wireguard
        ];
      };
    };

    host.wgPeer = {
      enable = true;
      address = "10.0.0.1/24";
      isHub = true;
    };
    host.name = "vpsfree";

    #rest - meaning i didnt wanna do it now
    fileSystems."/mnt/export1981" = {
      device = "172.16.128.47:/nas/5490";
      fsType = "nfs";
      options = [ "nofail" ];
    };
    users = {
      defaultUserShell = pkgs.zsh;
      users = {
        ivand = lib.mkForce {
          isNormalUser = true;
          hashedPassword = "$2b$05$hPrPcewxj4qjLCRQpKBAu.FKvKZdIVlnyn4uYsWE8lc21Jhvc9jWG";
          extraGroups = [
            "wheel"
            "adm"
            "mlocate"
          ];
          openssh.authorizedKeys.keys = [
            ''
              ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcLkzuCoBEg+wq/H+hkrv6pLJ8J5BejaNJVNnymlnlo ivan@idimitrov.dev
            ''
          ];
        };
        git = {
          useDefaultShell = true;
          openssh.authorizedKeys.keys = [
            ''
              ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcLkzuCoBEg+wq/H+hkrv6pLJ8J5BejaNJVNnymlnlo ivan@idimitrov.dev
            ''
          ];
        };
      };
      extraGroups = {
        mlocate = { };
      };
    };
    services = {
      gitDaemon = {
        enable = true;
        repositories = [
          "/srv/git"
        ];
        basePath = "/srv/git";
        listenAddress = "git.idimitrov.dev";
      };
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "prohibit-password";
        };
      };
    };
    systemd = {
      timers = {
        bingwp = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "*-*-* 10:00:00";
            Persistent = true;
          };
        };
      };
      services = {
        bingwp = {
          description = "Download bing image of the day";
          script = ''
            ${pkgs.nushell}/bin/nu -c "http get ('https://bing.com' + ((http get https://www.bing.com/HPImageArchive.aspx?format=js&n=1).images.0.url)) | save  ('/var/pic' | path join ( [ (date now | format date '%Y-%m-%d'), '.jpeg' ] | str join ))"
            ${pkgs.nushell}/bin/nu -c "${pkgs.toybox}/bin/ln -sf (ls /var/pic | where type == file | get name | sort | last) /var/pic/latest.jpeg"
          '';
        };
      };
    };
  };
}
