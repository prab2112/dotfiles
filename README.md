# dotfiles

Shell environment config for WSL Ubuntu, tuned for a fast, keyboard-driven dev setup.

## Files

- `zshrc` → `~/.zshrc` — zsh config (aliases, plugins, zoxide, nvm, direnv, starship init)
- `starship.toml` → `~/.config/starship.toml` — prompt config (no-nerd-font preset base)
- `tmux.conf` → `~/.tmux.conf` — tmux config (mouse mode, vi keys, status bar, Windows clipboard bridge)

Symlink them into place:

```
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
```

## Dependencies

Available via apt (`sudo apt update && sudo apt install -y <name>`):

| Package | Used for |
|---|---|
| `eza` | `ls`/`ll`/`la`/`lt` replacement |
| `bat` (binary: `batcat`) | `cat` replacement with syntax highlighting |
| `fd-find` (binary: `fdfind`) | `fd` alias — do **not** alias `find` itself, it breaks SDKMAN's init script |
| `zoxide` | smarter `cd` (`z`/`zi`) |
| `fzf` | fuzzy history/file search, key bindings |
| `zsh-autosuggestions`, `zsh-syntax-highlighting` | shell plugins |
| `keychain` | persists ssh-agent across terminals in a login session |
| `neovim`, `direnv`, `git-delta` | editor, per-dir env loading, `git diff`/`log` pager (each wired in `zshrc`/git config only if the binary is present, so it's safe to add these later) |

One-liner for the apt group above, plus delta's git wiring:

```
sudo apt update && sudo apt install -y eza bat fd-find zoxide fzf zsh-autosuggestions zsh-syntax-highlighting keychain neovim direnv git-delta \
  && git config --global core.pager delta \
  && git config --global interactive.diffFilter "delta --color-only"
```

Not packaged in apt — install as static binaries into `~/.local/bin` (already on `PATH`, no sudo needed):

| Tool | Used for | Install |
|---|---|---|
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | startup banner (replaces `neofetch`, which added ~5s to every shell start) | download `fastfetch-linux-amd64.tar.gz` from the latest release, copy `usr/bin/fastfetch` out |
| [lazygit](https://github.com/jesseduffield/lazygit) | `lg` alias, terminal UI for git | download `lazygit_*_linux_x86_64.tar.gz` from the latest release |
| [win32yank](https://github.com/equalsraf/win32yank) | tmux copy-mode ⇄ Windows clipboard bridge | download `win32yank-x64.zip` from the latest release, extract `win32yank.exe` |
| [nvm](https://github.com/nvm-sh/nvm) + Node LTS | native `node`/`npm` in WSL (avoids slow/fragile calls across into `/mnt/c`) | `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh \| bash`, then `nvm install --lts` |

`neofetch`/`neofetch`-style banners are unmaintained upstream — `fastfetch` is the maintained, much faster replacement and is what `zshrc` invokes.

### tmux plugins (session persistence)

`tmux.conf` declares `tmux-resurrect` + `tmux-continuum` (auto-saves session layout every 15 min and restores it on tmux start, so sessions survive a WSL/Windows restart), managed via [tpm](https://github.com/tmux-plugins/tpm):

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh
```

(Or, inside tmux, `prefix + I` to install/update plugins declared in `tmux.conf`.)

## Notes

- The SDKMAN block in `zshrc` must stay at the end of the file (SDKMAN's own requirement) — keep any new `source`/`eval` lines above it, not below.
- `ls` is a shell function, not a plain alias: eza's `-t` flag takes a value (`--sort=modified`) instead of being a boolean like GNU `ls -t`, so combos like `-lrt` would otherwise fail with `Flag -t needs a value`. The function rewrites any `t` embedded in a short-flag cluster into `--sort=modified` automatically.
- tmux clipboard integration requires `win32yank.exe` to be reachable from WSL (WSL interop must be enabled, which is the default).
- `ll`/`la`/`lt` deliberately don't pass eza's `--icons` flag — this system has no Nerd Font installed (matching starship's no-nerd-font preset), so icon glyphs would just render as broken boxes. Only re-add `--icons` after installing a Nerd Font in Windows Terminal, and consider switching starship to a nerd-font preset at the same time.
- `zshrc`'s locale block only sets `LANG`/`LC_ALL` to `en_US.UTF-8` once that locale actually exists (checked via `locale -a`); the system currently defaults to `C.UTF-8`. To generate it: `sudo locale-gen en_US.UTF-8 && sudo update-locale LANG=en_US.UTF-8`.
