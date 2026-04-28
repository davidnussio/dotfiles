# Dev shortcuts

# Git
function pr
    gh pr create --web
end

# Mostra porte in ascolto
function ports
    lsof -iTCP -sTCP:LISTEN -n -P
end

# Copia output negli appunti
function copy
    $argv | pbcopy
end

# Docker
abbr -a dps 'docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
abbr -a dprune 'docker system prune -af --volumes'

# Kubernetes
abbr -a k kubectl
abbr -a kgp 'kubectl get pods'
abbr -a kns kubens
abbr -a kctx kubectx
