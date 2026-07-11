-- The base for the config is here: https://github.com/dam9000/kickstart-modular.nvim/tree/master
-- A great source of inspiration was from Maria : https://github.com/MariaSolOs/dotfiles/tree/main/.config/nvim

vim.loader.enable()

require('vim._core.ui2').enable({
	enable = true,
	msg = {
		target = 'cmd', -- options: cmd(classic), msg(similar to noice)
		pager = { height = 1 },
		msg = { height = 0.5, timeout = 4500 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
	},
})

-- Set <space> as the leader key
-- Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('configs')
require('plugins')
