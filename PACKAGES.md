# Packages required by these dotfiles

Arch / CachyOS names. `install.py` installs all of these.

## Core
- git, stow (dotfile management)
- zsh, zsh-autosuggestions, zsh-syntax-highlighting (zshrc sources /usr/share paths)
- fzf, zoxide, eza (zshrc aliases and integrations)
- tmux
- neovim, ripgrep, fd (telescope deps)
- btop
- ghostty
- ttf-jetbrains-mono-nerd (ghostty + hyprlock font)

## Hyprland
- hyprland, hypridle, hyprlock, hyprpaper
- xdg-desktop-portal-hyprland
- dunst, fuzzel, cava
- swaync, network-manager-applet, playerctl (exec-once / media binds)
- grim, slurp, wl-clipboard (screenshots, clipboard)

## GNOME
- gnome-shell, gnome-tweaks, dconf (settings restore via gnome/snapshot)
- gnome-shell theme + gtk theme: MacTahoe, stowed in gnome/.themes
- extensions stowed in gnome/.local/share/gnome-shell/extensions
  (dash-to-dock, clipboard-indicator, arcmenu; user-theme ships with
  gnome-shell-extensions package)
- gnome-shell-extensions (provides user-theme)

## Installed from git (not pacman)
- powerlevel10k → ~/powerlevel10k (zshrc sources it)
- MacTahoe icon theme → vinceliuice/MacTahoe-icon-theme (dconf sets icon-theme=MacTahoe)
