#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing Claude Code configuration from $REPO_DIR..."

mkdir -p "$CLAUDE_DIR"

for dir in agents commands skills; do
  if [ ! -d "$REPO_DIR/$dir" ]; then
    continue
  fi

  target="$CLAUDE_DIR/$dir"

  if [ -L "$target" ]; then
    echo "  Replacing existing symlink: $dir"
    rm "$target"
  elif [ -d "$target" ]; then
    backup="$target.bak.$(date +%Y%m%d%H%M%S)"
    echo "  Backing up existing $dir → $backup"
    mv "$target" "$backup"
  fi

  ln -s "$REPO_DIR/$dir" "$target"
  echo "  Linked: ~/.claude/$dir → $REPO_DIR/$dir"
done

# Install individual files as hardlinks (works without admin on same filesystem)
for file in settings.json CLAUDE.md; do
  if [ ! -f "$REPO_DIR/$file" ]; then
    continue
  fi

  target="$CLAUDE_DIR/$file"

  if [ -L "$target" ]; then
    echo "  Replacing existing symlink: $file"
    rm "$target"
  elif [ -f "$target" ]; then
    backup="$target.bak.$(date +%Y%m%d%H%M%S)"
    echo "  Backing up existing $file → $backup"
    mv "$target" "$backup"
  fi

  ln "$REPO_DIR/$file" "$target"
  echo "  Linked: ~/.claude/$file → $REPO_DIR/$file"
done

echo ""
echo "Done. Run 'git pull' in $REPO_DIR to update."
