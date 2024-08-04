default: nova

all: nova (nova "music")

nova config="nova":
  #!/usr/bin/env sh
  cfg={{config}}
  if [ "$cfg" != "nova" ]; then
    cfg="nova-{{config}}"
  fi
  doas nixos-rebuild switch --flake ./#"$cfg"

update:
  nix flake update

clean:
  nix-collect-garbage --delete-older-than 90d
  doas nix-collect-garbage --delete-older-than 90d

installer-iso:
  nix shell nixpkgs#nixos-generators --command nixos-generate -f install-iso --flake ./#installer-iso

vps:
  nixos-rebuild switch --flake ./#vps --target-host root@10.0.0.1
