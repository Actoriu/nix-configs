{
  description = "nix-on-droid configuration";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-21.11";
    # latest.url = "github:NixOS/nixpkgs/master";
    # unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # flake-utils.url = "github:numtide/flake-utils";

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs = {
        nixpkgs.follows = "nixos";
      };
    };

    devshell.url = "github:numtide/devshell";

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils-plus/flake-utils";
        home-manager.follows = "home-manager";
      };
    };

    spacemacs = {
      url = "github:syl20bnr/spacemacs/develop";
      flake = false;
    };
  };

  outputs = { self, nixos, ... } @ inputs:
    inputs.flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "aarch64-linux" ];

      channelsConfig = { allowUnfree = true; };

      sharedOverlays = [
        inputs.devshell.overlay
        (final: prev: { spacemacs = inputs.spacemacs; })
      ];

      hostDefaults = {
        system = "aarch64-linux";
        channelName = "nixos";
      };

      hosts.droid = {
        output = "nixOnDroidConfigurations";
        builder = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          config = import ./hosts/oneplus5 { inherit self inputs; };
        };
      };

      outputsBuilder = channels: with channels.nixos; {
        devShells.default = pkgs.devshell.mkShell {
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
      };
    };
}

#     let
#       nixpkgsConfig = {
#         config = { allowUnfree = true; };
#       };
#       overlays = [
#         (final: prev: { spacemacs = inputs.spacemacs; })
#       ];
#     in
#       {
#         nixOnDroidConfigurations = {
#           oneplus5 = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
#             system = "aarch64-linux";
#             config =
#               { config
#               , lib
#               , ...
#               }: {
#                 imports = [ ./hosts/oneplus5/default.nix ];
#                 home-manager = {
#                   backupFileExtension = "backup";
#                   # useGlobalPkgs = true;
#                   useUserPackages = true;
#                   config =
#                     { config
#                     , lib
#                     , pkgs
#                     , ...
#                     }: {
#                       nixpkgs.config = nixpkgsConfig;
#                       nixpkgs.overlays = { inherit overlays; };
#                       home.stateVersion = "21.11";
#                       imports = [ ./users/nix-on-droid/default.nix ];
#                     };
#                 };
#               };
#           };
#         };
#       }
#       // inputs.flake-utils.lib.eachSystem [ "aarch64-linux" ]
#         (system: {
#           legacyPackages = import inputs.nixos {
#             inherit system;
#             inherit (nixpkgsConfig) config;
#             overlays = self.overlays;
#           };
#           devShells =
#             let
#               pkgs = import inputs.nixos {
#                 inherit system;
#                 inherit (nixpkgsConfig) config;
#                 overlays = [ inputs.devshell.overlay ];
#               };
#             in
#               pkgs.devshell.mkShell {
#                 name = "nix-on-droid";
#                 imports = [ (pkgs.devshell.extraModulesDir + "/git/hooks.nix") ];
#                 git.hooks.enable = true;
#                 git.hooks.pre-commit.text = "${pkgs.treefmt}/bin/treefmt";
#                 packages = with pkgs; [
#                   cachix
#                   nix-build-uncached
#                   nixpkgs-fmt
#                   nodePackages.prettier
#                   nodePackages.prettier-plugin-toml
#                   shfmt
#                   treefmt
#                 ];
#                 devshell.startup.nodejs-setuphook = pkgs.lib.stringsWithDeps.noDepEntry ''
#               export NODE_PATH=${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules:$NODE_PATH
#             '';
#               };
#         });
# }
