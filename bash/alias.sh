# Aliases
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort


# Some shortcuts for different listings
alias ls-npm='npm ls --depth 0'
alias ls-pip='pip list'
alias ls-ssh="grep -r 'Host ' '$HOME/.ssh/'"

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


wanip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

foos() {
    declare -F | awk '{print$3}' && alias | sed -e 's/alias //' -e "s/=/\t/"
}

dr() {
    if ! which winpty &> /dev/null; then
        local babun_docker_winpty_dir="$HOME/.winpty"
        PATH="$babun_docker_winpty_dir:$PATH"
    fi

    case $1 in
    sh|ssh)
        shift
        docker exec -it $1 bash
        ;;
    i)
        shift
        docker images $*
        ;;
    *)
        docker $*
        ;;
    esac
}

app() {
    local app=""

    if [ -f "$PWD/artisan" ]; then
        app="php artisan"
    elif [ -f "$PWD/app/console" ]; then
        app=app/console
    elif [ -f "$PWD/bin/console" ]; then
        app=bin/console
    else
        echo Not found
        return 1
    fi

    $app $*
}

path() {
    echo $PATH | tr : "\n"
}

try() {
    $(echo "$*") && echo 1 || echo 0
}

apt-find() {
    apt search $* | grep -vE '^$' | sed -re 'N;s,/.*\n,|,' | column -ts '|' | grep $*
}
