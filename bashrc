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

# TODO: Find way to include it as RC not SH
source '/home/shest/.babun-docker/setup.sh'

# TODO: Report bug of broken path with spaces
# https://github.com/racklin/phpbrew/commit/48943f861e3d7a94d0fa1bf1e24781f11ac1d61d
source ~/.phpbrew/bashrc

# added by travis gem
[ -f /home/shest/.travis/travis.sh ] && source /home/shest/.travis/travis.sh

# restore init dir
[ "$BASH_INIT_DIR" != "/usr/bin" ] && cd "$BASH_INIT_DIR"
