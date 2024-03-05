# flatpak.nix
{ config, pkgs, lib, ... }:

{
  ### Flatpak ###
  services.flatpak.enable = true;

  # Daily updates with systemd
  systemd.services.flatpak-update = {
    serviceConfig.Type = "oneshot";
    path = [ pkgs.flatpak ];
    serviceConfig.ExecStart = "${pkgs.flatpak}/bin/flatpak update -y";
  };
  systemd.timers.flatpak-update = {
    wantedBy = [ "timers.target" ];
    partOf = [ "flatpak-update.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 15:20:00";
      Unit = "flatpak-update.service";
    };
  };
  # XDG portals for sandboxed apps
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
