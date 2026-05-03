!DONOT LET THE SYSTEM HANDLE GITHUB CREDENTIALS
!USE THE GH CLI INSTEAD SEE BELOW

!REMEMBER WHEN INSTALLING NIX TO ALWAYS REPLACE HARDWARE CONFIG WITH THE GENERATED ONE

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

## Claude Code

### Installation (NixOS)
Add this overlay to configuration.nix (after the imports block) to pull claude-code from unstable:

nixpkgs.overlays = [
  (final: prev: {
    claude-code = (import (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
      sha256 = "YOUR_HASH_HERE";
    }) {
      system = prev.stdenv.hostPlatform.system;
      config = config.nixpkgs.config;
    }).claude-code;
  })
];

Then add claude-code to environment.systemPackages as normal.

To update the hash run:
nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz

### Auth
Run claude on first launch and authenticate via browser through your Anthropic account.
No API key or env variables needed.

### Config (hooks + status line)
Claude creates ~/.claude/ itself, so stow can't handle it. Symlink manually after first launch:

ln -sf ~/dotfiles/.claude/settings.json ~/.claude/settings.json
ln -sf ~/dotfiles/.claude/pricing.json ~/.claude/pricing.json
ln -sf ~/dotfiles/.claude/hooks ~/.claude/hooks
