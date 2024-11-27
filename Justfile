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

generate format="install-iso" config="install-iso":
  nix shell nixpkgs#nixos-generators --command nixos-generate -f {{format}} --flake ./#{{config}}

vps:
  nixos-rebuild switch --flake ./#vps --target-host root@37.205.13.29

lint:
  deadnix .
  statix check .

format:
  nix run p#nixfmt-rfc-style .
