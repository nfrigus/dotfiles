env AWS_VAULT_BACKEND file

path $HOME/bin

# Extra platform's packages
path /home/linuxbrew/.linuxbrew/opt/php@7.4/bin
path /home/linuxbrew/.linuxbrew/opt/php@7.4/sbin

# Platforms' binaries
path /home/linuxbrew/.linuxbrew/bin
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
