{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    simple-nixos-mailserver.url =
      "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs = { self, nixpkgs, home-manager, nix-doom-emacs
    , simple-nixos-mailserver, ... }: {
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
            ./sys/mailserver
            simple-nixos-mailserver.nixosModule
          ];
        };
      };
      homeConfigurations = {
        ivand = home-manager.lib.homeManagerConfiguration {
          modules = [ ./home/laptop nix-doom-emacs.hmModule ];
          pkgs = import nixpkgs { system = "x86_64-linux"; };
        };
      };
    };
}
