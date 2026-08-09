# Project Status

## Current State

*   **Status:** User's custom fully transparent glass themes restored. Default application setting (`mimeapps.list`) fixed with absolute symlink management and Stow ignore rule. Local extension compiled and installed.
*   **Active Theme:** `Tahoe-Dark`
*   **Active Color Scheme:** `prefer-dark`

## System Configuration Details

*   **OS:** Arch Linux (with cachyos repo or similar package structure)
*   **GNOME Version:** GNOME Shell 50.2 (Wayland Session)
*   **Theme Package:** `mactahoe-gtk-theme` (AUR package built system-wide, but overridden locally by user's stowed `~/.themes/Tahoe-Dark` settings to support custom 100% transparency).
*   **MIME Defaults:** Managed via absolute symlink `~/.config/mimeapps.list -> /home/ladliju/dotfiles_stow/gnome/.config/mimeapps.list` (ignored in Stow to prevent relative symlink GLib replacement failures).
*   **Active Extensions:**
    1.  `dash-to-dock@micxgx.gmail.com`
    2.  `clipboard-indicator@tudmotu.com`
    3.  `user-theme@gnome-shell-extensions.gcampax.github.com`
    4.  `blur-my-shell@aunetx` (newly installed from source)

## Known Issues & Workarounds

*   **Dynamic Theme Switching:** Changing GTK themes requires updating the symlinks in `~/.config/gtk-4.0`. To swap themes, update `restore.sh` with the desired theme directory and run it again.

