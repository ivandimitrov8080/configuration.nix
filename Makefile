default: nova

all: nova gaming ai vps

nova:
	nix run . -- nova

gaming:
	nix run . -- gaming

ai:
	nix run . -- ai

vps:
	nix run . -- vps

iso:


reboot:
	nix run . -- reboot
