with import <nixpkgs> {};
{
  shellEnv =
    let
      linuxLibs = [ wayland egl-wayland libGL libxkbcommon libffi];
      xLibs = with pkgs.xorg; [ libX11 libXext libxcb libXau libXdmcp ];
      osLibs = lib.optionals stdenv.isLinux (linuxLibs ++ xLibs);
      frameworks = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
                 AppKit OpenGL CoreGraphics Foundation CoreFoundation
      ]);
      libs = lib.makeLibraryPath osLibs;
    in
      stdenv.mkDerivation {
        name = "shell-environment";
        nativeBuildInputs = with pkgs; [ pkg-config clang gdb ]
                                       ++ lib.optionals stdenv.isLinux [ wayland-protocols strace tinycc ];
        buildInputs = osLibs ++ frameworks;
        CARP_DIR="../Carp";
        PATH="../Carp/dist-newstyle/build/x86_64-osx/ghc-8.8.2/CarpHask-0.3.0.0/x/carp/build/carp";
        LIBRARY_PATH=libs;
        FRAMEWORK_PATH=frameworks;
        LD_LIBRARY_PATH=libs;
        XDGSHELL= lib.optionalString stdenv.isLinux "${wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml";
      };
}
