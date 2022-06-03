{
  description = "nix-on-droid configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    devshell.url = "github:numtide/devshell";

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        home-manager.follows = "home-manager";
      };
    };

    spacemacs = {
      url = "github:syl20bnr/spacemacs/develop";
      flake = false;
    };
  };

  outputs = {self, ...} @ inputs:
    inputs.flake-utils.lib.eachSystem ["aarch64-linux"] (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = [inputs.devshell.overlay];
      };
    in {
      legacyPackages = pkgs;
      devShell = pkgs.devshell.fromTOML ./devshell.toml;
    })
    // {
      nixOnDroidConfigurations = {
        device = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          system = "aarch64-linux";
          config = {
            config,
            lib,
            ...
          }: {
            imports = [./hosts/oneplus5/default.nix];
            home-manager = {
              backupFileExtension = "backup";
              useGlobalPkgs = true;
              useUserPackages = true;
              config = {
                config,
                lib,
                pkgs,
                ...
              }: {
                nixpkgs = {
                  config.allowUnfree = true;
                  overlays = [
                    (final: prev: {spacemacs = inputs.spacemacs;})
                  ];
                  # ++ config.nixpkgs.overlays;
                };
                home.stateVersion = "21.11";
                imports = [./users/nix-on-droid/default.nix];
              };
            };
          };
        };
      };
    };
}
