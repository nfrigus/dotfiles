# Aliases

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
    curl -s ipecho.net/plain | xargs
}

declare_list_functions() {
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

try() {
    "$@" && echo pass || echo fail
}

apt-find() {
    apt search "$*" | grep -vE '^$' | sed -re 'N;s,/.*\n,|,' | column -ts '|' | grep "$*"
}

countdown() {
    date1=$((`date +%s` + $1));
    while [ "$date1" -ge `date +%s` ]; do
    ## Is this more than 24h away?
    days=$(($(($(( $date1 - $(date +%s))) * 1 ))/86400))
    echo -ne "$days day(s) and $(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
    sleep 0.1
    done
}

stopwatch() {
    date1=`date +%s`;
    while true; do
    days=$(( $(($(date +%s) - date1)) / 86400 ))
    echo -ne "$days day(s) and $(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
    done
}

# Run dummy HTTP-server with netcat
# Usage:
#   ncl [port=8080]
ncl() {
    local port=${1:-8080}
    echo "Listening to :$port"
    while true
    do echo -e 'HTTP/1.1 200 OK\n' | nc -q1 -l $port
    done
}

# Probe remote tcp port
# Usage:
#   probe <host> <port> [timeout=1]
port-probe() {
	timeout ${3:-1} bash -c "cat < /dev/null > /dev/tcp/$1/$2" && echo connected || echo no response
}

# Forward local port to remote target
# Usage:
#   port-forward <port> <target>
# Example:
#   port-forward 8080 google.com:80
port-forward() {
    socat tcp-listen:$1,reuseaddr,fork tcp:$2
}
