# dotfiles_stow

GNU Stow-managed dotfiles. Each top-level dir is a *package* whose contents mirror `$HOME`.

## Layout

```
zsh/      .zshrc  .zshenv  .zprofile
bash/     .bashrc  .bash_profile  .bash_logout
git/      .gitconfig
tmux/     .tmux.conf
nvim/     .config/nvim/
ghostty/  .config/ghostty/
btop/     .config/btop/
hypr/     .config/hypr/
scripts/  .local/bin/            (drop personal scripts here)
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
