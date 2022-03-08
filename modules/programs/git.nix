{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "Actoriu";
      userEmail = "864149939@qq.com";
      extraConfig = {
        #url = {
        #  "https://github.com.cnpmjs.org/" = {
        #    insteadof = "https://github.com/";
        #  };
        #};
        core = {
          pager = "${pkgs.gitAndTools.delta}/bin/delta";
        };
        interactive = {
          diffFilter = "${pkgs.gitAndTools.delta}/bin/delta --color-only";
        };
        color = {
          ui = true;
        };
        diff = {
          colorMoved = "default";
        };
        delta = {
          line-numbers = true;
          side-by-side = true;
          features = "side-by-side line-numbers decorations";
          commit-decoration-style = "box";
          file-decoration-style = "box";
          hunk-header-decoration-style = "box";
        };
      };
    };
  };
}
