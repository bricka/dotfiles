# Path to your oh-my-zsh installation.
# export ZSH=~/.oh-my-zsh

# Theme
# This theme code was taken from the `mortalscumbag` theme from Oh My Zsh:
# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/mortalscumbag.zsh-theme
#
# I then converted a bunch of its logic away from OhMyZsh-specific stuff

function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return

  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(git_current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS%B%F{magenta}↑%b%f"
  fi

  # is branch behind?
  if $(echo "$(git log HEAD..origin/$(git_current_branch) 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS%B%F{green}↓%b%f"
  fi

  # is anything staged?
  if $(echo "$INDEX" | command grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | command grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS%B%F{red}●%b%f"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS%B%F{white}●%b%f"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | command grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS%B%F{red}✕%b%f"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "%F{white}‹ %B%F{yellow}$(my_current_branch)$STATUS%F{white}›%b%f"
}

function git_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

function my_current_branch() {
  echo $(git_current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%B%F{red}(ssh)%b%f "
  fi
}

function _toolbox_prompt_info() {
  if typeset -f toolbox_prompt_info > /dev/null; then
    toolbox_prompt_info
  fi
}

setopt PROMPT_SUBST
local ret_status="%(?:%F{green}:%B%F{red})%?%b%f"
PROMPT=$'\n$(_toolbox_prompt_info)$(ssh_connection)%{$fg_bold[green]%}%n@%m%{$reset_color%}$(my_git_prompt) : %~\n[${ret_status}] %# '

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

bindkey -v

export EDITOR="emacsclient -a emacs -t"
export VISUAL="emacsclient -a emacs -c"

export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

export NODE_ENV=development

autoload -U colors && colors

# Support for emacs vterm

if [ "$INSIDE_EMACS" = "vterm" ]; then
    vterm_printf(){
        if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
            # Tell tmux to pass the escape sequences through
            printf "\ePtmux;\e\e]%s\007\e\\" "$1"
        elif [ "${TERM%%-*}" = "screen" ]; then
            # GNU screen (screen, screen-256color, screen-256color-bce)
            printf "\eP\e]%s\007\e\\" "$1"
        else
            printf "\e]%s\e\\" "$1"
        fi
    }

    vterm_cmd() {
        local vterm_elisp
        vterm_elisp=""
        while [ $# -gt 0 ]; do
            vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
            shift
        done
        vterm_printf "51;E$vterm_elisp"
    }

    vterm_prompt_end() {
        vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
    }
    setopt PROMPT_SUBST
    PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
fi

source ~/.zshenv

if [ -e ~/.work.zsh ]; then
    source ~/.work.zsh
fi

if command -v brew &> /dev/null; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
