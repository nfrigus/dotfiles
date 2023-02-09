#!/bin/bash

ROOT_DIR="$(realpath -L -- "$(dirname -- "$0")/../..")"
cache=()

# 1 - ERROR
# 2 - WARNING
# 3 - INFO
# 4 - DEBUG
LOG_LEVEL=3


main() {
    if [[ "$*" = *" -v"* ]]; then
        LOG_LEVEL=4
    fi

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
    local entries
    for module in $(list_modules); do
        readarray -t entries < <(
            get_module_config $module \
            | awk '/^link /' \
            | cut -d\  -f2-
        )

        for entry in "${entries[@]}"; do
            k="$(echo "$entry" | cut -d\  -f1 )"
            v="$(echo "$entry" | cut -d\  -f2- | xargs)"
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
    for module in $(list_modules); do
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
    for module in $(list_modules); do
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

set_symlink() {
    local source="$1"
    local target="$2"

    log debug set_symlink.call "$source => $target"

    if [ -L "$source" ]; then
        local value="$(readlink "$source")"
        if [ "$value" = "$target" ]; then
            log info "Symlink synced" "$source -> $target"
        else
            confirm "$source is link to $value. Overwrite it to target $target?" \
            && ln -sf "$target" "$source" \
            && log info "Symlink updated" "$source -> $target"
        fi
    elif [ -f "$source" ]; then
        confirm "$source already exists. Confirm overwriting?" \
        && ln -sf "$target" "$source" \
        && log info "Symlink created" "$source -> $target"
    else
        ln -s "$target" "$source" \
        && log info "Symlink created" "$source -> $target"
    fi
}

confirm() {
    local msg=${1:-Proceed?}
    read -p "> $msg [yn]" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        return 1
    fi
}

list_modules() {
    if [ -z "${cache[modules]}" ]; then
        cache[modules]=$(ls -d1 lib/*/ | xargs -n1 basename)
    fi

    echo "${cache[modules]}"
}

log() {
    # Black        0;30     Dark Gray     1;30
    # Red          0;31     Light Red     1;31
    # Green        0;32     Light Green   1;32
    # Brown/Orange 0;33     Yellow        1;33
    # Blue         0;34     Light Blue    1;34
    # Purple       0;35     Light Purple  1;35
    # Cyan         0;36     Light Cyan    1;36
    # Light Gray   0;37     White         1;37
    local level="$1"
    local context="$2"
    shift 2
    local message="$*"

    case "$level" in
        debug) level=4 ;;
        info)  level=3 ;;
        warn)  level=2 ;;
        error) level=1 ;;
    esac

    [ "$LOG_LEVEL" -ge "$level" ] \
    && echo -e "\033[0;36m$context\033[0m: $message"
}

main "$@"
