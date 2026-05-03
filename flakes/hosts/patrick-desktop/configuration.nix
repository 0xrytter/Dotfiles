{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/hyprland.nix
    ../../modules/nvidia.nix
    ../../users/patrick.nix
  ];

  networking.hostName = "patrick-desktop";

  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };
  console.keyMap = "dk-latin1";

  virtualisation.waydroid.enable = true;
  programs.steam.enable = true;

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "24.05";
}
