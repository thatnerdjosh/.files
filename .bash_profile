# .bash_profile

if [ -f ~/.aliases ]; then
  . ~/.aliases 
fi

# Get functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
if [ -f ~/.profile ]; then
	. ~/.profile
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
