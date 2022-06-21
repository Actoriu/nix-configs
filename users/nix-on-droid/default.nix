{ ... }: {
  imports = [ ../modules/default.nix ];

  programs.home-manager.enable = true;
  manual.manpages.enable = false;

  custom = {
    development = {
      # cc.enable = true;
      nodejs.enable = true;
      python.enable = true;
      # texlive.enable = true;
    };
    editors = {
      emacs = {
        enable = true;
        spacemacs = true;
      };
      # neovim.enable = true;
    };
    shell = {
      bat.enable = true;
      dircolors.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      git.enable = true;
      gnupg.enable = true;
      openssh.enable = true;
      password-store.enable = true;
      # tmux.enable = true;
      xdg.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
    };
  };
}
