typeset -gU fpath manpath path

fpath=(
  "$ZDOTDIR/functions"
  $fpath
)

manpath=(
  /usr/local/share/man
  $manpath
)

path=(
  "$HOME/.cargo/bin"
  "$HOME/.yarn/bin"
  $path
)

export LC_ALL=en_US.UTF-8
export LC_TYPE=utf-8

export EDITOR='vim'
export VISUAL='vim'

if [[ -e /usr/share/chruby ]]; then
  source /usr/share/chruby/chruby.sh
  source /usr/share/chruby/auto.sh
fi

# password-containing environment variables
[[ -r "$HOME/.secrets" ]] && source "$HOME/.secrets"

# start x if appropriate
[[ $TTY == /dev/tty1 ]] \
  && (( $UID ))         \
  && [[ -z $DISPLAY ]]  \
  && exec ssh-agent startx -nolisten tcp
