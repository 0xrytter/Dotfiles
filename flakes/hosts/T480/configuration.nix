# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh_iso";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rytter = {
    isNormalUser = true;
    description = "Jakob Rytter";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  #Enable appimage
  programs.appimage.enable = true;

  # Enable click to run appimages
programs.appimage.binfmt = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable docker
  virtualisation.docker.enable = true;
  
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  
  # Needed for some dotnet bullshit, not sure exactly what
  
    environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    # Makes csharp_ls able to find dotnet installation
    DOTNET_ROOT = "$(dirname $(readlink -f $(which dotnet)))";
  };

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 
  
    
  # Add fish
  programs.fish.enable = true;
  users.users.rytter.shell = pkgs.fish;
  
  
    # Allow programs to execute other executables on nix. Specifically neccessary for 		 mason to launch LSP servers in neovim 
  programs.nix-ld.enable = true;

  # Add nerd font for proper icon and font rendering in terminal and other programs
  fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  
  
  


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
gwe
     git
     gh
     # Dependencies for neovim and others
     gcc13
     gnumake
     clang
     unzip
     ripgrep
     coreutils
     wget
     vimPlugins.telescope-live-grep-args-nvim
     xclip
     wl-clipboard
     # Kitty dependencies
     libxkbcommon
     # Z shell dependencies
     fzf
     zoxide
     # Doom emacs dependencies
     fd
     # Bazecor dependencies
     bazecor
     # Kanata
     kanata
     # Applications
     stow
     # Hyprland
     networkmanagerapplet
     wine
    wine64
     waybar
     dunst
     libnotify
     swww
     rofi-wayland
     grim
     slurp
     (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
     )
     obsidian
     appimage-run
     brave
     keepassxc
     ungoogled-chromium
     tmux
     neovim
     jetbrains.webstorm
     jetbrains.rider
     wezterm
     alacritty
     lazygit
     lazydocker
     docker-compose
qbittorrent
     # Combine multiple .NET SDKs using combinePackages function.
     (with dotnetCorePackages; combinePackages [ sdk_8_0_4xx sdk_9_0 ])
     erlang
     elixir
     nodejs_22
     pnpm
     python3
     webcord
     openssl 
     lutris
     cockatrice
     steam
     popsicle
     lsof
     inotify-tools
     beekeeper-studio
     zed-editor
     helix
     code-cursor
     vlc
     libreoffice-qt6-fresh
     discord
     postgresql
     # fuse is req for strongbox which is a wow addon manager
     fuse
     appimage-run
     vivaldi
     librewolf
gfn-electron
    pavucontrol
teams-for-linux
google-chrome
appimage-run
libva
mesa
libglvnd
libdrm
wayland
libinput
xorg.libX11
xorg.libXext
xorg.libXrender
xorg.libXrandr
xorg.libXfixes
xorg.libXau
xorg.libXdmcp
libva-utils
curl
nss
nspr
zlib
alsa-lib
gnome2.GConf
mesa
libglvnd
gcc.cc.lib
libuv
libva
gearlever
(import ./shadow.nix { inherit lib pkgs; })
     # utils to fix windows partition
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
