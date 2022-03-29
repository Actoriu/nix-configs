{
  description = "nix-on-droid configuration";

  nixConfig = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    extra-substituters = [
      "https://actoriu.cachix.org"                                #     "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-on-droid.cachix.org"
    ];
    extra-trusted-public-keys = [
      "actoriu.cachix.org-1:htl65pXtoZ5aa5pgM5Rj42jg02WGBFabB8vcm3WVm8A="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
    ];
  };

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/release-21.11";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

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

    spacemacs = {
      url = "github:syl20bnr/spacemacs/develop";
      flake = false;
    };

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    { self
    , nixpkgs
    #, flake-utils
    , home-manager
    , nix-on-droid
    , ...
    }@inputs:
    #flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ] (system:
    #  let pkgs = nixpkgs.legacyPackages.${system};
    #  in { devShell = import ./shell.nix { inherit pkgs; }; }) // {
    {         nixOnDroidConfigurations = {
                device = nix-on-droid.lib.nixOnDroidConfiguration {
                  system = "aarch64-linux";
                  config = {
                    imports = [
                      ./nix-on-droid.nix
                    ];
                    home-manager = {
                      backupFileExtension = "backup";
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      config = { config, pkgs, ... }: {
                        nixpkgs = {
                          config = {
                            allowUnfree = true;
                          };
                        };
                        imports = [ ./modules/programs/default.nix ];
                      };
                    };
                  };
                  extraModules = [
                    # import source out-of-tree modules like:
                    # flake.nixOnDroidModules.module
                  ];
                  extraSpecialArgs = {
                    # arguments to be available in every nix-on-droid module
                  };
                  # your own pkgs instance (see nix-on-droid.overlay for useful additions)
                  # pkgs = ...;
                };
              };
    };
}
