# dotfiles

Shell environment config for WSL Ubuntu.

- `zshrc` → `~/.zshrc` — zsh config (aliases, plugins, zoxide, starship init)
- `starship.toml` → `~/.config/starship.toml` — prompt config (no-nerd-font preset base)
- `tmux.conf` → `~/.tmux.conf` — tmux config (mouse mode, vi keys, status bar)

Files live here and are symlinked into place:

\`\`\`
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
\`\`\`
