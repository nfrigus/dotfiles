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

# local settings
[ ~/.bashrc.sh ] && source ~/.bashrc.sh

# restore init dir
[ "$BASH_INIT_DIR" != "/usr/bin" ] && cd "$BASH_INIT_DIR"
