# packages.nix
{ config, pkgs, ... }: with pkgs;

rec {

distrobox-git = pkgs.distrobox.overrideAttrs (oldAttrs: {
    version = "1.5.0.2.20230920";
    src = fetchFromGitHub {
        owner = "89luca89";
        repo = "distrobox";
        rev = "c12d3c1";
        hash = "sha256-Hy6bbMjFlXNd5IpUCAlVcwN/sQQjCypxdf2oMl4bVV0=";
    };    
});

# either ventoy-full or ventoy
# ventoy-gui = pkgs.ventoy.override {
#   # either withGtk3 or withQt5
#   withQt5 = true;
# };

# Packages I'm currentl testing out
# Once accepted place in another list
_testing = [
    # python3Packages.pyradios
    mpv
    vlc
    # openvswitch
    # davinci-resolve
    # brave
    # OVMFFull.fd
    # spotify
    # ventoy-gui
    # thunderbird
    nixpkgs-review
    # codebraid
    # git-credential-manager
    tinycc
    grim
    # unstable.gnome-text-editor
    # gnome.gedit
    # pdfstudio2023
    # logseq
    # unstable.remnote
    get_iplayer
    yt-dlp
    cool-retro-term
    glxinfo        
    firefox
    nix-update
    lf
    ueberzug
    nix-index
    nix-tree
    envsubst # Needed for mathematica podman install
    xorg.xhost # Mathematica
    spaceFM
    # distrobox-git
    distrobox
    # unstable.distrobox
    toolbox
    # appimage-run
    # unstable.freetube
    # anki
    # anki-bin
];

# Package set names must differ from packages
# Otherwise recursion nastiness
my-package-set = builtins.concatLists [
    _testing
    _helix # Packages relating to helix
    _shell 
    _cli
    # security
    # gui
    # browsers
    _misc
    _DE # DE specific packages
    _scripting
    _vlang
    # install
]; 

_vlang = [
    xorg.libX11.dev
    xorg.libXcursor.dev 
    xorg.libXi.dev 
    libGL.dev  
];

_helix = [
    helix
    # nix lsp
    nil
    # bash lsp
    nodePackages.bash-language-server
];

_shell = [
    zsh # Is this needed?
    mcfly # cross-shell command line history    
];

_cli = [
    shellcheck # is this still needed?
    alejandra # nix format checker
    direnv
    pv # progress viewer
    wget
    # git
    unzip
    ripgrep
    fzf
    eza # replacement for exa
    bat
    jq
    # appimage-run
    trash-cli
    tree
    neofetch
    efibootmgr # for managing efi
    zsh
    docfd
    # distrobox
    
    # Are these needed?
    # xorg.xhost
    # spice-vdagent
    # x11spice

    
    get_iplayer

    
];

_security = [
    firejail
    # lynis # security auditing tool
];

_gui = [
    gparted # disk formatting
    glxinfo # =glxgears
    filelight # disk usage
    # logseq
    # signal-desktop
    obsidian
];

_browsers = [
    firefox
    librewolf # hardened ff
    # unboogled-chromium
];

_misc = [
    gnome-icon-theme
    aspell
    aspellDicts.en
    # hunspell
    # hunspellDicts.en-gb-ize
];

# Desktop Specific packages
_DE = (
if (config.myDesktop == "kde") then
[
    discover
    # kdePackages.kate (kate installed by default in Plasma 6)
    # packagekit
    # kdePackages.packagekit-qt
    # kdePackages.kinfocenter # Info center
    # latte-dock
] 
else if (config.myDesktop == "pantheon") then
[
    gsettings-desktop-schemas
]
else if (config.myDesktop == "hyprland") then
[
    waybar
    dunst
    libnotify
    swww
    kitty
    rofi-wayland
    kdePackages.dolphin
    adwaita-qt
    kdePackages.qt5ct
    kdePackages.kio-extras
    xfce.thunar
]
else [ ]);

_scripting = [
    kdePackages.kdialog # QT Dialog boxes for shell scripts
    nix-prefetch-docker # used to get hash info for building docker images with nix
    desktop-file-utils # set of cli tools for .desktop files
    # gettext # what is this?
];

# A minimal set of packages for install
_install = [
    direnv
    wget
    git
    unzip
    trash-cli
    neofetch
    efibootmgr # for managing efi
    zsh
    sqlite # needed for histdb    
];

}
