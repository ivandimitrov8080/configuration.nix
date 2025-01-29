default: nova

all: nova vps gaming

nova:
	nix run . -- -t nova

vps:
	nix run . -- -t vps

gaming:
	nix run . -- -t gaming
