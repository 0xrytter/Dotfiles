{ lib, pkgs }:

let
  pname = "shadow";
  version = "appimage-local";

  # Absolute path to your AppImage in Downloads
  src = pkgs.fetchurl {
    url = "https://update.shadow.tech/launcher/prod/linux/ubuntu_18.04/ShadowPC.AppImage";
    # Put a dummy hash first; first build will print the correct sha256 to use
    hash = "sha256-pK3dSFDFQij/uJ6rwic8x32imF1EzPGjovkXrIUnszY=";
  };

  contents = pkgs.appimageTools.extract { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  # Libraries Shadow expects (based on your missing .so list and Ubuntu hints)
  # Tuned for ThinkPad T480 (Intel UHD 620).
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
    vaapiIntel          # legacy i965 fallback
  ];

  # Desktop entry + icons if present inside the AppImage
  extraInstallCommands = ''
    desk="$(find ${contents} -maxdepth 2 -name '*.desktop' | head -n1 || true)"
    if [ -n "$desk" ]; then
      install -Dm444 "$desk" "$out/share/applications/${pname}.desktop"
      substituteInPlace "$out/share/applications/${pname}.desktop" \
        --replace "Exec=AppRun" "Exec=${pname}"
      sed -i "s/^Name=.*/Name=Shadow/" "$out/share/applications/${pname}.desktop" || true
    fi
    if [ -d ${contents}/usr/share/icons ]; then
      cp -r ${contents}/usr/share/icons "$out/share/"
    fi
  '';

  meta = with lib; {
    description = "Shadow PC client (AppImage wrapped for NixOS)";
    homepage = "https://shadow.tech";
    license = licenses.unfreeRedistributable or licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
