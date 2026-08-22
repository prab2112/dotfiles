# ---- history ----
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# ---- completion ----
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ---- keybindings ----
bindkey -e

# ---- aliases: modern replacements ----
alias ls='eza --group-directories-first'
alias ll='eza -lh --group-directories-first --icons'
alias la='eza -lah --group-directories-first --icons'
alias lt='eza --tree --level=2 --icons'
alias cat='batcat --paging=never'
alias grep='grep --color=auto'
alias find='fdfind'
alias ..='cd ..'
alias ...='cd ../..'

# ---- zoxide: smarter cd (adds `z`/`zi` commands) ----
eval "$(zoxide init zsh)"

# ---- fzf ----
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# ---- plugins ----
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ---- prompt ----
eval "$(starship init zsh)"

# ---- startup banner ----
command -v neofetch >/dev/null 2>&1 && neofetch

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

. "$HOME/.local/bin/env"
