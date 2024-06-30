#!/usr/bin/env zsh

# Script assumes that the cs-tools repo is located at ~/${CS_ROOT}/cs-tools
# Change this variable if you have cloned the repo elsewhere
CS_ROOT=CMSC

# save original directory
ORIG_DIR=$(pwd)

# change to cs-tools dir
cd "/$HOME/$CS_ROOT/cs-tools"

# copy configs to home directory, backing up old files if needed
HOME_CONFIGS=(
    zshrc
    tmux.conf
    vimrc
)
for conf in "${HOME_CONFIGS[@]}"; do
    if test -f $HOME/.$conf; then
        cp $HOME/.$conf $HOME/.$conf-$(TZ='America/Chicago' date "+%y-%m-%d_%H-%M").bak
    fi
    cp /$HOME/$CS_ROOT/cs-tools/configs/$conf /$HOME/.$conf
done

# return to original directory
cd $ORIG_DIR

