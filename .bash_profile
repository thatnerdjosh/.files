# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export ANDROID_HOME=~/Android/Sdk
export PATH
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export GOPATH=~/development/go
