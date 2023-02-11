# Aliases

# Some shortcuts for different listings
alias ls-npm='npm ls --depth 0'
alias ls-pip='pip list'
alias ls-ssh="grep -r 'Host ' '$HOME/.ssh/'"

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias kube=kubectl
alias kcat=kafkacat

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

# todo: Add usage info
ssl-test() {
    local host="$1"
    local port="${2:-443}"

    if [ -f "$host" ]; then
        openssl x509 -text < "$host"
        else
        echo | openssl s_client -showcerts -servername "$host" -connect "$host:$port" 2>/dev/null | openssl x509 -inform pem -noout -text
    fi
}
alias https-cert='ssl-test'
alias read-cert='ssl-test'

dr() {
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

try() {
    $(echo "$*") && echo 1 || echo 0
}

apt-find() {
    apt search $* | grep -vE '^$' | sed -re 'N;s,/.*\n,|,' | column -ts '|' | grep $*
}

countdown(){
    date1=$((`date +%s` + $1));
    while [ "$date1" -ge `date +%s` ]; do
    ## Is this more than 24h away?
    days=$(($(($(( $date1 - $(date +%s))) * 1 ))/86400))
    echo -ne "$days day(s) and $(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
    sleep 0.1
    done
}
stopwatch(){
    date1=`date +%s`;
    while true; do
    days=$(( $(($(date +%s) - date1)) / 86400 ))
    echo -ne "$days day(s) and $(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
    done
}