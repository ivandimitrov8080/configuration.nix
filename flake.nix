{
  inputs = {
    nixpkgs.url = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , simple-nixos-mailserver
    , emacs-overlay
    , nix-doom-emacs
    , ...
    }: {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./sys/laptop ];
        };
        mailserver = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (nixpkgs
              + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
            simple-nixos-mailserver.nixosModule
            ./sys/mailserver
          ];
        };
      };
      homeConfigurations = {
        ivand = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { rootPath = ./.; };
          modules = [ ./home/laptop nix-doom-emacs.hmModule ];
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ emacs-overlay.overlay ];
          };
        };
      };
    };
}
