#!/bin/bash

main() {
    INSTAL_PATH="$(realpath -L -- "$(dirname -- "$0")/..")"
    cd "$INSTAL_PATH"
    MODULES="$(load_modules_dirs)"

    set_symlinks

    echo Dotfiles succesfully installed
}

set_symlinks() {
    local k
    local v
    for module in ${MODULES[@]}; do
        [ -f "$module/links" ] \
        && cat "$module/links" \
        | awk '/^home/' \
        | cut -d\  -f2- \
        | while read -r entry; do
            k="$(echo $entry | cut -d' ' -f1)"
            v="$(echo $entry | cut -d' ' -f2)"
            case $v in
                "\$ROOT")
                    v="$INSTAL_PATH"
                    ;;
                "\$ROOT/"*)
                    v="${v/\$ROOT/dotfiles}"
                    ;;
                *)
                    v="dotfiles/$module/$v"
                    ;;
            esac
            set_symlink "$HOME/$k" "$v"
        done
    done
}

# todo: Promt confirmations
# todo: Debug logs
set_symlink() {
    local source="$1"
    local target="$2"

    if [ -L "$source" ]; then
        if [ "$(readlink "$source")" = "$target" ]; then
            : # skip already valid link
        else
            # Replacing existing link
            ln -sf "$target" "$source"
        fi
    elif [ -f "$source" ]; then
        # Replacing existing file
        ln -sf "$target" "$source"
    else
        # Creating a link
        ln -s "$target" "$source"
    fi
}

load_modules_dirs() {
    echo "core"
    ls -1 "$INSTAL_PATH/modules" | sed s.^.modules/.
}

main
