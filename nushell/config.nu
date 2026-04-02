## GENERAL
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.use_kitty_protocol = true
$env.config.history.max_size = 200
$env.LS_COLORS = (vivid generate catppuccin-mocha)

## ALIASES
alias vi = nvim
alias lg = lazygit
alias ls = eza --long --icons --header --no-permissions --created --modified --no-user
alias lsa = eza --all --long --icons --header --no-permissions --created --modified --no-user
alias lt = eza --icons --tree --level=1 --group-directories-first -h --long --no-permissions --no-user --no-time 
alias lt2 = eza --icons --tree --level=2 --group-directories-first -h --long --no-permissions --no-user --no-time 
alias lt3 = eza --icons --tree --level=3 --group-directories-first -h --long --no-permissions --no-user --no-time
alias lta = eza --icons --tree --group-directories-first -h --long --no-permissions --no-user --no-time

alias rm = rm -iv

alias shutdown = systemctl shutdown
alias reboot = systemctl reboot
alias update = paru -Syu

## FUNCTIONS
# Create and navigate into a new directory
def mkcd [dir] {
    mkdir $dir
    cd $dir
}


## NUSHELL
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
