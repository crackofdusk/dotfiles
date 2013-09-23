typeset -gU fpath cdpath manpath path

fpath=(
  "$ZDOTDIR/functions"
  $fpath
)

cdpath=(
  #"$HOME/code"
  $cdpath
)

manpath=(
  /usr/local/share/man
  $manpath
)

path=(
  "$HOME/ooc/rock/bin"
  "$HOME/ooc/sam"
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
  && exec startx -nolisten tcp 2> .Xlog
