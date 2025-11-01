{
  description = "Helium AppImage nixified";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        helium = pkgs.appimageTools.wrapType2 rec {

          pname = "helium";
          version = "0.6.2.1";

          src = pkgs.fetchurl {
            url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${pname}-${version}-x86_64.AppImage";
            sha256 = "sha256-91Tgel9w8ZkH34NjAV776CO+Us4c1gg7rI+wkwns+tk=";
          };

          extraInstallCommands =
            let
              contents = pkgs.appimageTools.extract { inherit pname version src; };
            in
            ''

              install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
              substituteInPlace $out/share/applications/${pname}.desktop \
                --replace 'Exec=AppRun' 'Exec=${pname}'
              cp -r ${contents}/usr/share/icons $out/share
            '';

        };
      in
      with pkgs;
      {
        inherit helium;
        defaultPackage = helium;
      }
    );
}
