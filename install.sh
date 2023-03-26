#!/bin/sh

#######
# Configure/Install necessary dependencies to setup full environment.
# TODO: Pull down ansible playbook and run that instead
# TODO: Add full compatibility outside of OS X environments (could be part of migration to ansible instead)
#######

function prepare {
    # Supported only on Linux/macOS for now.
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        export PATH="$HOME/.local/bin:$PATH"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        installXCodeTools
        pip3 install --upgrade pip
    else
        # Unknown.
        echo "$OSTYPE is not yet supported. Exiting..."; exit 1;
    fi

    export PATH="$(python3 -m site --user-base)/bin:$PATH"
    pip3 install --user ansible
}

function installXCodeTools {
    echo "Checking Command Line Tools for Xcode"
    # Only run if the tools are not installed yet
    # To check that try to print the SDK path
    xcode-select -p &> /dev/null
    if [ $? -ne 0 ]; then
      echo "Command Line Tools for Xcode not found. Installing from softwareupdate…"

      # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
      touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;

      PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
      softwareupdate -i "$PROD" --verbose;
    else
      echo "Command Line Tools for Xcode have been installed."
    fi
}


prepare