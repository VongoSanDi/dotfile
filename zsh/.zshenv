# 🌍 GLOBAL
export PATH="$HOME/.local/bin:$PATH"
export LANG="fr_FR.UTF-8"
export DOTFILES="$HOME/.dotfile"

# 📁 XDG Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# ✏️ EDITOR
export EDITOR="nvim"
export VISUAL="nvim"

# 🛠️ ZSH
export ZDOTDIR="$HOME/.dotfile/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# 🔍 FZF
if command -v rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/**"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
export FZF_DEFAULT_OPTS="--height 60% \
--border sharp \
--layout reverse-list \
--color bg+:-1,fg:gray,fg+:white,border:black,spinner:0,hl:yellow,header:blue,info:green,pointer:red,marker:blue,prompt:gray,hl+:red \
--prompt '∷ ' \
--pointer ▶ \
--marker ⇒"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"

# 📦 NVM (Node.js Version Manager)
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
[ -d "$NVM_DIR" ] || mkdir -p "$NVM_DIR"
if [ -s "/usr/share/nvm/nvm.sh" ]; then
  . "/usr/share/nvm/nvm.sh"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi

# 🖥️ Debian Sid specific
export APT_LISTCHANGES_FRONTEND=none
export DEBIAN_FRONTEND=noninteractive

# 🔗 Créer lien symbolique vers ~/.zshrc si nécessaire
[ -e "$HOME/.zshrc" ] || ln -s "$ZDOTDIR/.zshrc" "$HOME/.zshrc"
