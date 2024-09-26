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

  networking.hostName = "eris"; # Define your hostname.

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Fingerprint sensor settings
  services.fprintd.enable = true;

  services.fprintd.tod.enable = true;

  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;


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
    # zsh config
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        custom = "~/CMSC/cs-tools/configs/oh-my-zsh-custom";
      };
    };

    firefox.enable = true;
  };

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

    curl
    gmp
    ncurses
  ];
}
