
  ivand = moduleWithSystem (
    _:
    { pkgs, ... }:
    let
      homeMods = top.config.flake.homeManagerModules;
    in
    {
      imports = [ inputs.home-manager.nixosModules.default ];
      home-manager = {
        backupFileExtension = "bak";
        useUserPackages = true;
        useGlobalPkgs = true;
        users.ivand =
          { ... }:
          {
            imports = with homeMods; [
              base
              ivand
              shell
              util
              swayland
              web
              reminders
            ];
          };
      };
      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        noto-fonts
        noto-fonts-emoji
        noto-fonts-lgc-plus
      ];
      users = {
        users = {
          ivand = {
            isNormalUser = true;
            createHome = true;
            extraGroups = [
              "adbusers"
              "adm"
              "audio"
              "bluetooth"
              "dialout"
              "flatpak"
              "input"
              "kvm"
              "mlocate"
              "realtime"
              "render"
              "video"
              "wheel"
            ];
          };
        };
        extraGroups = {
          mlocate = { };
          realtime = { };
        };
      };
      programs = {
        dconf.enable = true;
        adb.enable = true;
      };
    }
  );

  networking = {
    wireless = {
      enable = true;
      networks = {
        "Smart-Hostel-2.4" = {
          psk = "smarttrans.bg";
        };
        "Yohohostel2.4G" = {
          psk = "kaskamaska";
        };
        "Nomado_Guest" = {
          psk = "welcomehome";
        };
        "HostelMusala Uni" = {
          psk = "mhostelm";
        };
        "BOUTIQUE APARTMENTS" = {
          psk = "boutique26";
        };
        "Safestay" = {
          psk = "AlldayrooftopBAR";
        };
        "HOSTEL JASMIN 2" = {
          psk = "Jasmin2024";
        };
        "HOME" = {
          psk = "iloveprague";
        };
        "Vodafone-B925" = {
          psk = "7aGh3FE6pN4p4cu6";
        };
        "O2WIFIZ_EXT" = {
          psk = "iloveprague";
        };
        "KOTEKLAN_GUEST" = {
          psk = "koteklankotek";
        };
        "TP-Link_BE7A" = {
          psk = "84665461";
        };
        "Post120" = {
          psk = "9996663333";
        };
        "MOONLIGHT2019" = {
          psk = "seacrets";
        };
        "Kaiser Terrasse" = {
          psk = "Internet12";
        };
        "bumshakalaka" = {
          psk = "locomotive420";
        };
        "ATHENS-HAWKS" = { };
        "3G" = {
          hidden = true;
        };
      };
    };
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "192.168.69.2/32" ];
      privateKeyFile = "/etc/wireguard/privatekey";
      peers = [
        {
          publicKey = "5FiTLnzbgcbgQLlyVyYeESEd+2DtwM1JHCGz/32UcEU=";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "37.205.13.29:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  systemd.services.webshiteApi = {
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.webshiteApi}/bin/api";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  networking = {
    firewall = lib.mkForce {
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
      # allow ssh and imaps for vpn
      extraCommands = ''
        iptables -N vpn  # create a new chain named vpn
        iptables -A vpn --src 192.168.69.2 -j ACCEPT  # allow
        iptables -A vpn --src 192.168.69.3 -j ACCEPT  # allow
        iptables -A vpn --src 192.168.69.4 -j ACCEPT  # allow
        iptables -A vpn --src 192.168.69.5 -j ACCEPT  # allow
        iptables -A vpn -j DROP  # drop everyone else
        iptables -I INPUT -m tcp -p tcp --dport 22 -j vpn
        iptables -I INPUT -m tcp -p tcp --dport 993 -j vpn
      '';
      extraStopCommands = ''
        iptables -F vpn
        iptables -D INPUT -m tcp -p tcp --dport 22 -j vpn
        iptables -D INPUT -m tcp -p tcp --dport 993 -j vpn
        iptables -X vpn
      '';
    };
  };

  users = {
    users.ivand = {
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
    extraGroups = {
      mlocate = { };
    };
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
          ${pkgs.nushell}/bin/nu -c "http get ('https://bing.com' + ((http get https://www.bing.com/HPImageArchive.aspx?format=js&n=1).images.0.url)) | save  ('/var/pic' | path join ( [ (date now | format date '%Y-%m-%d'), '.jpeg' ] | str join ))"
          ${pkgs.nushell}/bin/nu -c "${pkgs.toybox}/bin/ln -sf (ls /var/pic | where type == file | get name | sort | last) /var/pic/latest.jpeg"
        '';
      };
    };
  };
