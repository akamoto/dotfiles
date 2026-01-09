vim.cmd('set packpath+=~/.dotfiles/nvim')
-- disable standard netrw filebrowser before loading nvim-tree
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- vim.o.background = quote dark -- default
--vim.cmd([[colorscheme gruvbox]])
vim.cmd('let g:gruvbox_transparent_bg = 1')
vim.cmd('autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE')
vim.cmd('colorscheme gruvbox')


require('nvim-tree').setup({
--  sort = { sorter = 'case_sensitive', },
    view = { width = 30, },
--  renderer = { group_empty = true, },
--  filters = { dotfiles = true, },
})


require('nvim-treesitter').install({ 
    'awk',
    'bash',
    'c',
    'cmake',
    'css',
    'csv',
    'diff',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'go',
    'haskell',
    'html',
    'http',
    'ini',
    'jinja',
    'json',
    'json',
    'markdown',
    'markdown_inline',
    'muttrc',
    'nginx',
    'passwd',
    'perl',
    'php',
    'powershell',
    'printf',
    'python',
    'regex',
    'sql',
    'terraform',
    'udev',
    'vim',
    'vimdoc',
    'yaml',
})

require('nvim-tmux-navigation').setup( {
    disable_when_zoomed = true, -- Optional: Keep navigation within Neovim when zoomed
    keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
--        last_active = "<C-\\>",
--        next = "<C-Space>",
    },
})
--vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
--vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
--vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
--vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
--vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
--vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)


-- auto focus and resize windows
require("focus").setup()
local focus_ignore_filetypes = { 'NvimTree' }
local focus_ignore_buftypes = { 'nofile', 'prompt', 'popup' }

local focus_augroup =
    vim.api.nvim_create_augroup('FocusDisable', { clear = true })

vim.api.nvim_create_autocmd('WinEnter', {
    group = focus_augroup,
    callback = function(_)
        if vim.tbl_contains(focus_ignore_buftypes, vim.bo.buftype)
        then
            vim.w.focus_disable = true
        else
            vim.w.focus_disable = false
        end
    end,
    desc = 'Disable focus autoresize for BufType',
})

vim.api.nvim_create_autocmd('FileType', {
    group = focus_augroup,
    callback = function(_)
        if vim.tbl_contains(focus_ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
        else
            vim.b.focus_disable = false
        end
    end,
    desc = 'Disable focus autoresize for FileType',
})

 
require'nvim-lastplace'.setup({
--    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
--    lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
--    lastplace_open_folds = true
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


-- settings

vim.opt.mouse=""

vim.opt.shiftwidth=4
vim.opt.shiftwidth=4
vim.opt.smarttab=true
vim.opt.expandtab=true

vim.opt.scrolloff=3
vim.opt.cursorline=true

vim.opt.incsearch=true
vim.opt.ignorecase=true
vim.opt.smartcase=true

vim.opt.confirm=true -- raise error with confirm dialog
vim.opt.wildmenu=true
vim.opt.wildmode='list:longest'

vim.opt.autoindent=true
vim.opt.smartindent=true

-- remember undo over sessions
vim.opt.undofile=true

-- toggle scroll-lock
vim.keymap.set('n', '<leader>sl', function() vim.opt.scrolloff = 999 - vim.o.scrolloff end)

-------------
-- keymapping
--
-- If the terminals backspace is not bound to the linux default 'stty erase ^?'
-- the 'CTRL+H' remaps below will not work as intended.
---
-- cmdline
vim.keymap.set('c', '<C-h>', '<Left>')
vim.keymap.set('c', '<C-h>', '<Down>')
vim.keymap.set('c', '<C-k>', '<Up>')
vim.keymap.set('c', '<C-l>', '<Right>')

---
-- normal mode
vim.keymap.set('n', '<leader><Space>', '<cmd>noh<CR>')
vim.keymap.set('n', '<leader>cl', '<cmd>set cursorline! cursorcolumn!<CR>')

-- superseded by nvim-tmux-navigator
---- window movement
--vim.keymap.set('n', '<C-h>', '<C-w>h')
--vim.keymap.set('n', '<C-j>', '<C-w>j')
--vim.keymap.set('n', '<C-k>', '<C-w>k')
--vim.keymap.set('n', '<C-l>', '<C-w>l')

-- plugins
vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeToggle<CR>')

vim.keymap.set('n', '<leader>g', '<cmd>Git<CR>')
vim.keymap.set('n', '<leader>gp', '<cmd>Git push<CR>')
vim.keymap.set('n', '<leader>gb', '<cmd>GBrowse<CR>')

