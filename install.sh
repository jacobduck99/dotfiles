
#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/workspace/github.com/jacobduck99/dotfiles"

link() {
  src="$DOTFILES/$1"
  dest="$HOME/$2"

  echo "→ $dest -> $src"
  mkdir -p "$(dirname "$dest")"

  # backup real files (not symlinks)
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "  backed up: $dest -> $dest.bak"
  fi

  ln -sfn "$src" "$dest"
}

# link configs
link bashrc                 .bashrc
link .config/i3/config      .config/i3/config
link .config/ghostty/config .config/ghostty/config
link .config/nvim           .config/nvim

echo "✅ Installed dotfiles symlinks."
echo "Tip: reload i3 with Mod+Shift+R"
