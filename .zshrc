if [[ -f ~/.aliases ]]; then
  . ~/.aliases
fi

if [[ -f ~/.profile ]]; then
  . ~/.profile
fi

if [[ -f ~/.zprofile ]]; then
  . ~/.zprofile
fi

export GOBIN="$HOME/go/bin"

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add
fi

export TERM="xterm-256color"

alias ls='exa --icons --git'
alias osrs='java -Duser.home=$HOME -Djava.class.path=/usr/local/bin/jagexappletviewer.jar -Dcom.jagex.config=http://oldschool.runescape.com/jav_config.ws jagexappletviewer /usr/local/share/'
alias weather='curl v2.wttr.in'

. /opt/homebrew/opt/asdf/libexec/asdf.sh