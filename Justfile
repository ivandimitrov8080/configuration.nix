default: nixos

all: nixos music nonya ai

home:
	home-manager switch --flake ./. -b $(mktemp -u XXXX)

nixos:
	doas nixos-rebuild switch --flake ./.

update:
	nix flake update

clean: cleanRoot cleanHome

cleanHome:
	nix-collect-garbage --delete-older-than 90d

cleanRoot:
	doas nix-collect-garbage --delete-older-than 90d

news:
	home-manager news --flake ./.

music:
	doas nixos-rebuild switch --flake ./#music

nonya:
	doas nixos-rebuild switch --flake ./#nonya

ai:
	doas nixos-rebuild switch --flake ./#ai
