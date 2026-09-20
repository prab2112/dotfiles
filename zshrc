# ---- ssh-agent (via keychain, persists across terminals in this login session) ----
if command -v keychain >/dev/null 2>&1; then
    eval "$(keychain --eval --quiet --agents ssh id_ed25519)"
fi

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

# ---- editor / direnv ----
export EDITOR="$(command -v nvim || command -v vim)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# ---- aliases: modern replacements ----
# eza's -t is `--sort=modified` (takes a value), not GNU ls's boolean time-sort flag,
# so GNU-style combos like -lrt/-lt/-rt error with "Flag -t needs a value". This
# function strips a bare 't' out of any short-flag cluster and adds --sort=modified.
ls() {
    local -a args=()
    local sort_modified=0
    for arg in "$@"; do
        if [[ "$arg" == -* && "$arg" != --* && "$arg" == *t* ]]; then
            local stripped="${arg//t/}"
            sort_modified=1
            [[ "$stripped" == "-" ]] || args+=("$stripped")
        else
            args+=("$arg")
        fi
    done
    (( sort_modified )) && args+=(--sort=modified)
    command eza --group-directories-first "${args[@]}"
}
alias ll='eza -lh --group-directories-first --icons'
alias la='eza -lah --group-directories-first --icons'
alias lt='eza --tree --level=2 --icons'
alias cat='batcat --paging=never'
alias grep='grep --color=auto'
alias fd='fdfind'
alias lg='lazygit'
alias ..='cd ..'
alias ...='cd ../..'

# ---- nvm: node version manager (native node/npm, no crossing into /mnt/c) ----
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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
# fastfetch (fast, maintained) instead of neofetch, which added ~6s to every shell start
command -v fastfetch >/dev/null 2>&1 && fastfetch

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

. "$HOME/.local/bin/env"
