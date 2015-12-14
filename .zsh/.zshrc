source "$ZDOTDIR/functions/setup_terminal_title"
source "$ZDOTDIR/functions/setup_colors"
source "$ZDOTDIR/functions/setup_completion"
source "$ZDOTDIR/functions/custom_functions"

export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=1000
export SAVEHIST=1000
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS

#export _JAVA_OPTIONS="-Dswing.aatext=true -Dawt.useSystemAAFontSettings=lcd"

export BROWSER='chromium'
export PAGER='less'

export GREP_COLOR='1;32'

[[ -x $(which highlight) ]] && export LESSOPEN="| highlight --out-format=xterm256 --quiet %s"
export LESS='-R -w'

export MANWIDTH=80

export OOC_LIBS=$HOME/ooc
export ROCK_DIST=$HOME/ooc/rock

# don't jump over entire /path/to/file, but from word to word separated by /
# by default: export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
# we take out the slash, period, angle brackets, dash here.
export WORDCHARS='*?_[]~=&;!#$%^(){}'

alias ls='ls --color=auto -hF'
alias grep='grep --color=auto'
alias du='du -h'
alias df='df -h'
alias cal='cal -m'
alias im='dtach -A /tmp/im irssi'
alias music='if [ ! -s ~/.config/mpd/pid ]; then mpd ~/.config/mpd/mpd.conf > /dev/null 2> ~/.config/mpd/error; fi; ncmpc'
alias mpg123='mpg123 -C'
alias emacs='emacs -nw'
alias open='mimeo'
alias mnt='udisks --mount'
alias umnt='udisks --unmount'
alias be='bundle exec'
alias bi='bundle install'
alias ag='ag --pager less'
alias ant='ant -find build.xml'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gf='git fetch'
alias gr='git rebase'
alias gl='git l'
alias gg='git g'
alias ga='git add'
alias gau='git add -u'
alias gap='git add -p'
alias gs='git st'
alias gco='git checkout'
alias ssh='TERM=screen ssh'

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
#bindkey "^H" backward-delete-word
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

autoload -Uz promptinit && promptinit
prompt minimal

# Freeze the tty. This means that settings will be restored after any command
# that changes them exits. Useful in combination with stty to change tty flow
# control temporarily.
ttyctl -f
