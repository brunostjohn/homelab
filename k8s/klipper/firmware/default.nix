{ pkgs ? import <nixpkgs> {} }:


pkgs.stdenv.mkDerivation {
  pname = "klipper-ender-v3-se-with-display";
  version = "v0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "jpcurti";
    repo = "ender3-v3-se-klipper-with-display";
    rev = "master";
    sha256 = "sha256-XfiiQIHIs0CkAH0Aewz9nV8Zr2HjSFX+Y7TbOK3dIsc=";
  };

  nativeBuildInputs = with pkgs; [
    python311
    gnumake
    gcc-arm-embedded
  ];

  configurePhase = ''
    echo "Copying build.conf..."
    cp build.conf $TMP/.config
  '';

  buildPhase = ''
    echo "Building Klipper..."
    make
  '';

  installPhase = ''
    echo "Copying Klipper..."
    mkdir -p $out/bin
    cp -r out/klipper $out/bin/
  '';
}