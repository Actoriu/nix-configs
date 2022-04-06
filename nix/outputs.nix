{ self,
  nixpkgs,
  flake-utils,
  home-manager,
  # deploy-rs,
  nix-on-droid,
  # pre-commit-hooks,
  # sops-nix,
  ...
}@inputs:
flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShell = import ../shell.nix {
      inherit pkgs;
      # inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;
      # inherit (deploy-rs.packages.${pkgs.system}) deploy-rs;
      # inherit (sops-nix.packages.${pkgs.system}) sops-import-keys-hook;
    };
  }) // {
    nixOnDroidConfigurations = {
      oneplus5 = nix-on-droid.lib.nixOnDroidConfiguration {
        system = "aarch64-linux";
        config = ../hosts/oneplus5/default.nix
          # config = {
          #   imports = [
          #     ./nix-on-droid.nix
          #   ];
          #   home-manager = {
          #     backupFileExtension = "backup";
          #     useGlobalPkgs = true;
          #     useUserPackages = true;
          #     config = { config, pkgs, ... }: {
          #       nixpkgs = {
          #         config = {
          #           allowUnfree = true;
          #         };
          #       };
          #       imports = [ ./modules/programs/default.nix ];
          #     };
          #   };
          # };
      };
    };
    # deploy = {
    #   nodes.oneplus5.profiles.nix-on-droid = {
    #     hostname = "localhost";
    #     sshUser = "nix-on-droid";
    #     user = "nix-on-droid";
    #     path = deploy-rs.lib.aarch64-linux.activate.custom self.nixOnDroidConfigurations.oneplus5
    #   };
    # };
    # deploy = import ./nixos/deploy.nix (inputs // {
    #   inherit inputs;
    # });
    # hydraJobs =
    #   (nixpkgs.lib.mapAttrs' (name: config: nixpkgs.lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel) self.nixosConfigurations)
    #   // (nixpkgs.lib.mapAttrs' (name: config: nixpkgs.lib.nameValuePair "home-manager-${name}" config.activation-script) self.homeConfigurations);
    # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  }
