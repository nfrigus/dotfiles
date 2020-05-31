#!/bin/bash

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Imports
for i in `find "$HOME/.bash/" -name '*.sh'`; do
    source "$i"
done

# local settings
[ ~/.bashrc.sh ] && source ~/.bashrc.sh

