fish_vi_key_bindings

alias kanata='sudo ~/dotfiles/kanata/kanata --cfg ~/dotfiles/kanata/.kanata.kbd'

if not pgrep ssh-agent > /dev/null
    echo "Starting SSH agent..."
    eval (ssh-agent -c)
    ssh-add
else
    echo "SSH agent already running."
end
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
