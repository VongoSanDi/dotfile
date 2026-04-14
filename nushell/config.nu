## GENERAL
$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.config.show_banner = false
$env.config.use_kitty_protocol = true
$env.config.history.max_size = 200
$env.LS_COLORS = (vivid generate catppuccin-mocha)

## ALIASES
alias n = nvim
alias lg = lazygit
alias ls = eza --long --icons --header --no-permissions --created --modified --no-user
alias lsa = eza --all --long --icons --header --no-permissions --created --modified --no-user --group-directories-first --modified
alias lt = eza --icons --tree --level=1 --group-directories-first -h --long --no-permissions --no-user --no-time --git-ignore
alias lta = eza --icons --tree --level=1 --group-directories-first -h --long --no-permissions --no-user --no-time
alias lt2 = eza --icons --tree --level=2 --group-directories-first -h --long --no-permissions --no-user --no-time --git-ignore
alias lta2 = eza --icons --tree --level=2 --group-directories-first -h --long --no-permissions --no-user --no-time
alias lt3 = eza --icons --tree --level=3 --group-directories-first -h --long --no-permissions --no-user --no-time --git-ignore
alias lta3 = eza --icons --tree --level=3 --group-directories-first -h --long --no-permissions --no-user --no-time

alias rm = rm -iv

alias poweroff = systemctl poweroff
alias reboot = systemctl reboot
alias update = paru -Syu

## FUNCTIONS
# Create and navigate into a new directory
def mkcd [dir] {
    mkdir $dir
    cd $dir
}

## STARSHIP
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

## YAZI
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}
source "~/.cargo/env.nu"
