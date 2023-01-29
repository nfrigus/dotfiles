#!/bin/bash

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Add dotfiles binaries to path and remove duplicates from it
DOTFILES_HOME="${HOME}/dotfiles"
# Todo: add WSL-specific binaries when needed only
DOTFILES_PATH="${DOTFILES_HOME}/home/bin/wsl/:${DOTFILES_HOME}/home/bin/"

PATH="${DOTFILES_PATH}:${PATH}"
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Import modules
# todo: Measure loading performance
for i in `find "${DOTFILES_HOME}/bash/" -name '*.sh'`; do
    source "$i"
done

# Re-add dotfile paths to ensure priority over modules
PATH="${DOTFILES_PATH}:${PATH}"

# Cleanup path duplicates
PATH="$(path consolidate "${PATH}")"

# Load local settings
[ -f ~/.bashrc.sh ] && source ~/.bashrc.sh
