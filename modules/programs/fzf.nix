{ ... }:

{
  programs = {
    fzf = {
      enable = true;
      # defaultCommand = "${pkgs.ripgrep}/bin/rg --files --hidden --follow --no-ignore -g '!{.git,target,node_modules,*.swp,dist,*.coffee}/*' 2> /dev/null";
    };
  };
}
