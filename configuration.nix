{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  system.stateVersion = "23.05";

  hardware = {
  	pulseaudio.enable = true;
	opengl = {
    		enable = true;
    		driSupport = true;
    		driSupport32Bit = true;
  	};
	nvidia = {
		modesetting.enable = true;
		open = true;
    		nvidiaSettings = true;
	};
  };

  boot = {
	loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
	};
  };

  security = {
  	polkit.enable = true;
  };

  time.timeZone = "Europe/Sofia";

  environment = {
  	systemPackages = with pkgs; [
    		libgccjit
    		binutils
    		glibc
  		vim
  		wget
  		git
  		cmatrix
  		zbar
  		gnome.cheese
  		gimp
		libmtp
		jmtpfs
		pinentry-qt
		gnumake
		nodejs_20
		zip
		unzip
		mlocate
  	];
	variables = {
		EDITOR = "nvim";
	};
	shells = with pkgs; [ zsh ];
  };

  programs = {
  	gnupg.agent = {
  		enable = true;
  		enableSSHSupport = true;
  	};
	sway.enable = true;
	zsh.enable = true;
  };


  users = {
  	defaultUserShell = pkgs.zsh;
  	users.ivand = {
  		isNormalUser = true;
  		extraGroups = [ "wheel" "audio" "mlocate" ];
  	};
	extraGroups = {
		mlocate = {};
	};
  };

  home-manager.users.ivand = {
  	home = {
  		stateVersion = "23.05";
		pointerCursor = 
  			let 
  			    getFrom = url: hash: name: {
  			        gtk.enable = true;
  			        x11.enable = true;
  			        name = name;
  			        size = 48;
  			        package = 
  			          pkgs.runCommand "moveUp" {} ''
  			            mkdir -p $out/share/icons
  			            ln -s ${pkgs.fetchzip {
  			              url = url;
				      hash = hash;
  			            }} $out/share/icons/${name}
  			        '';
  			      };
  			  in
  			    getFrom 
  			      "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.3/Bibata-Modern-Classic.tar.gz"
			      "sha256-vn+91iKXWo++4bi3m9cmdRAXFMeAqLij+SXaSChedow="
  			      "Bibata_Modern_Classic";
  		};
  	programs = {
		home-manager = {
			enable = true;
		};
		git = {
			enable = true;
			userName = "Ivan Dimitrov";
			userEmail = "ivan@idimitrov.dev";
		};
		kitty = {
			enable = true;
			settings = {
				enable_tab_bar = false;
				background_opacity = "0.9";
			};
		};
		neovim = {
			enable = true;
		};
		zsh = {
			enable = true;
			zplug = {
				enable = true;
				plugins = [
					{ name = "jeffreytse/zsh-vi-mode"; }
					{ name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
					{ name = "zsh-users/zsh-autosuggestions"; }
					{ name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
				];
			};
			initExtra = ''
				source ./.p10k.zsh
			'';
		};
	};
	xdg.configFile = {
		nvim = {
			source = ./config/nvim;
			recursive = true;
		};
	};
	home.packages = with pkgs; [
		brave
		bemenu
		gopass
		gopass-jsonapi
		pavucontrol
		vimPlugins.nvchad
	];
  };

}

