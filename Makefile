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

stara:
	nix run . -- stara

iso:


reboot:
	nix run . -- reboot
