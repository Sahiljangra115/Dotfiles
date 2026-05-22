#!/usr/bin/env bash
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

dconf load /org/gnome/ < "$here/snapshot/org-gnome.dconf"

# GTK4 (libadwaita) apps ignore ~/.themes; symlink the active theme's gtk-4.0
# css/assets into ~/.config/gtk-4.0. Targets that don't exist are skipped.
theme_dir="$HOME/.themes/Tahoe-Dark/gtk-4.0"
mkdir -p "$HOME/.config/gtk-4.0"
for item in assets gtk.css gtk-dark.css; do
  if [ -e "$theme_dir/$item" ]; then
    ln -sfn "$theme_dir/$item" "$HOME/.config/gtk-4.0/$item"
  else
    echo "SKIP gtk-4.0/$item -- not present in theme"
  fi
done

while read -r uuid; do
  [ -z "$uuid" ] && continue
  if ! gnome-extensions list | grep -qx "$uuid"; then
    echo "MISSING: $uuid -- install via https://extensions.gnome.org or 'gext install $uuid'"
  else
    gnome-extensions enable "$uuid" || true
  fi
done < "$here/snapshot/extensions.list"
