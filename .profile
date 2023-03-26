export PATH="$PATH:$(python3 -m site --user-base)/bin"
export PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH=$PATH:/usr/local/go/bin:$GOBIN

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
