
#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/workspace/github.com/jacobduck99/dotfiles}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME/.dotfiles_backup/$STAMP"

log()  { printf "\033[1;32m%s\033[0m\n" "$*"; }
warn() { printf "\033[1;33m%s\033[0m\n" "$*"; }
info() { printf "\033[0;36m%s\033[0m\n" "$*"; }

backup_if_needed() {
  local dest="$1"

  # nothing to back up
  [[ ! -e "$dest" && ! -L "$dest" ]] && return 0

  # if it's already a symlink to our repo, do nothing
  if [[ -L "$dest" ]]; then
    local target
    target="$(readlink -f "$dest" || true)"
    if [[ "$target" == "$DOTFILES"* ]]; then
      return 0
    fi
  fi

  mkdir -p "$BACKUP_DIR"
  mv -v "$dest" "$BACKUP_DIR"/
  warn "Backed up $dest → $BACKUP_DIR/"
}

link() {
  local src="$DOTFILES/$1"
  local dest="$HOME/$2"

  if [[ ! -e "$src" && ! -d "$src" ]]; then
    warn "Skip (missing in repo): $src"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  # already correct?
  if [[ -L "$dest" && "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
    info "Already linked: $dest"
    return 0
  fi

  backup_if_needed "$dest"
  ln -sfn "$src" "$dest"
  log "Linked: $dest → $src"
}

# ------------------
# LINKS YOU WANT
# ------------------
link bashrc                 .bashrc
link .config/i3/config      .config/i3/config
link .config/ghostty/config .config/ghostty/config
link .config/nvim           .config/nvim
link .tmux.conf             .tmux.conf   # add tmux

# Post steps
if command -v tmux >/dev/null 2>&1 && tmux has-session 2>/dev/null; then
  tmux source-file "$HOME/.tmux.conf" || true
  info "Reloaded tmux config."
fi

echo "✅ Installed dotfiles symlinks."
echo "Tip: reload i3 with Mod+Shift+R"
