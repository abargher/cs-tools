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


  # networking.firewall = {
  #   allowedUDPPorts = [ 51820 ];
  #   allowedTCPPorts = [ 51820 ];
  # };

  # enable wireguard
  networking.wireguard.enable = true;
  # See https://nixos.wiki/wiki/WireGuard
  #networking.wireguard.interfaces = {
  #  wg0 = {
  #    ips = [ "10.66.66.5/24" "fd42:42:42::5/64" ];
  #    listenPort = 51820;

  #    privateKeyFile = ~/.config/wireguard/wireguard-privkey;

  #    peers = [
  #      {
  #        # Public key of the server (not a file path).
  #        publicKey = "YlodQU3QNzL6fqxH1kKun24/XmkXIymH36efWz5lHhs=";

  #        # Forward all the traffic via VPN.
  #        allowedIPs = [ "0.0.0.0/0" ];
  #        # Or forward only particular subnets
  #        #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

  #        # Set this to the server IP and port.
  #        endpoint = "73.209.174.2:51820";

  #        # Send keepalives every 25 seconds. Keeps NAT tables alive.
  #        persistentKeepalive = 25;
  #      }
  #    ];
  #  };
  #};

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
    enable = false;
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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      # user packages here
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
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };


  virtualisation.docker.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # add missing dynamic libraries for unpackages programs here
      fswatch
      libstdcxx5
      libgcc
      pico-sdk
      systemdLibs
      platformio-core
      protobufc
      protobuf
    ];
  };

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
    adwaita-icon-theme
    gtk3
    gtk4

    # hyprland
    kitty
    wofi
    waybar
    hyprpaper
    hypridle
    unstable.hyprlock
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
    (unstable.python3.withPackages (python-pkgs: with python-pkgs; [
      pygobject3
      pygobject-stubs
      gst-python
      gtk3
      pygments
      pip
      virtualenv
      black
      isort
      pytest
      pytest-json-report
      pyzmq
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
    libclang
    gcc
    gnumake
    unstable.vscode
    # unstable.zed-editor
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
    nodejs_22
    wireshark
    llvm
    gimp-with-plugins
    glow
    zathura
    docker
    docker-client
    valgrind
    gdb
    unstable.lldb
    fswatch
    inetutils
    pico-sdk
    libreoffice-fresh
    protobuf
    protobufc
    criterion
    nixd
    minicom
    unzip
    protobufc
    protobuf
    gnomeExtensions.wireguard-vpn-extension
    unstable.go
    rustup
    unstable.kicad
    unstable.turbocase
    openresolv
  ];
}
