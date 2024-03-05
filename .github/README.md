# Disko Inferno - Burn baby burn! 
## A Nixos Impermanence Desktop config
Configuration files for NixOS with an ephemeral root, erased every boot.

## What this repo gives you:
- A flake-ified config
- Declarative Disk setup & management with [Disko](https://github.com/nix-community/disko)
- Ephemeral root (with either BTRFS or tmpfs) using the nixos [impermamence](https://github.com/nix-community/impermanence) module
- Modularized config files, including:
  - `myparams.nix` - initial set of install parameters (username, hostname, ssh-key & Desktop). Edit directly or via the install script.
  - `packages.nix` - packages divided into categories for easy modification / maintenence
  - `users.nix` - for extensive user configuation
  - `desktop.nix` - Allows multiple DEs (currently KDE or Pantheon). DE set with `myDesktop` variable in `configuation.nix`
- Install script:
  - `nix-setup.sh` - run this to install (full install instructions below)
- Helper scripts to manage after install (placed in `/persist/scripts` and added to `$PATH`) 
  - `changepass.sh` - script to change user password in a running system
  - `push-to-git.sh` - script to push `/etc/nixos` files to a git repo
  - `cruft.sh` - shows all files written to `/` since boot (erased next boot)

## Install Instructions
- Boot a [NixOS install ISO](https://github.com/chewblacka/nixos-iso/)
- Then in a shell (either directly of vias ssh) clone this repo, e.g.
  ```
  curl -L https://github.com/chewblacka/nixos/archive/refs/heads/main.zip --output main.zip
  unzip main.zip
  ```
- Run the install script which will install the necessary files for impermanence, then prompt you to proceed with the ISO NixOS install:
  ```
  ./nixos-main/scripts/nix-setup.sh
  ```

Credit: Originally forked from [Guekka's Nixos as a Server](https://guekka.github.io)
but changed quite substantially since then.

