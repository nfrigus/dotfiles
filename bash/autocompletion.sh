for i in `find "$HOME/.bash/autocompletion" -type f`; do
    source "$i"
done
