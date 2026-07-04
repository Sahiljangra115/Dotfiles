#!/usr/bin/env python3
"""Bootstrap a fresh Arch/CachyOS machine from this dotfiles repo.

Order matters:
  1. pacman packages        (binaries + /usr/share files the configs source)
  2. git-only extras        (powerlevel10k, MacTahoe icons)
  3. backup conflicts       (real files where stow wants symlinks)
  4. stow all packages      (configs land in $HOME)
  5. dconf load             (GNOME settings, needs themes/extensions in place)

Run from the repo root:  python install.py
"""

import shutil
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent
HOME = Path.home()

PACMAN_PKGS = [
    # core
    "git", "stow", "zsh", "zsh-autosuggestions", "zsh-syntax-highlighting",
    "fzf", "zoxide", "eza", "tmux", "neovim", "ripgrep", "fd", "btop",
    "ghostty", "ttf-jetbrains-mono-nerd",
    # hyprland
    "hyprland", "hypridle", "hyprlock", "hyprpaper",
    "xdg-desktop-portal-hyprland", "dunst", "fuzzel", "cava",
    "swaync", "network-manager-applet", "playerctl",
    "grim", "slurp", "wl-clipboard",
    # gnome
    "gnome-shell", "gnome-shell-extensions", "gnome-tweaks", "dconf",
]

STOW_PACKAGES = [
    "bash", "zsh", "git", "tmux", "nvim", "btop", "ghostty",
    "hypr", "dunst", "fuzzel", "cava", "gnome", "scripts", "wallpapers",
]

GIT_EXTRAS = [
    ("https://github.com/romkatv/powerlevel10k", HOME / "powerlevel10k"),
]


def run(cmd, **kw):
    print(f"  $ {' '.join(map(str, cmd))}")
    subprocess.run(cmd, check=True, **kw)


def step_packages():
    print("== 1/5 pacman packages")
    run(["sudo", "pacman", "-S", "--needed", "--noconfirm", *PACMAN_PKGS])


def step_git_extras():
    print("== 2/5 git extras")
    for url, dest in GIT_EXTRAS:
        if dest.exists():
            print(f"  {dest} exists, skip")
        else:
            run(["git", "clone", "--depth", "1", url, str(dest)])
    # MacTahoe icons (dconf expects icon-theme=MacTahoe)
    if not (HOME / ".local/share/icons/MacTahoe").exists():
        tmp = Path("/tmp/mactahoe-icons")
        if not tmp.exists():
            run(["git", "clone", "--depth", "1",
                 "https://github.com/vinceliuice/MacTahoe-icon-theme", str(tmp)])
        run(["./install.sh"], cwd=tmp)


def step_backup_conflicts():
    print("== 3/5 backup files that would block stow")
    for pkg in STOW_PACKAGES:
        for src in (REPO / pkg).rglob("*"):
            if src.is_dir():
                continue
            target = HOME / src.relative_to(REPO / pkg)
            if target.exists() and not target.is_symlink():
                bak = target.with_name(target.name + ".pre-stow")
                print(f"  {target} -> {bak}")
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.move(target, bak)


def step_stow():
    print("== 4/5 stow")
    run(["stow", "--restow", *STOW_PACKAGES], cwd=REPO)


def step_dconf():
    print("== 5/5 dconf (GNOME settings, keybinds, enabled extensions)")
    snap = REPO / "gnome/snapshot/dconf-full.dconf"
    try:
        with open(snap) as f:
            run(["dconf", "load", "/"], stdin=f)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("  dconf load failed (no session bus?) — run manually inside GNOME:")
        print(f"  dconf load / < {snap}")


def main():
    if shutil.which("pacman") is None:
        sys.exit("pacman not found, this script targets Arch/CachyOS")
    step_packages()
    step_git_extras()
    step_backup_conflicts()
    step_stow()
    step_dconf()
    print("\nDone. Log out/in for zsh + GNOME theme, or reboot into Hyprland.")


if __name__ == "__main__":
    main()
