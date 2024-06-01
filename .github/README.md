# Disko Inferno - Burn baby burn! 
## A Nixos Impermanence Desktop config
Configuration files for NixOS with an ephemeral root, erased every boot.

## What this repo gives you:
- Flake-based config
- Declarative disk setup & management with [Disko](https://github.com/nix-community/disko)
- Ephemeral root file-system using the [Impermamence](https://github.com/nix-community/impermanence) module
- Modularized config files, including:
  - `myparams.nix` - username, hostname, ssh-key & Desktop.
  - `packages.nix` - packages divided into categories for easy modification
  - `users.nix` - per-user configuation
  - `desktop.nix` - Switch between multiple DEs (currently KDE, Pantheon, Hyprland or Budgie).
- Install script:
  - `nix-setup.sh` - run this to install (full install instructions below)
- Helper scripts to manage after install:
  - `changepass.sh` - script to change user password in a running system
  - `cruft.sh` - shows all files written to `/` since boot (erased next boot)

## Install Instructions
1. Boot into a [NixOS install ISO](https://github.com/chewblacka/nixos-iso/)
2. In a shell clone this repo:
```
curl -L https://github.com/chewblacka/nixos/archive/refs/heads/main.zip --output main.zip
unzip main.zip
```
  
3. Finally run the install script:
  ```
  ./nixos-main/scripts/nix-setup.sh
  ````
Credit: Originally forked from [Guekka's Nixos as a Server](https://guekka.github.io)
but changed quite substantially since then.

