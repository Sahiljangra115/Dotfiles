# dotfiles_stow

GNU Stow-managed dotfiles. Each top-level dir is a *package* whose contents mirror `$HOME`.

## Layout

```
zsh/      .zshrc  .zshenv  .zprofile
bash/     .bashrc  .bash_profile  .bash_logout
git/      .gitconfig
tmux/     .tmux.conf
nvim/     .config/nvim/                 (LazyVim)
ghostty/  .config/ghostty/
btop/     .config/btop/
hypr/     .config/hypr/                 (hyprland + hypridle + hyprlock + hyprpaper)
gnome/    .config/{gtk-3.0/bookmarks, monitors.xml, mimeapps.list}
          .themes/                       (Tahoe-Dark / -Amber / -Light)
          snapshot/{org-gnome.dconf, extensions.list}   (NOT symlinked — see Restore)
          restore.sh                                    (run on fresh machines)
scripts/  .local/bin/                   (drop personal scripts here)
```

## Usage

From this directory:

```
stow -t ~ <pkg>        # install symlinks
stow -D -t ~ <pkg>     # remove symlinks
stow -R -t ~ <pkg>     # restow (uninstall + install)
stow -t ~ */           # all packages at once
```

## Add a new package

1. `mkdir -p <pkg>/<path-relative-to-home>`
2. Move real config in.
3. `stow -t ~ <pkg>`.

---

## Dependencies — what to install before / after stow

Targets Arch Linux (pacman + AUR via `yay`). Adapt package names for other distros.

### Core (always needed)

```
sudo pacman -S --needed stow git
```

### zsh package

```
sudo pacman -S --needed zsh zsh-autosuggestions zsh-syntax-highlighting fzf eza yazi zoxide xorg-xhost
# powerlevel10k (cloned to ~/powerlevel10k, sourced from .zshrc)
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
# uv (Python package manager — used by ML venv aliases)
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Make zsh your login shell:
```
chsh -s /usr/bin/zsh
```

Optional (only if you use the `idf6` alias for ESP-IDF dev):
```
# follow https://docs.espressif.com/projects/esp-idf/en/v6.0/get-started/
```

### bash package

```
sudo pacman -S --needed bash bash-completion
```

### nvim package (LazyVim)

```
sudo pacman -S --needed neovim ripgrep fd lazygit
# fonts (LazyVim icons need a Nerd Font)
yay -S --needed ttf-jetbrains-mono-nerd     # or any nerd font you prefer
```

First nvim launch auto-installs all LazyVim plugins from `nvim/.config/nvim/lazy-lock.json`.

### tmux package

```
sudo pacman -S --needed tmux
```

### ghostty package

```
sudo pacman -S --needed ghostty                   # or: yay -S ghostty-git
```

### btop package

```
sudo pacman -S --needed btop
```

### hypr package (Hyprland desktop)

```
sudo pacman -S --needed hyprland hypridle hyprlock hyprpaper waybar wofi xdg-desktop-portal-hyprland polkit-gnome
```

After stow: `hyprctl reload` (in an active Hyprland session).

### gnome package

GNOME Shell 50.1+ assumed. Required CLIs are part of base GNOME — no extra install for `dconf` / `gnome-extensions`.

Extensions tracked in `gnome/snapshot/extensions.list`:

```
sudo pacman -S --needed gnome-shell-extensions       # provides user-theme
yay -S --needed gnome-shell-extension-dash-to-dock gnome-shell-extension-clipboard-indicator
# OR via the extensions website / gext CLI:
pipx install gnome-extensions-cli                    # provides `gext`
gext install dash-to-dock@micxgx.gmail.com clipboard-indicator@tudmotu.com
```

Restore dconf + enable extensions:

```
~/dotfiles_stow/gnome/restore.sh
```

To refresh the snapshot after tweaking GNOME settings:

```
dconf dump /org/gnome/          > ~/dotfiles_stow/gnome/snapshot/org-gnome.dconf
gnome-extensions list --enabled > ~/dotfiles_stow/gnome/snapshot/extensions.list
git -C ~/dotfiles_stow add gnome/snapshot && git -C ~/dotfiles_stow commit -m "refresh gnome snapshot"
```

### scripts package

Empty placeholder — drop your own scripts into `scripts/.local/bin/` then `stow -R -t ~ scripts`.

---

## Fresh-machine bootstrap (one-shot)

```
sudo pacman -S --needed stow git
git clone <repo-url> ~/dotfiles_stow
cd ~/dotfiles_stow
# install everything above for the packages you want, then:
stow -t ~ */
~/dotfiles_stow/gnome/restore.sh        # only if using GNOME
```

Re-login (or `hyprctl reload` / restart GNOME Shell) to pick up the new shell + theme + extension state.
