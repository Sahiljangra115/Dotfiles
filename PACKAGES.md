# Packages required by these dotfiles

Arch / CachyOS names. `install.sh` installs all of these, in order.

## Core
- git, stow (dotfile management)
- zsh, zsh-autosuggestions, zsh-syntax-highlighting (zshrc sources /usr/share paths)
- fzf, zoxide, eza (zshrc aliases and integrations)
- tmux
- neovim, ripgrep, fd (telescope deps)
- btop
- ghostty
- ttf-jetbrains-mono-nerd (ghostty, fuzzel + hyprlock font)

## Hyprland
- hyprland, hypridle, hyprlock, hyprpaper
- xdg-desktop-portal-hyprland
- dunst, fuzzel, cava, rofi (rofi is the app launcher bound to $menu / mainMod+S)
- swaync, network-manager-applet, playerctl (exec-once / media binds)
- grim, slurp, wl-clipboard (screenshots, clipboard)

## GNOME
- gnome-shell, gnome-tweaks, dconf (settings restore via gnome/snapshot)
- gnome-shell theme + gtk theme: MacTahoe, stowed in gnome/.themes
- extensions stowed in gnome/.local/share/gnome-shell/extensions
  (dash-to-dock, clipboard-indicator, arcmenu; user-theme ships with
  gnome-shell-extensions package) — self-contained, no download needed
- gnome-shell-extensions (provides user-theme)

## AUR (via yay/paru)
- apple-fonts → SF Pro, first fallback font in dunst's font stack

## Installed from git (not pacman)
- powerlevel10k → ~/powerlevel10k (zshrc sources it)
- MacTahoe icon+cursor theme → vinceliuice/MacTahoe-icon-theme
  (dconf sets icon-theme=MacTahoe, cursor-theme=MacTahoe)
