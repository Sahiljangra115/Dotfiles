# Progress Tracking

## Completed Tasks

*   **Restored themes:** Restored the deleted theme source folders (`Tahoe-Dark`, `Tahoe-Light`, `Tahoe-Dark-Amber`) from the Git index in the stow repository (`dotfiles_stow/gnome/.themes/`).
*   **Restored custom transparency settings:** Re-checked out the user's custom transparent CSS configurations from Git history, discarding the default installer's output. This restores the exact choice of 0.0 opacity (`rgba(0,0,0,0)`) backgrounds on selectors like `widget.content-pane`, `headerbar.titlebar`, `calendar-view`, etc.
*   **Installed `blur-my-shell` extension:** Cloned and compiled the latest `blur-my-shell` extension from source to support GNOME Shell 50.2, placing it locally under `~/.local/share/gnome-shell/extensions/blur-my-shell@aunetx`.
*   **Updated Stow GNOME configuration:**
    *   Appended `blur-my-shell@aunetx` to `dotfiles_stow/gnome/snapshot/extensions.list`.
    *   Updated `dotfiles_stow/gnome/snapshot/org-gnome.dconf` to enable the `blur-my-shell` extension and remove it from the disabled extensions list.
    *   Modified `dotfiles_stow/gnome/restore.sh` to symlink the `windows-assets` directory (for window controls like close/minimize/maximize buttons) in addition to other assets.
*   **Re-applied GTK4 configuration symlinks:** Cleaned up the local files in `~/.config/gtk-4.0` and ran `restore.sh` to establish the correct symlinks pointing to the stowed `Tahoe-Dark` theme files.
*   **Fixed Popover Corners and Color:**
    *   Edited `gnome-shell.css` for both `Tahoe-Dark` and `Tahoe-Light` to set `-arrow-border-radius: 30px` and specify translucent colors directly on `.popup-menu-boxpointer` (Dark uses `rgba(20, 20, 24, 0.65)`, Light uses `rgba(255, 255, 255, 0.65)`).
    *   Made `.popup-menu-content` transparent to prevent nested solid background overlaps.
    *   Disabled `border-image` on `.quick-settings` to prevent boxy shadow rendering.
    *   Forced GNOME Shell to reload the theme dynamically by toggling it off and on in GSettings.
*   **Fixed `mimeapps.list` default application setting issue:**
    *   Resolved GTK/GLib `g_file_replace` failure (`Failed to create file "../dotfiles_stow/gnome/.config/mimeapps.list.XXXXXX": No such file or directory`) when setting default applications (e.g. VLC media player).
    *   Added `.config/mimeapps.list` to `gnome/.stow-local-ignore` to prevent Stow from creating relative symlinks for dynamic MIME configurations.
    *   Added `step_mimeapps` in `install.sh` to manage `~/.config/mimeapps.list` as an absolute symlink to `$REPO/gnome/.config/mimeapps.list`, allowing desktop apps to atomically save default app settings directly into git.
    *   Fixed `step_backup_conflicts` in `install.sh` to resolve symlink targets via `readlink -f` so stowed directories and files are skipped without creating unnecessary `.pre-stow` backup files inside the repo.

## Upcoming / Pending Actions

*   *All tasks completed successfully!*

