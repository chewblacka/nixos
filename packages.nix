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

# Packages I'm currentl testing out
# Once accepted place in another list
_testing = [
    bitwig-studio
    decent-sampler
    # ulauncher
    # (vivaldi.override { proprietaryCodecs = true; })
    # (vivaldi.override { proprietaryCodecs = false; })
    # vivaldi
    baresip
    jujutsu
    audacious
    ocenaudio
    (ventoy.override { defaultGuiType = "gtk3"; })
    # python3Packages.pyradios
    # electrum
    # (inxi.override { withRecommends = true; })
    # (lshw.override { withGUI = true; })
    # anki-bin
    # mpv
    vlc
    # kdePackages.plasmatube
    # openvswitch
    # davinci-resolve
    # brave
    # OVMFFull.fd
    # spotify
    # thunderbird
    # codebraid
    # tinycc
    # grim
    # pdfstudio2023
    # logseq
    get_iplayer
    yt-dlp
    # cool-retro-term
    glxinfo        
    # firefox
    lf
    ueberzug
    # spaceFM
    # distrobox-git
    distrobox
    onedrive
    # unstable.distrobox
    # toolbox
    # appimage-run
    # unstable.freetube
    # anki
    # anki-bin
];

# Package set names must differ from packages
# Otherwise recursion nastiness
my-package-set = builtins.concatLists [
    _testing
    _helix
    _typst
    _shell 
    _cli
    _nix
    # _security
    # _gui
    _browsers
    _misc
    _DE # DE specific packages
    _scripting
    _vlang
    _mathematica
    # install
]; 

# Tools needed for building on nix
_nix = [
    dpkg
    # nix formatters
    alejandra
    nixfmt-rfc-style
    nixpkgs-review
    nix-update
    nix-index
    nix-tree
    common-updater-scripts
    # nix-shell into fish / zsh 
    any-nix-shell
    nix-init
    nh
    # the below 2 are part of nh, but useful on their own too
    # nom - a drop-in replacement for nix command
    nix-output-monitor
    # nvd can be used to e.g. diff system generations i.e.:
    # nvd diff /nix/var/nix/profiles/system-{463,464}-link
    nvd
];

_vlang = [
    xorg.libX11.dev
    xorg.libXcursor.dev 
    xorg.libXi.dev 
    libGL.dev  
];

_mathematica = [
    envsubst # Needed for mathematica podman install
    xorg.xhost # Mathematica
];

_helix = [
    helix
    neovim
    # lsp for nix
    nil
    # lsp for bash
    # nodePackages.bash-language-server
];

_typst = [
    typst
    typst-lsp
    typstfmt
    # hayagriva
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
    unzip
    ripgrep
    fzf
    eza # replacement for exa
    bat
    fd # find replacement
    jq
    # appimage-run
    trash-cli
    tree
    neofetch
    fastfetch # neofetch replacement
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
    # librewolf # hardened ff
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
    kdePackages.discover
    # kdePackages.kate (kate installed by default in Plasma 6)
    # packagekit
    # kdePackages.packagekit-qt
    # kdePackages.kinfocenter # Info center
    # latte-dock
] 
else if (config.myDesktop == "pantheon") then
[
    gsettings-desktop-schemas
    pantheon-tweaks
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
