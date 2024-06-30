#!/usr/bin/env zsh

# This script is a (bad) way to install packages I find essential. One day I
# will migrate this whole thing to an Ansible setup, but today is not that day.

# set package manager
if [[ $(uname) == *"Darwin"* ]]; then
    PKG_MGR=(brew install)
elif [[ $(uname) == *"Linux"* ]]; then
    # if you use a different package manager, then change this string.
    PKG_MGR=(apt install)
else
    echo "This is not a macOS or Linux system, this script likely isn't helpful."
    exit 1
fi

PKGS=(
    vim
    tmux
    fzf
    fd
    ripgrep
)

echo $PKGS | xargs $PKG_MGR

