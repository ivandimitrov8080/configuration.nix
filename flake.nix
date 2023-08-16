{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-nixos-mailserver.url =
      "gitlab:simple-nixos-mailserver/nixos-mailserver";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, simple-nixos-mailserver
    , emacs-overlay, ... }: {
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
          modules = [ ./home/laptop ];
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ emacs-overlay.overlay ];
          };
        };
      };
    };
}
