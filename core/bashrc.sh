#!/bin/bash

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

root="$HOME/dotfiles"

PATH="$(paste -sd : "$root/var/bash/paths"):$PATH"
PATH="$(path consolidate "$PATH")"

for source in $(cat "$root/var/bash/sources"); do
    [ -f "$source" ] && source "$source"
done
