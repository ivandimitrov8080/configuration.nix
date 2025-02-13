default: nova

all: nova vps gaming

nova:
	nix run . -- -p nova

vps:
	nix run . -- -p vps

gaming:
	nix run . -- -p gaming
