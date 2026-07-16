# dotfiles_stow

GNU Stow-managed dotfiles. Each top-level dir is a *package* whose contents mirror `$HOME`.

## Fresh-machine bootstrap (one command)

```
sudo pacman -S --needed git stow
git clone https://github.com/Sahiljangra115/Dotfiles.git ~/dotfiles_stow
cd ~/dotfiles_stow
./install.sh
```

That installs every package (pacman + AUR), clones git-only extras
(powerlevel10k, MacTahoe icon/cursor theme), backs up any real files that
would block stow, symlinks everything, and loads the GNOME settings
snapshot. See `PACKAGES.md` for the full dependency list `install.sh` covers.

Re-login (or `hyprctl reload` / restart GNOME Shell) to pick up the new
shell + theme + extension state. Make zsh your login shell if it isn't
already: `chsh -s /usr/bin/zsh`.

## Layout

```
zsh/      .zshrc .zshenv .zprofile .p10k.zsh
bash/     .bashrc .bash_profile .bash_logout
git/      .gitconfig
tmux/     .tmux.conf
nvim/     .config/nvim/                     (LazyVim)
ghostty/  .config/ghostty/
btop/     .config/btop/
hypr/     .config/hypr/                     (hyprland + hypridle + hyprlock + hyprpaper)
dunst/    .config/dunst/                    (notifications)
fuzzel/   .config/fuzzel/
rofi/     .config/rofi/                     (app launcher, mainMod+S)
cava/     .config/cava/
scripts/  .local/bin/                       (drop personal scripts here)
wallpapers/ Pictures/Wallpapers/            (hyprpaper's active wallpaper)
gnome/    .config/{gtk-3.0, gtk-4.0, monitors.xml, mimeapps.list}
          .themes/                          (MacTahoe-Dark / -Light, + hdpi/solid variants)
          .local/share/gnome-shell/extensions/  (dash-to-dock, clipboard-indicator, arcmenu)
          snapshot/{dconf-full.dconf, extensions.list}  (NOT symlinked — read by install.sh)
```

## Usage

From this directory:

```
stow -t ~ <pkg>        # install symlinks
stow -D -t ~ <pkg>     # remove symlinks
stow -R -t ~ <pkg>     # restow (uninstall + install)
```

## Add a new package

1. `mkdir -p <pkg>/<path-relative-to-home>`
2. Move real config in.
3. `stow -t ~ <pkg>`.
4. Add the package name to `STOW_PACKAGES` in `install.sh`, and any new
   dependencies to `PACKAGES.md`.

## Refresh the GNOME snapshot after tweaking settings

```
dconf dump /  > ~/dotfiles_stow/gnome/snapshot/dconf-full.dconf
gnome-extensions list --enabled > ~/dotfiles_stow/gnome/snapshot/extensions.list
git -C ~/dotfiles_stow add gnome/snapshot && git -C ~/dotfiles_stow commit -m "refresh gnome snapshot"
```
