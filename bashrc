
alias ga="git add -A"
alias gc="git commit -m"
alias gp="git push"
alias gpm="git push -u origin main"   # ← use once when making new repos
alias gs="git status"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"

# --- tmux dev workspace launcher ---
t() {
    # usage: t            -> session for the current directory
    #        t some/dir   -> session for that directory
    local PROJECT
    PROJECT="$(cd "${1:-$PWD}" && pwd)" || return
    local SESSION
    SESSION="$(basename "$PROJECT" | tr '.:' '__')"

    if tmux has-session -t "$SESSION" 2>/dev/null; then
        tmux attach -t "$SESSION"
        return
    fi

    tmux new-session -s "$SESSION" -c "$PROJECT"
}

export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH="$PATH:$HOME/go/bin"
export QT_QPA_PLATFORMTHEME=qt6ct
. "$HOME/.cargo/env"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# vim motions on the command line (Esc = normal mode, i = insert)
set -o vi
