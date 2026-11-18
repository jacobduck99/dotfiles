
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
    # inside ~/workspace/github.com/jacobduck99/<repo>/... -> session "<repo>", rooted at the repo
    # at ~/workspace/github.com/jacobduck99 itself          -> session "jacobduck99"
    local ROOT="$HOME/workspace/github.com/jacobduck99"
    # anywhere else (e.g. ~) with no argument                -> session "jacobduck99"
    if [[ "$PROJECT" == "$ROOT"/* ]]; then
        local REL="${PROJECT#"$ROOT"/}"
        PROJECT="$ROOT/${REL%%/*}"
    elif [[ -z "$1" ]]; then
        PROJECT="$ROOT"
    fi
    local SESSION
    SESSION="$(basename "$PROJECT" | tr '.:' '__')"

    # create the session (detached) if it doesn't exist yet
    if ! tmux has-session -t "=$SESSION" 2>/dev/null; then
        tmux new-session -d -s "$SESSION" -c "$PROJECT"
    fi

    # inside tmux you can't attach (nesting), so switch instead
    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "=$SESSION"
    else
        tmux attach -t "=$SESSION"
    fi
}

export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Auto-switch Node version via .nvmrc on cd (from the nvm README)
cdnvm() {
    command cd "$@" || return $?
    nvm_path="$(nvm_find_up .nvmrc | command tr -d '\n')"

    # No .nvmrc found: fall back to the default nvm version
    if [[ ! $nvm_path = *[^[:space:]]* ]]; then
        declare default_version
        default_version="$(nvm version default)"

        if [ "$default_version" = 'N/A' ]; then
            nvm alias default node
            default_version=$(nvm version default)
        fi

        if [ "$(nvm current)" != "${default_version}" ]; then
            nvm use default
        fi
    elif [[ -s "${nvm_path}/.nvmrc" && -r "${nvm_path}/.nvmrc" ]]; then
        declare nvm_version
        nvm_version=$(<"${nvm_path}"/.nvmrc)

        declare locally_resolved_nvm_version
        locally_resolved_nvm_version=$(nvm ls --no-colors "${nvm_version}" | command tail -1 | command tr -d '\->*' | command tr -d '[:space:]')

        # Install it if missing (nvm install also switches to it), otherwise switch
        if [ "${locally_resolved_nvm_version}" = 'N/A' ]; then
            nvm install "${nvm_version}"
        elif [ "$(nvm current)" != "${locally_resolved_nvm_version}" ]; then
            nvm use "${nvm_version}"
        fi
    fi
}

alias cd='cdnvm'
cdnvm "$PWD"

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
