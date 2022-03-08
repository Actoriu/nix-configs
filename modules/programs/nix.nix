{ ... }:

{
  nix = {
    package = pkgs.nix_2_4;
    extraConfig = ''
      experimental-features = nix-command flakes
    '';
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
      "https://nix-on-droid.cachix.org"
    ];
  };
}
