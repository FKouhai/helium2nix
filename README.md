# Helium Browser Nix Flake

This Flake packages the helium browser using its AppImage binary.

**Upstream Repository** [Helium](https://github.com/imputnet/helium)

## Installation

To install helium using this Nix flake:

1. Add this repo to your flake inputs:
    ```nix
    inputs = {
      helium.url = "github:FKouhai/helium2nix/main";
    };
    ```

2. Add the package to your system packages:
    ```nix
    environment.systemPackages = [
      inputs.helium.defaultPackage.${system}
    ];
    ```

3. Rebuild your system: `sudo nixos-rebuild switch`

Alternatively, run directly without adding to your configuration:
- `nix run github:FKouhai/helium2nix/main`

## Contributing

We welcome contributions to improve this Nix flake for the helium browser!

### Updating the AppImage

1. Download the latest AppImage from the official Helium repository.
2. Update the URL and SHA256 hash in `flake.nix`:
    ```bash
    nix-prefetch-url <new-AppImage-URL>
    ```
3. Update the `url` and `sha256` fields in the `appimage` derivation.
4. Test the build: `nix build`
5. Commit the changes and create a pull request.

### Code Style and Guidelines

- Follow Nix flake conventions and standard formatting.
- Use lowercase with hyphens for package naming.
- Version strings should follow semantic versioning.
- Ensure the AppImage is executable at build time.
- For AppImage extraction issues, consider manual extraction with `--appimage-extract`.
- Test all changes thoroughly before submitting.

### Getting Started

1. Fork the repository on GitHub.
2. Clone your fork: `git clone https://github.com/FKouhai/helium2nix.git`
3. Make your changes.
4. Test with `nix build` and `nix run`.
5. Submit a pull request with a clear description of your changes.
