# Script to install nixos in an 
# Erase my darlings -style configuration
# Root is erased on boot.

function prompt {
	read -n 1 -srp $'Is this correct? (y/N) ' key
	echo
	if [ "$key" != 'y' ]; then 
        exit
    fi
}

function get_user_info {
    # Gather the 
    # 1.Username, 2.Password 3.Hostname, 4. Desktop, 5. SSH-key

    # 1. Username
    echo "Lets set the username"
    DEFAULT_UNAME=$(grep -oP 'myusername =.*?"\K[^"]*' "$NIXDIR/myparams.nix")
    echo "Default username is: $DEFAULT_UNAME"

    read -n 1 -srp $'Is this ok? (Y/n) ' key
    echo
    if [ "$key" == 'n' ]; then                                                                                             
        read -rp "Enter New Username: " UNAME
        echo "The username is: $UNAME"  
        prompt
    else 
        UNAME=$DEFAULT_UNAME
    fi

    # 2. Password
    echo
    echo "Now lets set the user password"
    read -srp "Enter New User Password: " PASS1
    echo 
    read -srp "Password (again): " PASS2
    if  [[ "$PASS1" != "$PASS2" ]]; then
        echo "Passwords do not match! Exiting ..."
        exit
    fi

    # 3. Hostname
    echo
    echo
    echo "Now lets set the Hostname"
    DEFAULT_HOST=$(grep -oP 'myhostname =.*?"\K[^"]*' "$NIXDIR/myparams.nix")
    echo "Default Hostname is: $DEFAULT_HOST"
    read -n 1 -srp $'Is this ok? (Y/n) ' key
    echo
    if [ "$key" == 'n' ]; then
      read -rp "Enter New Hostname: " HOST
      echo "The New Hostname is: $HOST"  
      prompt
    else
      HOST=$DEFAULT_HOST
    fi

    # 4. Desktop
    echo
    echo
    echo "Now choose the Desktop to boot into:"
    echo "kde pantheon"
    DEFAULT_DESKTOP=$(grep -oP 'mydesktop =.*?"\K[^"]*' "$NIXDIR/myparams.nix")
    echo "Default Desktop is: $DEFAULT_DESKTOP"
    read -n 1 -srp $'Is this ok? (Y/n) ' key
    echo
    if [ "$key" == 'n' ]; then
      select DESKTOP in kde pantheon; do
          case $DESKTOP in
            kde)
              break
              ;;
            pantheon)
              break
              ;;
            *) 
              echo "Invalid option $DESKTOP"
              ;;
          esac
      done
      echo "The New Desktop is: $DESKTOP"  
      prompt
    else
      DESKTOP=$DEFAULT_DESKTOP
    fi

    # 5. SSH Key
    echo
    echo
    echo "Now lets set the SSH key"
    DEFAULT_SSHKEY=$(grep -oP 'mysshkey =.*?"\K[^"]*' "$NIXDIR/myparams.nix")
    SSHKEY=$DEFAULT_SSHKEY
    echo "Current SSH Key is: $DEFAULT_SSHKEY"
    read -n 1 -srp $'Is this ok? (Y/n) ' key
    while [ "$key" == "n" ]
    do
      echo
      read -rp "Enter an SSH Key for user $UNAME: " SSHKEY
      echo "The New SSH Key is: $SSHKEY"  
      read -n 1 -srp $'Is this ok? (Y/n) ' key
    done

    # Write out the username 
    sed -i "s#myusername = \".*\";#myusername = \"${UNAME}\";#" "$NIXDIR/myparams.nix"
    # Write out the hostname 
    sed -i "s#myhostname = \".*\";#myhostname = \"${HOST}\";#" "$NIXDIR/myparams.nix"
    # Write out the desktop 
    sed -i "s#mydesktop = \".*\";#mydesktop = \"${DESKTOP}\";#" "$NIXDIR/myparams.nix"
    # Write out the ssh-key 
    sed -i "s#mysshkey = \".*\";#mysshkey = \"${SSHKEY}\";#" "$NIXDIR/myparams.nix"
}

function format_disko {
    # format the disk
    # wipefs -a -f $DISK
    NIX="nix --extra-experimental-features 'nix-command flakes'"
    disko="$NIX run github:nix-community/disko --"
    DCONFIG="/root/nixos-main/etc/nixos/disko-config.nix"
    DISKO_CMD="$disko --mode zap_create_mount $DCONFIG --arg disks '[ ""\"""$DISK""\""" ]'"
    # DISKO_CMD="nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode zap_create_mount /root/nixos-main/etc/nixos/disko-config.nix --arg disks '[ ""\"""$DISK""\""" ]'"
    eval "$DISKO_CMD"
    # nix --extra-experimental-features nix-command --extra-experimental-features flakes run github:nix-community/disko -- --mode zap_create_mount /root/nixos-main/etc/nixos/disko-config.nix --arg disks '[ "/dev/vda" ]'
    echo "Making empty snapshot of root"
    MOUNT="/mnt2"
    mkdir $MOUNT
    mount -o subvol=@ "$DISK"3 "$MOUNT"
    # Make tmp and srv directories so subvolumes are not autocreated
    # by systemd, stopping deletion of root subvolume
    mkdir -p "$MOUNT/root/srv"
    mkdir -p "$MOUNT/root/tmp"
    btrfs subvolume snapshot -r /mnt2/root /mnt2/root-blank
    btrfs subvolume list /mnt2
    umount "$MOUNT"
}

function build_file_system {
    echo "Making File system"
    DISK=/dev/vda
    echo
    echo "Drive to erase and install nixos on is: $DISK"
    read -n 1 -srp $'Is this ok? (Y/n) ' key
    echo

    format_disko

    echo "Disk configuration complete!"
    echo
}

function generate_config {
    # create configuration
    echo "Generating Config"
    # nixos-generate-config --root /mnt
    # For disko we generate a config with the --no-filesystems option
    nixos-generate-config --no-filesystems --root /mnt
    echo

    # Copy over our nixos config
    echo "Copying over our nixos configs"
    # Copy config files to new install
    cp -r "$NIXDIR"/* /mnt/etc/nixos

    echo "Creating trash folder for user 1000 in /persist"
    mkdir -p /mnt/persist/.Trash-1000
    sudo chown 1000:users /mnt/persist/.Trash-1000
    sudo chmod 700 /mnt/persist/.Trash-1000

    # Write the password we entered earlier
    mkdir -p /mnt/persist/passwords
    mkpasswd -m sha-512 "$PASS1" > /mnt/persist/passwords/user
    echo "Password file is:"
    ls -lh /mnt/persist/passwords/user
    echo "Config generation complete!"   
}

function install_nix {
    echo
    read -n 1 -srp $'Would you like to install nixos now? (Y/n) ' key
    echo
    if [ "$key" == 'n' ]; then                                                                                      
        exit
    else 
        nixos-install
    fi
}

function create_git {
    echo "Cloning the nixos git folder into /persist/nixos"
    cd /mnt/persist || exit
    git clone https://github.com/chewblacka/nixos.git
    sudo chown -R 1000:users /mnt/persist/git
    cd /mnt/persist/nixos || exit
    # make sure git doesn't track myparams.nix
    git update-index --assume-unchanged myparams.nix

    # Since (/mnt)/etc/nixos will be deleted on boot
    # we need to preserve these 3 files:
    echo "Preserving myparams.nix"
    cp /mnt/etc/nixos/myparams.nix myparams.nix
    echo "Preserving hardware-configuration.nix"
    cp /mnt/etc/nixos/hardware-configuration.nix /persist/nixos/
    echo "Preserving flake.lock"
    cp /mnt/etc/nixos/flake.lock /persist/nixos/
}

function install_zsh {
    echo
    echo "Cloning ZSH config into $UNAME's home directory"
    # nixos is user 1000
    su -c "cd /mnt/home/$UNAME && git clone https://github.com/chewblacka/zsh.git zsh" nixos || (echo "dir not found" && exit)
    su -c "HOME=/mnt/home/$UNAME && /mnt/home/$UNAME/zsh/.github/install.sh" nixos
    echo "Zsh install finished!"
}

function install_fish {
    echo
    echo "Cloning Fish config into $UNAME's home directory"
    # During install nixos is user 1000
    su -c "cd /mnt/home/$UNAME && git clone https://github.com/chewblacka/fish.git .config/fish" nixos || (echo "dir not found" && exit)
    su -c "HOME=/mnt/home/$UNAME && /mnt/home/$UNAME/fish/.github/install.sh" nixos
    echo "Fish install finished!"
}

# Make script independent of which dir it was run from
SCRIPTDIR=$(dirname "$0")
NIXDIR="$SCRIPTDIR/../etc/nixos"

get_user_info
build_file_system
generate_config
install_nix
create_git
# install_zsh
install_fish
echo "Install completed!"
echo "Reboot to use NixOS"
