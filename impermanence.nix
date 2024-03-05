# btrfs/impermanence.nix

{ config, pkgs, ... }:

let
  myuser = config.myParams.myusername;
in
{
  users.users.${myuser} = {
    hashedPasswordFile = "/persist/passwords/user";
  };

  # filesystem modifications needed for impermanence
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  # reset / at each boot
  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -p /mnt

    # Mount the btrfs root to /mnt
    mount -o subvol="@" /dev/vda3 /mnt

    # Delete the root subvolume
    echo "deleting root subvolume..." &&
    btrfs subvolume delete /mnt/root

    # Restore new root from root-blank
    echo "restoring blank @root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root

    # Unmount /mnt and continue boot process
    umount /mnt
  '';

  # configure impermanence
  environment.persistence."/persist" = {
    directories = [
      # "/etc/nixos"
      "/etc/ssh"
    ];
    files = [ ];
  };

  # machine id - setting as a persistent file results in errors.
  # so we use this config option instead:
  environment.etc.machine-id.source = /persist/etc/machine-id;

  # security.sudo.extraConfig = ''
  #   # rollback results in sudo lectures after each reboot
  #   Defaults lecture = never
  # '';

  environment.sessionVariables = {
    PATH = [ 
      "/persist/nixos/scripts"
    ];
  };
}
