default: nova

all: nova vps gaming

nova:
	nix run . -- nova

vps:
	nix run . -- vps

gaming:
	nix run . -- gaming

ai:
	nix run . -- ai

reboot:
	nix run . -- reboot
