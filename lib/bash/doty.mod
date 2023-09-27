env AWS_VAULT_BACKEND file

path $HOME/bin

# Platforms' binaries
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
