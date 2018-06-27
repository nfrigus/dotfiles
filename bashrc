# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Ensure file loaded once only
if [[ -z "$BASH_INIT_DIR" ]]
then export BASH_INIT_DIR="$OLDPWD"
else return
fi

# Imports
for i in `find "$HOME/.bash/" -name '*.sh'`; do
    source "$i"
done

# TODO: Report bug of broken path with spaces
# https://github.com/racklin/phpbrew/commit/48943f861e3d7a94d0fa1bf1e24781f11ac1d61d
[ -f ~/.phpbrew/bashrc ] && source ~/.phpbrew/bashrc


# restore init dir
[ "$BASH_INIT_DIR" != "/usr/bin" ] && cd "$BASH_INIT_DIR"

export DOCKER_HOST=tcp://0.0.0.0:2375
