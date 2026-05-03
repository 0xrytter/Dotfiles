{ config, pkgs, lib, pkgs-unstable, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../users/rytter.nix
  ];

  networking.hostName = "T480";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.networkmanager.wifi.powersave = false;

  services.displayManager.gdm.enable = true;

  services.libinput = {
    enable = true;
    touchpad = {
      tapping = false;
      scrollMethod = "none";
      middleEmulation = false;
      disableWhileTyping = true;
      naturalScrolling = false;
    };
  };

  services.xserver.displayManager.sessionCommands = ''
    xinput set-button-map 9 1 0 3 4 5 6 7
    xinput set-button-map 10 1 0 3 4 5 6 7
    xinput set-prop 10 "libinput Accel Speed" -0.8
    xinput set-prop 10 "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 1
  '';

  hardware.trackpoint = {
    enable = true;
    emulateWheel = false;
    sensitivity = 200;
  };

  environment.systemPackages = with pkgs; [
    claude-code
    bitwarden-desktop
    pkgs-unstable.bitwarden-cli
    teams-for-linux
    google-chrome
    gearlever
    libva mesa libglvnd libdrm wayland libinput
    xorg.libX11 xorg.libXext xorg.libXrender xorg.libXrandr
    xorg.libXfixes xorg.libXau xorg.libXdmcp
    libva-utils curl nss nspr zlib alsa-lib
    gnome2.GConf gcc.cc.lib libuv
  ];

  system.stateVersion = "24.11";
}
