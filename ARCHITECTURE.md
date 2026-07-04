# Theme & Glass Effect Architecture

The desktop customization for the GNOME shell and GTK applications consists of a layered layout managed by GNU Stow.

## Component Overview

```
                        ┌────────────────────────┐
                        │   GNU Stow Repository  │
                        │   (~/dotfiles_stow)    │
                        └───────────┬────────────┘
                                    │
                         stows      │
                                    ▼
                        ┌────────────────────────┐
                        │     ~/.themes/         │
                        │    (Tahoe-Dark)        │
                        └───────────┬────────────┘
                                    │
                    symlinked by    │
                     restore.sh     ▼
                        ┌────────────────────────┐
                        │   ~/.config/gtk-4.0/   │
                        │   (GTK4/libadwaita)    │
                        └────────────────────────┘
```

### 1. GNU Stow & Themes Folder
*   Themes are kept inside `dotfiles_stow/gnome/.themes/` and stowed to `~/.themes/`.
*   Active packages include `Tahoe-Dark`, `Tahoe-Light`, and `Tahoe-Dark-Amber`.

### 2. GTK4 / libadwaita Integration
*   GTK4 applications (such as Settings and Nautilus) ignore `~/.themes` directly.
*   To bypass this limitation, `restore.sh` symlinks the active theme's `gtk-4.0` directory contents (including `gtk.css`, `gtk-dark.css`, `assets`, and `windows-assets`) directly into `~/.config/gtk-4.0/`.

### 3. Glass / Blur Effect Implementation
*   **Fully Transparent CSS Backgrounds:** Instead of the default theme compilation which uses partial 0.75 opacity backgrounds, this layout utilizes the user's custom CSS rules. These rules explicitly target shell widgets, headers, stack views, and panes (e.g. `widget.content-pane`, `headerbar.titlebar`, `box.vertical`, `stack.view`) and set their background color to 100% transparent (`rgba(0,0,0,0)`).
*   **GNOME Shell Popover Styling:** 
    *   To make quick settings and notification drop-downs round and glass-like, styling must be applied directly to the `.popup-menu-boxpointer` container using `-arrow-background-color` (e.g. `rgba(20,20,24,0.65)`) and `-arrow-border-radius: 30px`.
    *   The inner `.popup-menu-content` is made transparent (`background-color: transparent`) to prevent double-rendering solid backgrounds, and `border-image: none` is applied to `.quick-settings` to remove square corner border artifacts.
*   **Compositor-Level Blur:** Because GTK/GNOME does not natively support CSS backdrop-filter (blurring content behind transparent windows), the `blur-my-shell` extension handles compositor-level Mutter shaders. It matches windows with transparent styling and applies a Gaussian blur to the pixels behind them, producing a premium frosted-glass appearance.
