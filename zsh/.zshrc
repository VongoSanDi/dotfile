# ─────────────────────────────────────
# 🛠️  ENV
# ─────────────────────────────────────
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ─────────────────────────────────────
# 🚀 Starship prompt
# ─────────────────────────────────────
eval "$(starship init zsh)"

# ─────────────────────────────────────
# ⚙️  Plugins Zsh
# ─────────────────────────────────────
# Autosuggestions
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ─────────────────────────────────────
# ⚙️  ZSH config
# ─────────────────────────────────────
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Activer l'autocomplétion améliorée
autoload -Uz compinit
compinit -d "$ZDOTDIR/.zcompdump"

# Go to folder path without using cd
setopt AUTO_CD              

# Do not store duplicates in the stack
setopt PUSHD_IGNORE_DUPS    

# Spelling correction
setopt CORRECT              

# Use extended globbing syntax
setopt EXTENDED_GLOB        

# Write the history file in the ':start:elapsed;command' format
setopt EXTENDED_HISTORY

# Expire a duplicate event first when trimming history
setopt HIST_EXPIRE_DUPS_FIRST

# Do not record an event that was just recorded again
setopt HIST_IGNORE_DUPS

# Delete an old recorded event if a new event is a duplicate
setopt HIST_IGNORE_ALL_DUPS

# Do not display a previously found event
setopt HIST_FIND_NO_DUPS

# Do not record an event starting with a space
setopt HIST_IGNORE_SPACE

# Do not write a duplicate event to the history file
setopt HIST_SAVE_NO_DUPS

# Do not execute immediately upon history expansion
setopt HIST_VERIFY

# Supprime les espaces inutiles
setopt HIST_REDUCE_BLANKS

# Partage l'historique entre sessions
setopt SHARE_HISTORY

# ─────────────────────────────────────
# 📁 Aliases
# ─────────────────────────────────────
source $DOTFILES/aliases/aliases

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
