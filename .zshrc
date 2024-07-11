export LC_ALL=en_US.UTF-8
export LC_TYPE=utf-8

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LESS='-R -w'
export MANWIDTH=80

export HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
export HISTSIZE=1000
export SAVEHIST=1000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS

# don't jump over entire /path/to/file, but from word to word separated by /
# by default: export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
# we take out the slash, period, angle brackets, dash here.
export WORDCHARS='*?_[]~=&;!#$%^(){}'

alias ls='ls --color=auto -hF'
alias grep='grep --color=auto'
alias du='du -h'
alias df='df -h'
alias cal='cal -m'
alias music='ncmpc'
[[ -x "$(command -v mimeo)" ]] && alias open='mimeo'
alias mnt='udisksctl mount -b'
alias umnt='udisksctl unmount -b'
alias be='bundle exec'
alias gc='git commit --verbose'
alias gca='git commit --verbose --amend'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gr='git rebase'
alias gl='git l'
alias gg='git g'
alias ga='git add'
alias gau='git add -u'
alias gap='git add -p'
alias gs='git st'
alias gco='git checkout'
alias ssh='TERM=screen ssh'
alias pr='open-pr'

bindkey -e
bindkey '^[[Z' reverse-menu-complete       # Shift-Tab
bindkey '^[[3~' delete-char                # Delete
bindkey -M viins '^?' backward-delete-char # Backspace
bindkey "\e[A" history-beginning-search-backward # (set to up arrow)
bindkey "\e[B" history-beginning-search-forward  # (set to down arrow)
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Colors

if [ -x "$(command -v dircolors)" ]; then
  eval $(dircolors -b) # use defaults
fi

export GREP_COLORS='mt=1;32'
export CLICOLOR=yes

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0000000" #black
    echo -en "\e]P8555753" #darkgrey
    echo -en "\e]P1a40000" #darkred
    echo -en "\e]P9ff6565" #red
    echo -en "\e]P2ff8d8d" #darkgreen
    echo -en "\e]PA93d44f" #green
    echo -en "\e]P3eab93d" #brown
    echo -en "\e]PBffc123" #yellow
    echo -en "\e]P4204a87" #darkblue
    echo -en "\e]PC3465a4" #blue
    echo -en "\e]P5ce5c00" #darkmagenta
    echo -en "\e]PDf57900" #magenta
    echo -en "\e]P689b6e2" #darkcyan
    echo -en "\e]PE46a4ff" #cyan
    echo -en "\e]P7cccccc" #lightgrey
    echo -en "\e]PFffffff" #white
    clear #for background artifacting
fi

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;44;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'



# Prompt

prompt_minimal_precmd() {
  local branch dirty

  set -g git_info

  if branch="${$(git symbolic-ref -q HEAD 2>/dev/null)##refs/heads/}"; then
    git diff --quiet --ignore-submodules || dirty=' *'
    git_info=" %B%F{cyan}(%F{magenta}$branch%F{cyan})%F{red}$dirty%f%b"
  else
    unset git_info
  fi
}

setopt prompt_subst
autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_minimal_precmd
PROMPT=' %F{cyan}%~%f$git_info '


# Completions
autoload -Uz compinit && compinit -i
autoload -Uz colors && colors
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'

# Custom functions

mp() {
  killall redshift
  mpv $* 2>& /dev/null
  # run and detach redshift
  nohup redshift -r >& /dev/null &!
}
# Autocmplete mp the same way as mplayer
compdef mp=mplayer


bt() {
  case $1 in
    start)
      transmission-daemon --encryption-preferred --dht --portmap \
        --download-dir ~/downloads --no-incomplete-dir \
        --allowed "127.0.0.*,192.168.1.*,10.0.0.*";;
    stop)
      killall transmission-daemon ;;
    add)
      transmission-remote --pex --add $2 ;;
    remove)
      transmission-remote --torrent $2 --remove ;;
    trash)
      transmission-remote --torrent $2 --remove-and-delete ;;
    info)
      transmission-remote --torrent $2 --info | less ;;
    list)
      watch -t -n5 transmission-remote --list ;;
    *)
      echo "usage: $0 {start|stop|add file|remove #|trash #|info #|list}"
  esac
}


# https://github.com/caarlos0/zsh-open-pr
_get_repo() {
  echo "$1" | sed -e "s/.git$//" -e "s/.*github.com[:/]\(.*\)/\1/"
}
_build_url() {
  # shellcheck disable=SC2039
  local upstream origin branch repo pr_url target
  upstream="$(git config --get remote.upstream.url)"
  origin="$(git config --get remote.origin.url)"
  branch="$(git symbolic-ref --short HEAD)"
  repo="$(_get_repo "$origin")"
  pr_url="https://github.com/$repo/pull/new"
  target="$1"
  test -z "$target" && target="main"
  if [ -z "$upstream" ]; then
    echo "$pr_url/$target...$branch"
  else
    # shellcheck disable=SC2039
    local origin_name upstream_name
    origin_name="$(echo "$repo" | cut -f1 -d'/')"
    upstream_name="$(_get_repo "$upstream" | cut -f1 -d'/')"
    echo "$pr_url/$upstream_name:$target...$origin_name:$branch"
  fi
}
# shellcheck disable=SC2039
open-pr() {
  # shellcheck disable=SC2039
  local url
  url="$(_build_url "$*")"
  if [ "$(uname -s)" = "Darwin" ]; then
    open "$url" 2> /dev/null
  else
    xdg-open "$url" > /dev/null 2> /dev/null
  fi
}

vim() STTY=-ixon command vim "$@"

t() {
  if [[ -x 'bin/test' ]]; then
    bin/test
  else
    bundle exec rake
  fi
}

# Freeze the tty. This means that settings will be restored after any command
# that changes them exits. Useful in combination with stty to change tty flow
# control temporarily.
ttyctl -f


# Version managers

if [[ -e /usr/share/chruby ]]; then
  source /usr/share/chruby/chruby.sh
  source /usr/share/chruby/auto.sh
fi

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).


# start x if appropriate
[[ $TTY == /dev/tty1 ]] \
  && (( $UID ))         \
  && [[ -z $DISPLAY ]]  \
  && exec ssh-agent startx -nolisten tcp
