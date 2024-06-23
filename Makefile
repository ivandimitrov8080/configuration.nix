.PHONY: default all home nixos clean

default: all

all: home nixos

home:
	home-manager switch --flake ./.

nixos:
	doas nixos-rebuild switch --flake ./.

clean:
	nix-collect-garbage -d
	doas nix-collect-garbage -d
