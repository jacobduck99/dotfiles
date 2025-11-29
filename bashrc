
alias ga="git add -A"
alias gc="git commit -m"
alias gp="git push"
alias gpm="git push -u origin main"   # ← use once when making new repos
alias gs="git status"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"

# --- tmux dev workspace launcher ---
t() {
    local SESSION="dev"
    local PROJECT="$HOME/workspace/github.com/jacobduck99/delivery-tracker-v2"

    # Editor
    local CMD_EDITOR="nvim ."

    # Frontend (React)
    local CMD_FRONTEND="bash -lc 'npm run dev'"

    # Backend (Flask)
    local CMD_SERVER="bash -lc 'cd server && source .venv/bin/activate && python3 app.py'"

    local LOGFILE="$PROJECT/app.log"

  # If session already exists, attach to it
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux attach -t "$SESSION"
    return
  fi

  # Ensure project + log file exists
  mkdir -p "$PROJECT"
  [ -f "$LOGFILE" ] || touch "$LOGFILE"

  # Window 1: Code
  tmux new-session -d -s "$SESSION" -n code -c "$PROJECT" "$CMD_EDITOR"

  # Window 2: Server
  tmux new-window  -t "$SESSION":2 -n server -c "$PROJECT" "$CMD_SERVER"

  # Focus code window and attach
  tmux select-window -t "$SESSION":1
  tmux attach -t "$SESSION"
}

export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
