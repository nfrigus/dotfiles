#!/usr/bin/env sh

INSTAL_DIR=~/.git.d

[ -d "$INSTAL_DIR" ] || mkdir "$INSTAL_DIR"

cd "$INSTAL_DIR"

curl -O https://raw.githubusercontent.com/nfrigus/dotfiles/master/git/alias.gitconfig

git config --global --add include.path "$INSTAL_DIR/alias.gitconfig"
