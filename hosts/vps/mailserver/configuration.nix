{ pkgs, ... }:
{
  time.timeZone = "Europe/Prague";

  fileSystems."/mnt/export1981" = {
    device = "172.16.128.47:/nas/5490";
    fsType = "nfs";
    options = [ "nofail" ];
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "security@idimitrov.dev";
    };
  };

  networking = {
    firewall = pkgs.lib.mkForce {
      enable = true;
      allowedTCPPorts = [
        25 # smtp
        465 # smtps
        80 # http
        443 # https
      ];
      allowedUDPPorts = [
        25
        465
        80
        443
        51820 # wireguard
      ];
      extraCommands = ''
        iptables -N vpn  # create a new chain named vpn
        iptables -A vpn --src 10.0.0.2 -j ACCEPT  # allow
        iptables -A vpn --src 10.0.0.3 -j ACCEPT  # allow
        iptables -A vpn --src 10.0.0.4 -j ACCEPT  # allow
        iptables -A vpn -j DROP  # drop everyone else
        iptables -I INPUT -m tcp -p tcp --dport 22 -j vpn
      '';
      extraStopCommands = ''
        iptables -F vpn
        iptables -D INPUT -m tcp -p tcp --dport 22 -j vpn
        iptables -X vpn
      '';
    };
  };

  users = {
    users.ivand = {
      isNormalUser = true;
      hashedPassword =
        "$2b$05$hPrPcewxj4qjLCRQpKBAu.FKvKZdIVlnyn4uYsWE8lc21Jhvc9jWG";
      extraGroups = [ "wheel" "adm" "mlocate" ];
      openssh.authorizedKeys.keys = [
        ''
          ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyW157tNiQdeoQsoo5AEzhyi6BvPeqEvChCxCHf3hikmFDqb6bvvlKYb9grW+fqE0HzALRwpXvPKnuUwHKPVG8HZ7NC9bT5RPMO0rFviNoxWF2PNDWG0ivPmLrQGKtCPM3aUIhSdUdlJ7ImYl34KBkUIrSmL7WlLJUvh1PtyyuVfrhpFzFxHwYwVCNO33L89lfl5PY/G9qrjlH64urt/6aWqMdHD8bZ4MHBPcnSwLMd7f0nNa0aTAJMabsfmndZhV24y7T1FUWG0dl27Q4rnpnZJWBDD1IyWIX/aN+DD6eVVWa4tRVJs6ycfw48hft0zs9zLn9mU4a2hxQ6VvfwpqZHOO8XqqOSai9Yw9Ba60iVQokQQiL91KidoSF7zD0U0szdEmylANyAntUcJ1kdu496s21IU2hjYfN/3seH5a9hBk8iPHp/eTeVUXFKh27rRWn0gc+rba1LF0BWfTjRYR7e1uvPEau0I61sNsp3lnMULdkgkZ9rap1sRM6ULlaRXM= ivand@nixos
        ''
      ];
    };
    extraGroups = { mlocate = { }; };
  };

  environment = {
    enableAllTerminfo = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
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
          ${pkgs.nushell}/bin/nu -c "http get ('https://bing.com' + ((http get https://www.bing.com/HPImageArchive.aspx?format=js&n=1).images.0.url)) | save  ('/var/pic' | path join ( [ (date now | format date '%Y-%m-%d'), '.png' ] | str join ))"
          ${pkgs.nushell}/bin/nu -c "${pkgs.toybox}/bin/ln -sf (ls /var/pic | where type == file | get name | sort | last) /var/pic/latest.png"
        '';
      };
    };
  };
}
