# VM.nix

{ config, lib, ... }:

{
  # Spice
  services.spice-vdagentd.enable = true;

  # Needed for gpu passthrough as guest
  # https://old.reddit.com/r/NixOS/comments/14cjbnr/gpu_passthrough_wont_work_in_nixos_guest/
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  
  # Turn off Sleep & Suspend 
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
        {
            return polkit.Result.NO;
        }
    });
  '';
}

