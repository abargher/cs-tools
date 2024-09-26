# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/common.nix
    ];

  networking.hostName = "eris";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

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
      kdePackages.kate
    ];
    shell = pkgs.zsh;
  };

  programs = {
    firefox.enable = true;

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
    unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  in
  [
    # hardware specific
    fprintd

    # common packages
    vim-full
    tmux
    wget
    git
    file
    google-chrome
    neofetch
    fzf
    zoxide
    python3
    cmake
    clang
    gcc
    gnumake
    python311Packages.pygments
    vscode
    unstable.zed-editor
    alejandra
    spotify
    discord
    usbutils
    curl
    gmp
    ncurses
    tree
    kitty
  ];
}
