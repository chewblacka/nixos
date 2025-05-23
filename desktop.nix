# desktop.nix
{ config, lib, pkgs, ... }:

# Set desktop in configuration.nix
# Current desktops supported:
# kde
# pantheon

let
  myuser = config.myParams.myusername;
in
with lib;
{
  options = {  
    myDesktop = mkOption {
      type = types.str;
      default = "kde";
      description = "Desktop Environment to use";
    };
  };
  config = mkMerge [

  (mkIf (config.myDesktop == "kde") { 
    services.desktopManager.plasma6.enable = true;
    services = {
      xserver.enable = true;
      displayManager = {
        sddm.enable = true;
        defaultSession = "plasmax11";
        autoLogin.enable = true;
	      autoLogin.user = "${myuser}";
      };
    };
  })

  (mkIf (config.myDesktop == "hyprland") { 
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;    
    };
    # environment.sessionVariables = {
    #   WLR_NO_HARDWARE_CURSORS = "1";
    # };
    hardware = {
      opengl.enable = true;
    };
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ 
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk 
    ];
    environment.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
    # environment.systemPackages = [
    #   pkgs.waybar
    #   # Notifications
    #   pkgs.dunst
    #   pkgs.libnotify
    #   # Wallpapers
    #   unstable.pkgs.swww
    #   # terminal
    #   pkgs.kitty
    #   # App launcher
    #   pkgs.rofi-wayland
    # ];
  })

  (mkIf (config.myDesktop == "pantheon") { 
    services.xserver = {
      enable = true;
      displayManager.lightdm.autoLogin.timeout = 3600;
      desktopManager.pantheon = {
        enable = true;
        extraGSettingsOverrides = ''
        [org.gnome.settings-daemon.plugins.power]
        [io.elementary.terminal.settings] 
        font='Hack Nerd Font Mono 10'
        follow-last-tab=true
        '';
        extraGSettingsOverridePackages = [
          pkgs.pantheon.elementary-terminal 
        ];
      };
    };
  })

  (mkIf (config.myDesktop == "budgie") { 
    services.xserver = {
      enable = true;
      desktopManager.budgie.enable = true;
      displayManager.lightdm = {
        enable = true;
        autoLogin.timeout = 3600;
      };
    };
    xdg.portal.enable = true;
    # xdg.portal.extraPortals = [ 
    #   pkgs.xdg-desktop-portal
    #   pkgs.xdg-desktop-portal-gtk 
    # ];
  })

  # Common desktop config settings go below
  ({
    # X11 keymap
    services.xserver.xkb.layout = "gb";
  })
  ];
}
