{ lib, pkgs }:

let
  pname = "shadow";
  version = "appimage-local";

  # Reference the AppImage that sits in the same folder as configuration.nix
  # We turn the relative file into a file:// URL using toString + builtins.toPath.
  src = pkgs.fetchurl {
    url = "file://" + toString (builtins.toPath ./ShadowPC.AppImage);
    # Dummy hash first; the first build will tell you the real sha256.
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  contents = pkgs.appimageTools.extract { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  # T480 (Intel UHD 620) + libs Shadow asks for
  extraPkgs = p: with p; [
    libva
    libdrm
    mesa
    libglvnd
    wayland
    libinput

    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libXfixes
    xorg.libXau
    xorg.libXdmcp

    curl
    nss
    nspr
    zlib
    libuv
    gnome2.GConf
    alsa-lib

    intel-media-driver  # iHD for Gen8+
    vaapiIntel          # legacy fallback
  ];

  extraInstallCommands
