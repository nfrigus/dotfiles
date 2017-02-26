# Aliases
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias grep='grep --color'                     # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different listings
alias ll='ls -lA'                             # long list

# listing
alias ls-npm='npm ls --depth 0'
alias ls-pip='pip list'
alias ls-ssh="grep -r 'Host ' '$HOME/.ssh/'"
alias ls-foo='compgen -A function'


# docker
alias dkr=docker
alias dkrc=docker-compose

dkr-sh() {
    dkr exec -it $* bash
}

app() {
    local app=$PWD/artisan
    if [ -f $PWD/artisan ]; then
        $app $*
    else
        echo Not found
    fi
}

path() {
    echo $PATH | tr : "\n"
}

try() {
    $(echo "$*") && echo 1 || echo 0
}



