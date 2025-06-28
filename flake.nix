{
  description =
    "Repairis: A Linux-based repair tool and alternative to the Windows-based Medicat";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org" # Official cache server.
      "https://nix-community.cachix.org" # Nix community cache server.
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = let
      # Get pkgs specific to the system (x86_64-linux)
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      isoImageDerivation =
        self.nixosConfigurations.repairis.config.system.build.isoImage;
      isoFileName = "Repairis-${self.shortRev or "dirty"}.iso";
    in pkgs.runCommand isoFileName {
      inherit isoImageDerivation;
      nativeBuildInputs = [ pkgs.coreutils ];
    } ''
      # Find the actual .iso file within the derivation output
      isoPath=$(find "$isoImageDerivation" -name "*.iso" | head -n 1)
      if [ -z "$isoPath" ]; then
        echo "Error: Could not find ISO image in $isoImageDerivation" >&2
        exit 1
      fi
      cp "$isoPath" "$out/${isoFileName}"
    '';
    nixosConfigurations = {
      repairis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
        specialArgs = {
          inherit self; # Make `self` available to modules
          isoVersion =
            self.shortRev or "dirty"; # Pass the short commit hash or "dirty"
        };
      };
    };
  };
}
