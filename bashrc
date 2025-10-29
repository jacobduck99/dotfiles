
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
  local PROJECT="$HOME/workspace/github.com/jacobduck99/delivery-tracker"
  local CMD_EDITOR="nvim ."
  local CMD_SERVER="bash -lc 'source venv/bin/activate && flask run --reload'"
  local LOGFILE="$PROJECT/app.log"        # or change if your log file is elsewhere

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

  # Window 3: Logs
  tmux new-window  -t "$SESSION":3 -n logs -c "$PROJECT" "tail -f \"$LOGFILE\""

  # Focus code window and attach
  tmux select-window -t "$SESSION":1
  tmux attach -t "$SESSION"
}
# --- end ---
