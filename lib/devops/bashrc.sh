alias compose=docker-compose
alias kcat=kafkacat
alias kube=kubectl

# Bash completions
source <(kubectl completion bash)
complete -o default -F __start_kubectl kube
complete -F _docker_compose compose
