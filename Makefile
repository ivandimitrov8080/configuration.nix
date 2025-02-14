default: nova

all: nova vps gaming

nova:
	nix run . -- switch nova

vps:
	nix run . -- target vps vpsfree-ivand

gaming:
	nix run . -- switch gaming
