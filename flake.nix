{
  description = "nix-on-droid configuration";

  inputs = {
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    # nixos-latest.url = "github:NixOS/nixpkgs/master";
    # nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs = {
        nixpkgs.follows = "nixos-stable";
      };
    };

    devshell.url = "github:numtide/devshell";

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs = {
        nixpkgs.follows = "nixos-stable";
        flake-utils.follows = "flake-utils";
        home-manager.follows = "home-manager";
      };
    };

    spacemacs = {
      url = "github:syl20bnr/spacemacs/develop";
      flake = false;
    };
  };

  outputs = { self, ... } @ inputs:
    let
      nixpkgsconfig = {
        config = { allowUnfree = true; };
      };
      overlays = [
        (final: prev: { spacemacs = inputs.spacemacs; })
      ];
    in
    {
      nixOnDroidConfigurations = {
        oneplus5 = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          system = "aarch64-linux";
          config =
            { config
            , lib
            , ...
            }: {
              imports = [ ./hosts/oneplus5/default.nix ];
              home-manager = {
                backupFileExtension = "backup";
                # useGlobalPkgs = true;
                useUserPackages = true;
                config =
                  { config
                  , lib
                  , pkgs
                  , ...
                  }: {
                    nixpkgs.config = nixpkgsConfig;
                    nixpkgs.overlays = self.overlays;
                    home.stateVersion = "21.11";
                    imports = [ ./users/nix-on-droid/default.nix ];
                  };
              };
            };
        };
      };
    }
    // inputs.flake-utils.lib.eachSystem [ "aarch64-linux" ]
      (system: {
        legacyPackages = import inputs.nixos-stable {
          inherit system;
          inherit (nixpkgsConfig) config;
          overlays = self.overlays;
        };
        devShell =
          let
            pkgs = import inputs.nixos-stable {
              inherit system;
              inherit (nixpkgsConfig) config;
              overlays = [ inputs.devshell.overlay ];
            };
          in
          pkgs.devshell.mkShell {
            name = "nix-on-droid";
            imports = [ (pkgs.devshell.extraModulesDir + "/git/hooks.nix") ];
            git.hooks.enable = true;
            git.hooks.pre-commit.text = "${pkgs.treefmt}/bin/treefmt";
            packages = with pkgs; [
              cachix
              nix-build-uncached
              nixpkgs-fmt
              nodePackages.prettier
              nodePackages.prettier-plugin-toml
              shfmt
              treefmt
            ];
            devshell.startup.nodejs-setuphook = pkgs.lib.stringsWithDeps.noDepEntry ''
              export NODE_PATH=${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules:$NODE_PATH
            '';
          };
      });
}
