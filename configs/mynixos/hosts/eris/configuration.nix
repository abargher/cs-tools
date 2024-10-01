# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, unstable-pkgs, inputs, ... }:

{
  _module.args.unstable-pkgs = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "eris";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.displayManager.defaultSession = "Hyprland";
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  # services.desktopManager.plasma6.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # security.pam.services.kwallet = {
  #   name = "kwallet";
  #   enableKwallet = true;
  # };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Fingerprint sensor settings
  security.pam.services.sudo.fprintAuth = false; # disable fingerprint sudo
  services.fprintd = let
    fingerprint-module = inputs.nixos-06cb-009a-fingerprint-sensor;
  in
  {
    enable = true;
    tod = {
      enable = true;
      driver = fingerprint-module.lib.libfprint-2-tod1-vfs0090-bingch {
        calib-data-file = ./calib-data.bin;
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alec = {
    isNormalUser = true;
    description = "Alec";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # user packages here
      python311Packages.pygments
      python311Packages.pygobject3
      python311Packages.pygobject-stubs
    ];
    shell = pkgs.zsh;
  };

  programs = {
    firefox.enable = true;

    dconf.enable = true;
    dconf.profiles = {
      user.databases = [{
        settings = with lib.gvariant; {
          "org/gnome/desktop/interface".color-scheme = "prefer-dark";
          "org/gnome/desktop/interface".gtk-theme = "rose-pine-gtk";
          "org/gnome/desktop/interface".icon-theme = "rose-pine-icons";
          "org/gnome/desktop/interface".cursor-theme = "Adwaita";
        };
      }];
    };


    # zsh config
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        custom = "~/CMSC/cs-tools/configs/oh-my-zsh-custom";
      };
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
  let
    unstable = unstable-pkgs;
  in
  [
    # hardware specific
    fprintd

    # GNOME
    gnome.adwaita-icon-theme
    gtk3
    gtk4

    # hyprland
    kitty
    rofi # pick one of rofi/wofi?
    wofi
    waybar
    hyprpaper
    hypridle
    hyprlock
    hyprcursor
    waypaper
    pywal
    grim
    slurp
    wlogout
    networkmanagerapplet
    font-awesome
    kwallet-pam
    dunst
    xdg-desktop-portal-gtk
    adw-gtk3
    nwg-look
    adwaita-qt
    rose-pine-gtk-theme
    brightnessctl
    pavucontrol
    blueberry
    playerctl
    mpc-cli
    mpd
    sonata

    # python
    (python3.withPackages (python-pkgs: with python-pkgs; [
      pygobject3
      pygobject-stubs
      gst-python
      gtk3
      pygments
      pip
      virtualenv
    ]))

    # common packages
    vim-full
    tmux
    wget
    git
    file
    google-chrome
    gobject-introspection
    neofetch
    fzf
    zoxide
    cmake
    clang
    gcc
    gnumake
    unstable.vscode
    unstable.zed-editor
    alejandra
    spotify
    discord
    usbutils
    curl
    gmp
    ncurses
    tree
    slack
    htop
    killall
  ];
}
