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
--  sort = {
--    sorter = 'case_sensitive',
--  },
  view = {
    width = 30,
  },
--  renderer = {
--    group_empty = true,
--  },
--  filters = {
--    dotfiles = true,
--  },
})

-- settings
vim.cmd('set cursorline')
vim.cmd('set scrolloff=3')

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

-- window movement
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- plugins
vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeToggle<CR>')

