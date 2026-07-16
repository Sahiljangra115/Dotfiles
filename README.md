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
would block stow, symlinks everything (including `~/.zsh_history`), loads
the GNOME settings snapshot, sets zsh as your login shell, and enables a
systemd timer that keeps `~/.zsh_history` pushed to this repo hourly. See
`PACKAGES.md` for the full dependency list `install.sh` covers.

Re-login (or `hyprctl reload` / restart GNOME Shell) to pick up the new
shell + theme + extension state.

## Manual install (if install.sh fails)

Run whichever step failed by hand, then re-run `./install.sh` — every step
is idempotent (safe to repeat).

```
# 1. pacman packages — see PACKAGES.md for the full list
sudo pacman -S --needed git stow zsh zsh-autosuggestions zsh-syntax-highlighting \
  fzf zoxide eza tmux neovim ripgrep fd btop ghostty ttf-jetbrains-mono-nerd \
  hyprland hypridle hyprlock hyprpaper xdg-desktop-portal-hyprland dunst fuzzel cava rofi \
  swaync network-manager-applet playerctl grim slurp wl-clipboard \
  gnome-shell gnome-shell-extensions gnome-tweaks dconf

# 2. AUR packages (needs yay or paru)
yay -S --needed apple-fonts

# 3. git-only extras
git clone --depth 1 https://github.com/romkatv/powerlevel10k ~/powerlevel10k
git clone --depth 1 https://github.com/vinceliuice/MacTahoe-icon-theme /tmp/mactahoe-icons
cd /tmp/mactahoe-icons && ./install.sh && cd -

# 4. back up any real dotfiles in the way, then stow
cd ~/dotfiles_stow
stow --adopt bash zsh git tmux nvim btop ghostty hypr dunst fuzzel cava gnome scripts wallpapers rofi systemd
git checkout .   # discard the adopted copies, keep this repo's versions

# 5. GNOME settings
dconf load / < ~/dotfiles_stow/gnome/snapshot/dconf-full.dconf

# 6. default shell
chsh -s "$(command -v zsh)"

# 7. history sync timer
systemctl --user daemon-reload
systemctl --user enable --now dotfiles-history-sync.timer
```

## Layout

```
zsh/      .zshrc .zshenv .zprofile .p10k.zsh .zsh_history
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
scripts/  .local/bin/                       (personal scripts + dotfiles-sync-history)
systemd/  .config/systemd/user/             (dotfiles-history-sync .service + .timer)
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

## History sync

`~/.zsh_history` is symlinked into `zsh/.zsh_history` in this repo, so every
command you run is already written straight into the repo's copy — no
separate step needed for that part. `dotfiles-history-sync.timer` (systemd
--user, hourly) commits + pushes it so a new machine's history is caught up
too. Needs a working `git push` (SSH key loaded) in your user session; check
with `systemctl --user status dotfiles-history-sync.timer`. Force a sync
now: `dotfiles-sync-history`.

## Refresh the GNOME snapshot after tweaking settings

```
dconf dump /  > ~/dotfiles_stow/gnome/snapshot/dconf-full.dconf
gnome-extensions list --enabled > ~/dotfiles_stow/gnome/snapshot/extensions.list
git -C ~/dotfiles_stow add gnome/snapshot && git -C ~/dotfiles_stow commit -m "refresh gnome snapshot"
```
