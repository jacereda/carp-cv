with import <nixpkgs> {};
{
  shellEnv =
    let
      carp = callPackage ../Carp/default.nix {};
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
        LIBRARY_PATH=libs;
        FRAMEWORK_PATH=frameworks;
        LD_LIBRARY_PATH=libs;
        PATH="${carp}/bin";
        XDGSHELL= lib.optionalString stdenv.isLinux "${wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml";
      };
}
