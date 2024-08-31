# users.nix

{ config, pkgs, ... }:
let 
  # Read params file for username
  myuser = config.myParams.myusername;
  mysshkey = config.myParams.mysshkey;
in 
{
  # User account
  users.users.${myuser} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "podman"];
    ### Shell
    shell = pkgs.fish;
    # shell = pkgs.zsh;
    ### Password
    # initialHashedPassword = "";
    # Have moved below line to impermanence.nix
    # passwordFile = "/persist/passwords/user";
    ### ssh
    openssh.authorizedKeys.keys = [ "${mysshkey}" ];
    ### User namespaces
    subUidRanges = [
      { count = 65536; startUid = 100000; }
    ];
    subGidRanges = [
      { count = 65536; startGid = 100000; }
    ];
    ### Per user packages
    # packages = with pkgs; [ ];
  };
 
  # Mount virtiofs shares
  fileSystems."/home/${myuser}/Dropbox" = {
    device = "Dropbox";
    fsType = "virtiofs";
  };
  fileSystems."/home/${myuser}/Music" = {
    device = "Music";
    fsType = "virtiofs";
  };

  # doas rules
  security.doas.extraRules = [
    # { groups = [ "wheel" ]; keepEnv = true; noPass = true; cmd = "nix-channel"; args = [ "--list" ]; }
    { users = [ "${myuser}" ]; keepEnv = true; persist = true; }
    { users = [ "${myuser}" ]; keepEnv = true; noPass = true; cmd = "nixos-rebuild"; args = [ "boot" "--flake" "/etc/nixos" ]; }
    { users = [ "${myuser}" ]; keepEnv = true; noPass = true; cmd = "nixos-rebuild"; args = [ "switch" "--flake" "/etc/nixos" ]; }
    { users = [ "${myuser}" ]; keepEnv = true; noPass = true; cmd = "reboot"; }
  ];
}
