# =============================================================================
# 1. LOCALE / UTF-8
# =============================================================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# =============================================================================
# 2. POWERLEVEL10K INSTANT PROMPT  ← nothing that produces output after this
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# 3. ENVIRONMENT VARIABLES & PATH (deduplicated)
# =============================================================================
typeset -U path
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.opencode/bin:$HOME/flutter/bin:$PATH"

# =============================================================================
# 4. HISTORY
# =============================================================================
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

setopt SHARE_HISTORY           # share across shells (implies INC_APPEND_HISTORY)
setopt HIST_IGNORE_DUPS        # skip duplicate entries
setopt HIST_IGNORE_SPACE       # skip commands prefixed with space
setopt HIST_VERIFY             # expand !! before executing
setopt HIST_REDUCE_BLANKS      # strip extra whitespace from history
setopt HIST_EXPIRE_DUPS_FIRST  # when history full, drop dupes first

# =============================================================================
# 5. ZSH OPTIONS
# =============================================================================
setopt AUTO_CD                 # type dir name to cd
setopt CORRECT                 # suggest corrections on typos
setopt NO_CASE_GLOB            # case-insensitive globbing
setopt EXTENDED_GLOB           # ~, ^, # patterns in globs
setopt INTERACTIVE_COMMENTS    # allow # comments in interactive shell

# =============================================================================
# 6. COMPLETION
# =============================================================================
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive tab

# =============================================================================
# 7. ZSH PLUGINS  (Arch Linux — pacman -S zsh-autosuggestions zsh-syntax-highlighting)
# =============================================================================
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# =============================================================================
# 8. FZF
# =============================================================================
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

source /opt/esp-idf/export.sh

export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border --info=inline"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=up:3:wrap"

# =============================================================================
# 9. KEY BINDINGS
# =============================================================================
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^[[1;5D" backward-word   # Ctrl + Left
bindkey "^[[1;5C" forward-word    # Ctrl + Right

# =============================================================================
# 10. ALIASES
# =============================================================================
alias c='clear'
#alias ls='ls --color=auto'


alias ls='eza --icons --group-directories-first'
alias ll='eza -alF --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'

alias fm='yazi'

alias ll='ls -lah --color=auto'
alias gs='git status'
alias ..='cd ..'
alias ...='cd ../..'
# alias idf6='source /opt/esp-idf/export.sh'

# =============================================================================
# 11. DOCKER GUI  (fully silenced — was triggering p10k warning)
# =============================================================================
[[ -n "$DISPLAY" ]] && command -v xhost &>/dev/null && xhost +local:docker &>/dev/null

# =============================================================================
# 12. POWERLEVEL10K  (theme before config)
# =============================================================================
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# =============================================================================
# 13. ML VENV
# =============================================================================
export ML_VENV="/home/ladliju/Developer/Machine-learning/.venv"
export PATH="$ML_VENV/bin:$PATH"
export UV_PROJECT_ENVIRONMENT="$ML_VENV"
alias ml='source "$ML_VENV/bin/activate"'

# =============================================================================
# 14. ZOXIDE
# =============================================================================
export _ZO_DOCTOR=0
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd cd)"
