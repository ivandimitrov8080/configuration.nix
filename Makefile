.PHONY: default all home nixos update clean

default: all

all: home nixos

home:
	home-manager switch --flake ./. -b $$(mktemp -u XXXX)

nixos:
	doas nixos-rebuild switch --flake ./.

update:
	nix flake update

clean: cleanRoot cleanHome

cleanHome:
	nix-collect-garbage -d

cleanRoot:
	doas nix-collect-garbage -d

news:
	home-manager news --flake ./.
