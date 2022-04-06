{
  description = "nix-on-droid configuration";

  nixConfig = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    extra-substituters = [
      "https://cache.nixos.org"
      "https://actoriu.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-on-droid.cachix.org"
      "https://pre-commit-hooks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "actoriu.cachix.org-1:htl65pXtoZ5aa5pgM5Rj42jg02WGBFabB8vcm3WVm8A="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
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

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        home-manager.follows = "home-manager";
      };
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs ={
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    spacemacs = {
      url = "github:syl20bnr/spacemacs/develop";
      flake = false;
    };

    templates = {
      url = "github:NixOS/templates";
    };

  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    {
      deploy = import ./nix/deploy.nix inputs;

      overlays.default = import ./nix/overlay.nix inputs;

      homeConfigurations = import ./nix/home-manager.nix inputs;
    }
    // flake-utils.lib.eachDefaultSystem (system: {
      checks = import ./nix/checks.nix inputs system;

      devShells.default = import ./nix/dev-shell.nix inputs system;

      packages = {
        default = self.packages.${system}.hosts;
        hosts = import ./nix/build-hosts.nix inputs system;
      };

      legacyPackages = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
        config.allowUnfree = true;
        config.allowAliases = true;
      };
    });
}
