# My messy nixos config. It has everything I use every day.

---
# Usage

```bash
home-manager switch --flake ./#ivand                                # this switches home-manager
sudo nixos-rebuild switch --flake ./#laptop                         # this builds the base system
nixos-rebuild switch --flake ./#mailserver --target-host mailserver # this deploys to mailserver in .ssh/config
```

