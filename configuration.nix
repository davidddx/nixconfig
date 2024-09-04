# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
      };
    };
  };


  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    enable = true;
    font = "Lat2-Terminus16";
#   colors = [
#     "2a3b4d" #color0
#     "3d566f" #color1
#     "4b6988" #color2
#     "55799c" #color3
#     "7e90a3" #color4
#     "9fa2a6" #color5
#     "d6d7d9" #color6
#     "ffffff" #color7
#     "c4676c" #color8
#     "ff9966" #color9
#     "ffff66" #color0A
#     "66ff66" #color0B
#     "4b8f77" #color0C
#     "15f4ee" #color0D
#     "9c6cd3" #color0E
#     "bb64a9" #color0F
#   ];
# colors are commented out bc im trying to find a beautiful color combo and this one is ugly
  };

  # Enable the X11 windowing system.

  # builtin programs
  programs = {
    starship.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
      desktopManager.xterm.enable = false;
      #displayManager = {
      #  lightdm = {
      #    enable = true;
      #    greeters.gtk.enable = true;
      #    greeters.slick.theme.name = "Nordic";
      #  };
      #};
    };
    displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = true;
      autoLogin.user = "david";
    };

    # audio stuff
    pipewire = {
      enable = true;
      pulse.enable = true;
    };



  };


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.david = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox # browser
      neovim # text editor
      git # version management tool
      tmux #terminal multiplexer
      ripgrep # for nvim
      python311Packages.pynvim # for nvim
      nodejs_22 # for nvim
      cmake # generates C build files
      gnumake # compiles libraries for some extensions im using
    ];
  };

  environment.systemPackages = with pkgs; [
    #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    wget # downloading from url
    kitty # terminal
    jdk #java
    python311Full # python
    rocmPackages.llvm.clang-unwrapped # clang (C Compiler)
    gccgo14 # gcc (C compiler)
    xz # xz utils the one that got backdoored before
    unzip # unzips zip files
    unstable.fzf # fzf but unstable
    libgcc
    pkgs.fd # better alternative to find
  ]; 
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

