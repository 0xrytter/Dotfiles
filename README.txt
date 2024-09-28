!DONOT LET THE SYSTEM HANDLE GITHUB CREDENTIALS
!USE THE GH CLI INSTEAD SEE BELOW

After placing .gitconfig in the home dir use
gh auth login

to auth.

if problems check gh location on system with

which gh

And ensure path to credential helper in .gitconfig mirrors output. Output example below

[credential]
    helper = !/path/to/gh auth git-credential

For reading the config for alacritty alacritty --config-file ~/.config/alacritty/alacritty.toml

To set zsh as the default shell for both the user and tmux

chsh zsh 

tmux source-file ~/.config/tmux/tmux.conf

For updating all zinit plugins for zsh zinit self-update zinit update --all

if tpm wont install use ~/.tmux/plugins/tpm/scripts/install_plugins.sh (As terminal command)

for neovim first clone most recent version of nvchad

git clone -b v2.0 https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

Then symlink our custom config in with stow .
