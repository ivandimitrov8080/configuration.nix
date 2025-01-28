default: nova

all: nova

nova:
	nix run . -- -t nova

vps:
	nix run . -- -t vps
