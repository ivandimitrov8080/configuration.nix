.PHONY: default all home nixos update clean

default: all

all: home nixos

home:
	home-manager switch --flake ./.

nixos:
	doas nixos-rebuild switch --flake ./.

update:
	nix flake update

clean:
	nix-collect-garbage -d
	doas nix-collect-garbage -d
