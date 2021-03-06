{ self
, config
, inputs
, pkgs
, ...
}: {
  nix = {
    package = pkgs.nix_2_7;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
      "https://nix-on-droid.cachix.org"
    ];
  };

  time.timeZone = "Asia/Shanghai";

  user.shell = "${pkgs.zsh}/bin/zsh";

  environment = {
    # Simply install just the packages
    packages = with pkgs; [
      # User-facing stuff that you really really want to have
      # vim  # or some other editor, e.g. nano or neovim

      # Some common stuff that people expect to have
      diffutils
      findutils
      utillinux
      tzdata
      hostname
      man
      gawk
      gnugrep
      gnupg
      gnused
      gnutar
      bzip2
      gzip
      xz
      zip
      unzip
    ];

    # Backup etc files instead of failing to activate generation if a file already exists in /etc
    etcBackupExtension = ".bak";
  };

  # Read the changelog before changing this value
  system.stateVersion = "21.11";

  # nix-channel --add https://github.com/rycee/home-manager/archive/release-21.11.tar.gz home-manager
  # nix-channel --update
  # you can configure home-manager in here like
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    config = { config, lib, pkgs, ... }: {
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          (final: prev: { spacemacs = inputs.spacemacs; })
        ] ++ config.nixpkgs.overlays;
      };
      home.stateVersion = "21.11";
      imports = [ ./users/nix-on-droid/default.nix ];
    };
  };
}
# vim: ft=nix
