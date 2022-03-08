{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      history = {
        extended = true;
        save = 100000;
        size = 100000;
        # path = "${toString config.xdg.configHome}/zsh/zsh_history";
      };

      autocd = true;
      #enableAutosuggestions = true;
      enableCompletion = true;

      initExtra = with pkgs; ''
          setopt nomatch
          setopt extendedglob
          setopt rm_star_silent
          setopt clobber
          setopt combining_chars
          setopt interactive_comments
          setopt rc_quotes
          unsetopt mail_warning
          setopt long_list_jobs
          setopt auto_resume
          setopt notify
          unsetopt bg_nice
          unsetopt hup
          unsetopt check_jobs
          setopt auto_pushd
          setopt pushd_ignore_dups
          setopt pushd_silent
          setopt pushd_to_home
          setopt cdable_vars
          setopt multios
          setopt extended_glob
          unsetopt clobber
          setopt bang_hist
          setopt complete_in_word
          setopt always_to_end
          setopt path_dirs
          setopt auto_menu
          setopt auto_list
          setopt auto_param_slash
          setopt extended_glob
          unsetopt menu_complete
          unsetopt flow_control

          export LESS_TERMCAP_mb=$'\E[01;31m'
          export LESS_TERMCAP_md=$'\E[01;31m'
          export LESS_TERMCAP_me=$'\E[0m'
          export LESS_TERMCAP_se=$'\E[0m'
          export LESS_TERMCAP_so=$'\E[00;47;30m'
          export LESS_TERMCAP_ue=$'\E[0m'
          export LESS_TERMCAP_us=$'\E[01;32m'

          source ${zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
          source ${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
          source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          #source ${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
          # ${zsh-completions}

          #eval "$(jump shell)"
          #eval $(thefuck --alias)
          function set_win_title(){
              echo -ne "\033]0; $TERM - $PWD \007"
                                     }
          precmd_functions+=(set_win_title)

          # Emacs
          bindkey -M emacs "^P" history-substring-search-up
          bindkey -M emacs "^N" history-substring-search-down

          # Vi
          bindkey -M vicmd "k" history-substring-search-up
          bindkey -M vicmd "j" history-substring-search-down

          # Emacs and Vi
          for keymap in 'emacs' 'viins'; do
            bindkey "$terminfo[kcuu1]" history-substring-search-up
            bindkey "$terminfo[kcud1]" history-substring-search-down
          done

          unset keymap
      '';
    };
  };
}
