# https://github.com/NixOS/nixpkgs/issues/327982#issuecomment-2684907720
{
  pkgs,
  cmake,
  stdenv,
  fetchFromGitHub,
  sdl3,
  freetype,
  physfs,
  libmodplug,
  mpg123,
  libvorbis,
  libogg,
  libtheora,
  which,
  libtool,
  harfbuzz,
  openal,
  luajit,
  curl,
  ...
}: stdenv.mkDerivation (finalAttrs: {
  pname = "love";
  version = "12.0";

  src = fetchFromGitHub {
    owner = "love2d";
    repo = "love";
    rev = "main";
    sha256 = "sha256-r1pG/tPxmsdfJLZdU7ydtAbKq4QYk48gjqaSiizaYYo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    # pkgs.xorg.libX11
    # pkgs.xorg.libX11.dev
    # pkgs.xorg.libXcursor
    # pkgs.xorg.libXi
    # pkgs.xorg.libXrandr
    sdl3
    freetype
    physfs
    libmodplug
    mpg123
    libvorbis
    libogg
    libtheora
    which
    libtool
    harfbuzz
    openal
    luajit
    curl
  ];

  meta = {
    description = "An awesome Lua game framework";
    homepage = "https://love2d.org/";
    license = pkgs.lib.licenses.zlib;
    maintainers = with pkgs.lib.maintainers; [  ];
  };
})


