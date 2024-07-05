.PHONY: default all home nixos vm update clean

default: all

all: home nixos

home:
	home-manager switch --flake ./. -b $$(mktemp -u XXXX)

nixos:
	doas nixos-rebuild switch --flake ./.

vm:
	nixos-rebuild build-vm --flake ./.#vm

update:
	nix flake update

clean: cleanRoot cleanHome

cleanHome:
	nix-collect-garbage --delete-older-than 30d

cleanRoot:
	doas nix-collect-garbage --delete-older-than 30d

news:
	home-manager news --flake ./.
