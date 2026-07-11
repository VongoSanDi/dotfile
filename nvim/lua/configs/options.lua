local opt = vim.opt

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
opt.number = true
opt.relativenumber = true

-- Set to true to wrap lines
opt.wrap = true

-- Enable mouse mode
opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
vim.schedule(function() opt.clipboard = vim.env.SSH_TTY and "" or 'unnamedplus' end)
--opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- Enable break indent
opt.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
opt.undofile = true
opt.undolevels = 10000
opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false -- Don't highlight search results
opt.incsearch = true -- Show matches as you type

-- Keep signcolumn on by default
opt.signcolumn = 'yes'

-- Decrease update time
opt.updatetime = 250

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true
-- Determines the scroll behavior when opening,	closing or resizing horizontal splits
opt.splitkeep = "screen"

-- Sets how neovim will display certain whitespace characters in the editor.
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
opt.inccommand = 'split'
opt.tabstop = 2 -- Tab width
opt.shiftwidth = 2 -- Indent width
opt.softtabstop = 2 -- Soft tab stop
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Smart auto-indenting
opt.autoindent = true -- Copy indent from current line

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
opt.confirm = true

-- Use rounded borders for floating windows.
opt.winborder = 'rounded'

-- Visual settings
opt.termguicolors = true -- Enable 24-bit colors
opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor' -- Disable cursor blinking in terminal mode.
opt.showmatch = true -- Highlight matching brackets
opt.matchtime = 2 -- How long to show matching bracket
opt.cmdheight = 1 -- Command line height
opt.pumheight = 10 -- Popup menu height
opt.pumblend = 10 -- Popup menu transparency
opt.winblend = 0 -- Floating window transparency
--opt.completeopt = "menu,menuone,noselect"
opt.completeopt = "menuone,noselect,fuzzy,nosort" -- Always show completion list even if only 1 suggestion, will not directly insert the first item enable the fuzzy matching, keep the order from the completion plugin
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.concealcursor = "" -- Don't hide cursor line markup
opt.synmaxcol = 300 -- Syntax highlighting limit
opt.ruler = false -- Disable the default ruler
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.winminwidth = 5 -- Minimum window width

-- File handling
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup before writing
opt.swapfile = false -- Don't create swap files
opt.updatetime = 300 -- Faster completion
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.ttimeoutlen = 0 -- Key code timeout
opt.autoread = true -- Auto reload files changed outside vim

-- Behavior settings
opt.hidden = true -- Allow hidden buffers
opt.errorbells = false -- No error bells
opt.backspace = "indent,eol,start" -- Better backspace behavior
opt.autochdir = false -- Don't auto change directory
opt.iskeyword:append("-") -- Treat dash as part of word
opt.path:append("**") -- include subdirectories in search
opt.selection = "exclusive" -- Selection behavior
opt.isfname = "@-@"
opt.modifiable = true -- Allow buffer modifications
opt.encoding = "UTF-8" -- Set encoding

-- Folding settings
opt.smoothscroll = true
vim.wo.foldmethod = "expr"
opt.foldlevel = 99 -- Start with all folds open
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Command-line completion
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar",  "*/node_modules/*", "*/target/*"  })

-- Better diff options
opt.diffopt:append("linematch:60")

-- Performance improvements
opt.redrawtime = 10000
opt.maxmempattern = 20000

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

-- vim.opt.fillchars = {
--     eob = ' ',
--     fold = ' ',
--     foldclose = arrows.right,
--     foldopen = arrows.down,
--     foldsep = ' ',
--     foldinner = ' ',
--     msgsep = '─',
-- }

opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.shiftround = true -- Round indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })

opt.background = "dark"
opt.spelllang = { "en", "fr" }

vim.g.netrw_banner = 0

vim.filetype.add({
  extension = {
    env = "dotenv",
  },
  filename = {
    [".env"] = "dotenv",
    ["env"] = "dotenv",
    ['.eslintrc.json'] = 'jsonc'
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
    -- Borrowed from LazyVim. Mark huge files to disable features later(LSP, treesitter, etc.)
    ['.*'] = function(path, bufnr)
        return vim.bo[bufnr]
                and vim.bo[bufnr].filetype ~= 'bigfile'
                and path
                and vim.fn.getfsize(path) > (1024 * 500) -- 500 KB
                and 'bigfile'
            or nil
    end,
  },
})

-- Silence `wl-paste`'s "Nothing is copied" stderr on an empty Wayland clipboard.
if vim.fn.has('linux') == 1 and vim.env.WAYLAND_DISPLAY then
    vim.g.clipboard = {
        name = 'wl-clipboard',
        copy = {
            ['+'] = 'wl-copy --type text/plain',
            ['*'] = 'wl-copy --primary --type text/plain',
        },
        paste = {
            ['+'] = { 'sh', '-c', 'wl-paste --no-newline 2>/dev/null || true' },
            ['*'] = { 'sh', '-c', 'wl-paste --primary --no-newline 2>/dev/null || true' },
        },
        cache_enabled = true,
    }
end
