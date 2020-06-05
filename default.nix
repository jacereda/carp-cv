with import <nixpkgs> {};
{
  shellEnv =
    let
      mylibs = [ wayland egl-wayland libGL libxkbcommon libffi];
      xlibs = with pkgs.xorg; [ libX11 libXext libxcb libXau libXdmcp ];
      libs = lib.makeLibraryPath (mylibs ++ xlibs);
    in
      stdenv.mkDerivation {
        name = "shell-environment";
        nativeBuildInputs = with pkgs; [ pkg-config wayland-protocols tinycc clang strace ];
        buildInputs = mylibs;
        CARP_DIR="../Carp";
        PATH="../Carp/dist-newstyle/build/x86_64-linux/ghc-8.8.3/CarpHask-0.3.0.0/x/carp/build/carp";
        LIBRARY_PATH=libs;
        LD_LIBRARY_PATH=libs;
        XDGSHELL="${wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml";
      };
}
