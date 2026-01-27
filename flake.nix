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
        helium =
          {
            enableFeatures ? [ ],
            libvaSupport ? pkgs.stdenv.hostPlatform.isLinux,
          }:
          pkgs.appimageTools.wrapType2 rec {

            pname = "helium";
            version = "0.8.3.1";

            src = pkgs.fetchurl {
              url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${pname}-${version}-x86_64.AppImage";
              sha256 = "sha256-GGltZ0/6rGQJixlGz3Na/vAwOlTeUR87WGyAPpLmtKM=";
            };

            _enableFeatures =
              enableFeatures
              ++ pkgs.lib.optionals libvaSupport [
                "VaapiVideoDecoder"
                "VaapiVideoEncoder"
              ];

            extraPkgs = pkgs: pkgs.lib.optionals libvaSupport [ pkgs.libva ];

            extraBwrapArgs = [
              "--ro-bind-try /etc/chromium /etc/chromium"
            ];

            nativeBuildInputs = [ pkgs.makeWrapper ];

            extraInstallCommands =
              let
                contents = pkgs.appimageTools.extract { inherit pname version src; };
              in
              ''
                wrapProgram $out/bin/${pname} \
                  ${pkgs.lib.optionalString (
                    _enableFeatures != [ ]
                  ) "--add-flags \"--enable-features=${pkgs.lib.strings.concatStringsSep "," _enableFeatures}\""}
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
        devShells.default = mkShell {
          buildInputs = [ statix ];
        };
        defaultPackage = helium { };
      }
    );
}
