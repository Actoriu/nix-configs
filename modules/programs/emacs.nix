{ pkgs, ... }:

# let
#   spacemacs = pkgs.writeShellScriptBin "spacemacs" ''
#     # Init option {{{
#     Color_off='\033[0m'       # Text Reset

#     # terminal color template {{{
#     # Regular Colors
#     Black='\033[0;30m'        # Black
#     Red='\033[0;31m'          # Red
#     Green='\033[0;32m'        # Green
#     Yellow='\033[0;33m'       # Yellow
#     Blue='\033[0;34m'         # Blue
#     Purple='\033[0;35m'       # Purple
#     Cyan='\033[0;36m'         # Cyan
#     White='\033[0;37m'        # White

#     # Bold
#     BBlack='\033[1;30m'       # Black
#     BRed='\033[1;31m'         # Red
#     BGreen='\033[1;32m'       # Green
#     BYellow='\033[1;33m'      # Yellow
#     BBlue='\033[1;34m'        # Blue
#     BPurple='\033[1;35m'      # Purple
#     BCyan='\033[1;36m'        # Cyan
#     BWhite='\033[1;37m'       # White

#     # Underline
#     UBlack='\033[4;30m'       # Black
#     URed='\033[4;31m'         # Red
#     UGreen='\033[4;32m'       # Green
#     UYellow='\033[4;33m'      # Yellow
#     UBlue='\033[4;34m'        # Blue
#     UPurple='\033[4;35m'      # Purple
#     UCyan='\033[4;36m'        # Cyan
#     UWhite='\033[4;37m'       # White

#     # Background
#     On_Black='\033[40m'       # Black
#     On_Red='\033[41m'         # Red
#     On_Green='\033[42m'       # Green
#     On_Yellow='\033[43m'      # Yellow
#     On_Blue='\033[44m'        # Blue
#     On_Purple='\033[45m'      # Purple
#     On_Cyan='\033[46m'        # Cyan
#     On_White='\033[47m'       # White

#     # High Intensity
#     IBlack='\033[0;90m'       # Black
#     IRed='\033[0;91m'         # Red
#     IGreen='\033[0;92m'       # Green
#     IYellow='\033[0;93m'      # Yellow
#     IBlue='\033[0;94m'        # Blue
#     IPurple='\033[0;95m'      # Purple
#     ICyan='\033[0;96m'        # Cyan
#     IWhite='\033[0;97m'       # White

#     # Bold High Intensity
#     BIBlack='\033[1;90m'      # Black
#     BIRed='\033[1;91m'        # Red
#     BIGreen='\033[1;92m'      # Green
#     BIYellow='\033[1;93m'     # Yellow
#     BIBlue='\033[1;94m'       # Blue
#     BIPurple='\033[1;95m'     # Purple
#     BICyan='\033[1;96m'       # Cyan
#     BIWhite='\033[1;97m'      # White

#     # High Intensity backgrounds
#     On_IBlack='\033[0;100m'   # Black
#     On_IRed='\033[0;101m'     # Red
#     On_IGreen='\033[0;102m'   # Green
#     On_IYellow='\033[0;103m'  # Yellow
#     On_IBlue='\033[0;104m'    # Blue
#     On_IPurple='\033[0;105m'  # Purple
#     On_ICyan='\033[0;106m'    # Cyan
#     On_IWhite='\033[0;107m'   # White
#     # }}}

#     # version
#     Version="0.1"
#     # }}}

#     # need_cmd {{{
#     need_cmd () {
#         if ! command -v "$1" &>/dev/null; then
#             error "Need '$1' (command not found.)"
#             exit 1
#         fi
#     }
#     # }}}

#     # success/info/error/warn {{{
#     msg () {
#         printf '%b\n' "$1" >&2
#     }

#     success () {
#         msg "$Green[✔]$Color_off $1$2"
#     }

#     info () {
#         msg "$Blue[➭]$Color_off $1$2"
#     }

#     error () {
#         msg "$Red[✘]$Color_off $1$2"
#         exit 1
#     }

#     warn () {
#         msg "$Yellow[⚠]$Color_off $1$2"
#     }
#     # }}}

#     # echo_with_color {{{
#     echo_with_color () {
#         printf '%b\n' "$1$2$Color_off" >&2
#     }
#     # }}}

#     # check_requirements {{{
#     check_requirements () {
#         info "Checking Requirements for Spacemacs."
#         if command -v "git" &>/dev/null; then
#             git_version=$(git --version)
#             success "Check Requirements: $git_version"
#         else
#             warn "Check Requirements : git"
#         fi
#         if command -v "emacs" &>/dev/null; then
#             success "Check Requirements: emacs."
#         else
#             warn "Spacemacs need emacs."
#         fi
#         info "Checking true colors support in terminal:"
#         if command -v "bash" &>/dev/null; then
#             if command -v "curl" &>/dev/null; then
#                 bash -c "$(curl -fsSL https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh)"
#                 if [ $? -eq 0 ]; then
#                     success "The check is successful."
#                 else
#                     error "The check is failed."
#                     exit 0
#                 fi
#             else
#                 warn "Check Requirements: curl."
#             fi
#         else
#             warn "Check Requirements: bash."
#         fi
#     }
#     # }}}

#     # spacemacs_install {{{
#     spacemacs_install () {
#         if [[ ! -d "$HOME/.emacs.d/.git" ]]; then
#             info "Trying to clone Spacemacs."
#             git clone -b develop https://github.com/syl20bnr/spacemacs.git "$HOME/.emacs.d"
#             if [ $? -eq 0 ]; then
#                 success "The install is successful."
#             else
#                 error "The install is failed."
#                 exit 0
#             fi
#         else
#             warn "The install is failed."
#         fi
#     }
#     # }}}

#     # spacemacs_update {{{
#     spacemacs_update () {
#         if [[ -d "$HOME/.emacs.d/.git" ]]; then
#             info "Trying to update Spacemacs."
#             cd "$HOME/.emacs.d"
#             git pull --rebase
#             cd - > /dev/null 2>&1
#             if [ $? -eq 0 ]; then
#                 success "The update is successful."
#             else
#                 error "The update is failed."
#                 exit 0
#             fi
#         else
#             warn "The update is failed."
#         fi
#     }
#     # }}}

#     # spacemacs_update_packages {{{
#     spacemacs_update_packages () {
#         if [[ -d "$HOME/.emacs.d/.git" ]]; then
#             info "Trying to update packages for spacemacs."
#             cd "$HOME/.emacs.d"
#             emacs --quick --batch -l init.el \
#                   --eval="(configuration-layer/update-packages t)"
#             cd - > /dev/null 2>&1
#             if [ $? -eq 0 ]; then
#                 success "The update is successful."
#             else
#                 error "The update is failed."
#                 exit 0
#             fi
#         else
#             warn "The update is failed."
#         fi
#     }
#     # }}}

#     # spacemacs_uninstall {{{
#     spacemacs_uninstall () {
#         if [[ -d "$HOME/.emacs.d/.git" ]]; then
#             info "Trying to uninstall spacemacs."
#             rm -rfv "$HOME/.emacs.d"
#             if [ $? -eq 0 ]; then
#                 success "The uninstall is successful."
#             else
#                 error "The uninstall is failed."
#                 exit 0
#             fi
#         else
#             warn "The uninstall is failed."
#         fi
#     }
#     # }}}

#     # usage {{{
#     usage () {
#         echo "Spacemacs install script : [ Version: $Version ]"
#         echo ""
#         echo "Usage : curl -sLf https://spacevim.org/install.sh | bash -s -- [option] [target]"
#         echo ""
#         echo "  This is bootstrap script for Spacemacs."
#         echo ""
#         echo "OPTIONS"
#         echo ""
#         echo " -i, --install            install spacemacs for emacs."
#         echo " -c, --check              checkRequirements for Spacemacs."
#         echo " -e, --uninstall          Uninstall Spacemacs."
#         echo " -v, --version            Show version information and exit."
#         echo " -u  --update             update packages for Spacemacs."
#         echo ""
#         echo "EXAMPLE"
#         echo ""
#         echo "    Install Spacemacs for emacs."
#         echo ""
#         echo "        curl -sLf https://spacevim.org/install.sh | bash"
#         echo ""
#         echo "    Install Spacemacs for emacs only."
#         echo ""
#         echo "        curl -sLf https://spacevim.org/install.sh | bash -s -- --install"
#         echo ""
#         echo "    Uninstall Spacemacs"
#         echo ""
#         echo "        curl -sLf https://spacevim.org/install.sh | bash -s -- --uninstall"
#     }
#     # }}}
#     # install_done {{{
#     install_done () {
#         echo_with_color $Yellow ""
#         echo_with_color $Yellow "Almost done!"
#         echo_with_color $Yellow "=============================================================================="
#         echo_with_color $Yellow "==         Open emacs and it will install the plugins automatically         =="
#         echo_with_color $Yellow "=============================================================================="
#         echo_with_color $Yellow ""
#         echo_with_color $Yellow "That's it. Thanks for installing Spacemacs. Enjoy!"
#         echo_with_color $Yellow ""
#     }
#     # }}}

#     # welcome {{{
#     welcome () {
#         echo_with_color $Yellow " ┏━━━┓                                                                   "
#         echo_with_color $Yellow " ┃┏━┓┃ Welcome to                                                        "
#         echo_with_color $Yellow " ┃┗━━┓    ┏━━┓    ┏━━┓    ┏━━┓    ┏━━┓    ┏┓┏┓    ┏━━┓    ┏━━┓    ┏━━┓ b "
#         echo_with_color $Yellow " ┗━━┓┃┏━━┓┃┏┓┃┏━━┓┃┏┓┃┏━━┓┃┏━┛┏━━┓┃┃━┫┏━━┓┃┗┛┃┏━━┓┃┏┓┃┏━━┓┃┏━┛┏━━┓┃━━┫ e "
#         echo_with_color $Yellow " ┃┗━┛┃┗━━┛┃┗┛┃┗━━┛┃┏┓┃┗━━┛┃┗━┓┗━━┛┃┃━┫┗━━┛┃┃┃┃┗━━┛┃┏┓┃┗━━┛┃┗━┓┗━━┛┣━━┃ t "
#         echo_with_color $Yellow " ┗━━━┛    ┃┏━┛    ┗┛┗┛    ┗━━┛    ┗━━┛    ┗┻┻┛    ┗┛┗┛    ┗━━┛    ┗━━┛ a "
#         echo_with_color $Yellow "          ┃┃[The best editor is neither Emacs nor Vim, it's Emacs+Vim]   "
#         echo_with_color $Yellow "          ┗┛                                                             "
#         echo_with_color $Yellow "                      version : $Version      by : spacemacs.org       "
#     }
#     # }}}

#     ### main {{{
#     main () {
#         if [ $# -gt 0 ]; then
#             case $1 in
#                 --check|-c)
#                     check_requirements
#                     exit 0
#                     ;;
#                 --help|-h)
#                     usage
#                     exit 0
#                     ;;
#                 --install|-i)
#                     welcome
#                     need_cmd 'git'
#                     spacemacs_install
#                     install_done
#                     exit 0
#                     ;;
#                 --uninstall|-e)
#                     spacemacs_uninstall
#                     exit 0
#                     ;;
#                 --update|-u)
#                     spacemacs_update
#                     exit 0
#                     ;;
#                 --version|-v)
#                     msg "$Version"
#                     exit 0
#             esac
#         else
#             welcome
#             need_cmd 'git'
#             spacemacs_install
#             install_done
#             exit 0
#         fi
#                     }
#     # }}}

#     main $@
#   '';
# in
{
  programs = {
    emacs = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then pkgs.emacsMacport else pkgs.emacs-nox;
      # extraPackages = epkgs: with epkgs; [
      #   evil
      #   helm
      #   general
      #   magit
      #   nix-mode
      #   company
      # ];
    };
  };

  home = {
    packages = with pkgs; [
      ccls
      curl
      guile
      nodejs
      nodePackages.pyright
      openssh
      (python39.withPackages
        (ps: with ps; [
          epc
          flake8
          importmagic
          ipython
          isort
          # python_magic
          # pyqt5
          # pyqt5_sip
          # pyqtwebengine
          # pymupdf
          # pytaglib
          # psutil
          # qrcode
          # qtconsole
          # retrying
          # setuptools
        ]))
      ripgrep
      ripgrep-all
      # spacemacs
      translate-shell
    ];
  };

  # home.file.".emacs.d" = {
  #   source = pkgs.spacemacs;
  #   recursive = true;
  # };

  # home = {
  #   file = {
  #     ".emacs.d" = {
  #       source = pkgs.fetchFromGitHub {
  #         owner = "syl20bnr";
  #         repo= "spacemacs";
  #         rev = "2fd3eb3edbc7c09b825892ce53721120bb999504";
  #         sha256 = "00jpk6vhz3r2zbnm0xvqrglgd72m59xj6744r3p2canz0w9kkyhg";
  #       };
  #       recursive = true;
  #     };
  #   };
  # };

  # home = {
  #   file = {
  #     ".spacemacs.d" = {
  #       # source = ./init.el;
  #       source = builtins.fetchGit {
  #         url = "https://github.com/Actoriu/spacemacs.d";
  #         ref = "master";
  #       };
  #       recursive = true;
  #     };
  #   };
  # };

}
