default: nova

all: nova vps

nova:
	nix run . -- -t nova

vps:
	nix run . -- -t vps
