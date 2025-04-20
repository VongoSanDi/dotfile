# config.nu
#
# Installed by:
# version = "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

###############
#    UTILS    #
###############
use std/util "path add"

###############
#   EDITOR    #
###############
$env.config.edit_mode = "vi"
$env.config.buffer_editor = "nvim"
$env.STARSHIP_SHELL = "nu"

###############
#   GLOBAL    #
###############
path add "~/.local/bin"
path add ($env.HOME | path join ".bun/bin")
$env.DOTFILES = ($env.HOME | path join ".dotfile")

###############
#   THEMING   #
###############
$env.config.table.mode = "basic_compact"

###############
#   HISTORY   #
###############
# max_size (int): The maximum number of entries allowed in the history.
# After exceeding this value, the oldest history items will be removed
# as new commands are added.
$env.config.history.max_size = 5_000_000

###############
#   STARSHIP  #
###############
use ($nu.data-dir | path join "vendor/autoload/starship.nu")

###############
#   ALIASES   #
###############
# NVIM
alias vi = nvim

# LAZYGIT
alias lg = lazygit
