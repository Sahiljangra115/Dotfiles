#!/usr/bin/env bash
# Bootstrap a fresh Arch/CachyOS machine from this dotfiles repo.
#
# Order matters:
#   1. pacman packages   (binaries + /usr/share files the configs source)
#   2. AUR packages       (apple-fonts, needed by dunst's font fallback chain)
#   3. git-only extras    (powerlevel10k, MacTahoe icon+cursor theme)
#   4. backup conflicts    (real files where stow wants symlinks)
#   5. stow all packages  (configs land in $HOME)
#   6. dconf load         (GNOME settings/theme/extensions, needs stow done first)
#
# Run from the repo root:  ./install.sh
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PACMAN_PKGS=(
  # core
  git stow zsh zsh-autosuggestions zsh-syntax-highlighting
  fzf zoxide eza tmux neovim ripgrep fd btop
  ghostty ttf-jetbrains-mono-nerd
  # hyprland
  hyprland hypridle hyprlock hyprpaper
  xdg-desktop-portal-hyprland dunst fuzzel cava rofi
  swaync network-manager-applet playerctl
  grim slurp wl-clipboard
  # gnome
  gnome-shell gnome-shell-extensions gnome-tweaks dconf
)

AUR_PKGS=(apple-fonts) # SF Pro fallback font used by dunstrc

STOW_PACKAGES=(
  bash zsh git tmux nvim btop ghostty hypr
  dunst fuzzel cava gnome scripts wallpapers rofi
)

log() { printf '== %s\n' "$*"; }

aur_helper() {
  command -v yay 2>/dev/null && return
  command -v paru 2>/dev/null && return
  log "no AUR helper found, bootstrapping yay"
  sudo pacman -S --needed --noconfirm base-devel git >&2
  local tmp
  tmp="$(mktemp -d)"
  git clone --depth 1 https://aur.archlinux.org/yay.git "$tmp" >&2
  (cd "$tmp" && makepkg -si --noconfirm) >&2
  command -v yay
}

step_pacman() {
  log "1/6 pacman packages"
  sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
}

step_aur() {
  log "2/6 AUR packages"
  local helper
  helper="$(aur_helper)"
  "$helper" -S --needed --noconfirm "${AUR_PKGS[@]}"
}

step_git_extras() {
  log "3/6 git extras"
  if [ -d "$HOME/powerlevel10k" ]; then
    echo "  ~/powerlevel10k exists, skip"
  else
    git clone --depth 1 https://github.com/romkatv/powerlevel10k "$HOME/powerlevel10k"
  fi

  if [ -d "$HOME/.local/share/icons/MacTahoe" ]; then
    echo "  MacTahoe icon theme exists, skip"
  else
    local tmp=/tmp/mactahoe-icons
    [ -d "$tmp" ] || git clone --depth 1 https://github.com/vinceliuice/MacTahoe-icon-theme "$tmp"
    (cd "$tmp" && ./install.sh)
  fi
}

step_backup_conflicts() {
  log "4/6 backup files that would block stow"
  local pkg src target bak
  for pkg in "${STOW_PACKAGES[@]}"; do
    [ -d "$REPO/$pkg" ] || continue
    while IFS= read -r -d '' src; do
      target="$HOME/${src#"$REPO/$pkg/"}"
      if [ -e "$target" ] && [ ! -L "$target" ]; then
        bak="$target.pre-stow"
        echo "  $target -> $bak"
        mkdir -p "$(dirname "$bak")"
        mv "$target" "$bak"
      fi
    done < <(find "$REPO/$pkg" -type f -print0)
  done
}

step_stow() {
  log "5/6 stow"
  cd "$REPO"
  stow --restow "${STOW_PACKAGES[@]}"
}

step_dconf() {
  log "6/6 dconf (GNOME settings, keybinds, enabled extensions)"
  local snap="$REPO/gnome/snapshot/dconf-full.dconf"
  if dconf load / < "$snap" 2>/dev/null; then
    :
  else
    echo "  dconf load failed (no session bus?) - run manually inside GNOME:"
    echo "  dconf load / < $snap"
  fi
}

main() {
  command -v pacman >/dev/null || { echo "pacman not found, this targets Arch/CachyOS" >&2; exit 1; }
  step_pacman
  step_aur
  step_git_extras
  step_backup_conflicts
  step_stow
  step_dconf
  echo
  echo "Done. Log out/in for zsh + GNOME theme, or reboot into Hyprland."
  echo "Make zsh your login shell if it isn't already: chsh -s /usr/bin/zsh"
}

main "$@"
