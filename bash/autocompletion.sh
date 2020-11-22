for i in `find "${HOME}/dotfiles/bash/autocompletion" -type f`; do
    source "$i"
done
