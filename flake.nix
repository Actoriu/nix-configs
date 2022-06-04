{
  description = "nix-on-droid configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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
        config.allowUnfree = true;
        overlays = [
          inputs.devshell.overlay
          (final: prev: {spacemacs = inputs.spacemacs;})
        ];
      };
    in {
      devShell = pkgs.devshell.mkShell {
        name = "nix-on-droid-config";
        imports = [(pkgs.devshell.extraModulesDir + "/git/hooks.nix")];
        git.hooks.enable = true;
        git.hooks.pre-commit.text = "${pkgs.treefmt}/bin/treefmt";
        packages = with pkgs; [
          alejandra
          cachix
          nix-build-uncached
          nodePackages.prettier
          nodePackages.prettier-plugin-toml
          shfmt
          treefmt
        ];
        devshell.startup.nodejs-setuphook = pkgs.lib.stringsWithDeps.noDepEntry ''
          export NODE_PATH=${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules:$NODE_PATH
        '';
      };
    })
    // {
      nixOnDroidConfigurations = {
        oneplus5 = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
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
                  overlays = [(final: prev: {spacemacs = inputs.spacemacs;})];
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
