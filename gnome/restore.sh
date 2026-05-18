#!/usr/bin/env bash
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

dconf load /org/gnome/ < "$here/snapshot/org-gnome.dconf"

while read -r uuid; do
  [ -z "$uuid" ] && continue
  if ! gnome-extensions list | grep -qx "$uuid"; then
    echo "MISSING: $uuid -- install via https://extensions.gnome.org or 'gext install $uuid'"
  else
    gnome-extensions enable "$uuid" || true
  fi
done < "$here/snapshot/extensions.list"
