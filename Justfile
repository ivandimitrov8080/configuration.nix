default: nova

all: (nova "ai") (nova "gaming") nova vps

nova config="nova":
  #!/usr/bin/env sh
  cfg={{config}}
  if [ "$cfg" != "nova" ]; then
    cfg="nova-{{config}}"
  fi
  sudo nixos-rebuild switch --profile-name '{{config}}' --flake ./#"$cfg"

update:
  nix flake update

clean:
  nix-collect-garbage --delete-older-than 90d
  sudo nix-collect-garbage --delete-older-than 90d

generate format="install-iso" config="install-iso":
  nix shell nixpkgs#nixos-generators --command nixos-generate -f {{format}} --flake ./#{{config}}

vps:
  nixos-rebuild switch --flake ./#vps --target-host root@10.0.0.1

lint:
  deadnix .
  statix check .

format:
  nix fmt ./**/*.nix
