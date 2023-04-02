env AWS_VAULT_BACKEND file

path $HOME/bin

# Platforms' binaries
# todo: include brew complitions: /home/linuxbrew/.linuxbrew/etc/bash_completion.d
path /home/linuxbrew/.linuxbrew/bin
path /home/linuxbrew/.linuxbrew/sbin
path $HOME/.local/bin
path $HOME/go/bin

source $HOME/.cargo/env
source config.sh
source functions.sh
source autocompletion/docker
source autocompletion/docker-compose
source autocompletion/git
source autocompletion/helm
source autocompletion/terraform
source $HOME/.bashrc.sh
