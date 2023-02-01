#!/bin/bash

ROOT_DIR="$(realpath -L -- "$(dirname -- "$0")/../..")"


main() {
    case $1 in
        install)
            cmd_install
            ;;
        *)
            print_help
            ;;
    esac
}

cmd_install() {
    cd "$ROOT_DIR"
    MODULES="$(find_modules)"

    mkdir -p "$ROOT_DIR/var/bash" "$ROOT_dir/usr/bin"

    set_symlinks
    cache_paths
    cache_sources
}

print_help() {
    echo "$0 <command>"
    echo ""
    echo "Commands:"
    echo "  install - integrate into system"
    echo "  sync - update symlinks, path cache and imports"
}

set_symlinks() {
    local k
    local v
    for module in ${MODULES[@]}; do
        get_module_config $module \
        | awk '/^link /' \
        | cut -d\  -f2- \
        | while read -r entry; do
            k="$(echo $entry | cut -d' ' -f1)"
            v="$(echo $entry | cut -d' ' -f2)"
            case $v in
                "\$ROOT")
                    v="$ROOT_DIR"
                    ;;
                "\$ROOT/"*)
                    v="${v/\$ROOT/dotfiles}"
                    ;;
                /*)
                    :
                    ;;
                *)
                    v="dotfiles/lib/$module/$v"
                    ;;
            esac
            set_symlink "$HOME/$k" "$v"
        done
    done
}

get_module_config() {
    local module="$1"
    local config="$ROOT_DIR/lib/$module/links"

    [ -f "$config" ] && cat "$config"
}

get_module_local_path() {
    local module="$1"

    echo "lib/$module"
}

cache_paths() {
    local path
    for module in ${MODULES[@]}; do
        path="$HOME/dotfiles/$(get_module_local_path $module)/bin"
        [ -d "$path" ] && echo "$path"

        get_module_config $module \
        | awk '/^path /' \
        | cut -d\  -f2- \
        | while read -r path; do
            case $path in
                "\$ROOT/"*)
                    path="$HOME/${path/\$ROOT/dotfiles}"
                    ;;
                "\$HOME/"*)
                    path="$HOME/${path/\$HOME\/}"
                    ;;
                /*)
                    :
                    ;;
                *)
                    path="$HOME/dotfiles/$module/$path"
            esac
            echo "$path"
        done
    done > "$ROOT_DIR/var/bash/paths"
}

cache_sources() {
    for module in ${MODULES[@]}; do
        get_module_config $module \
        | awk '/^source /' \
        | cut -d\  -f2- \
        | while read -r source; do
            case $source in
                "\$ROOT/"*)
                    source="$HOME/${source/\$ROOT/dotfiles}"
                    ;;
                "\$HOME/"*)
                    source="$HOME/${source/\$HOME\//}"
                    ;;
                /*)
                    :
                    ;;
                *)
                    source="$HOME/dotfiles/$(get_module_local_path $module)/$source"
            esac
            echo "$source"
        done
    done > "$ROOT_DIR/var/bash/sources"
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

find_modules() {
    ls -d1 lib/*/ | xargs -n1 basename
}

main "$@"
