vim.cmd([[
    set tabstop=4
    set expandtab
    set shiftwidth=4
    set smarttab

    let mapleader = " "
    let maplocalleader = "\\"

    set number

    filetype plugin on

    command! Bwq w|bd
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

vim.api.nvim_create_autocmd("BufEnter", { pattern = "*.fut", callback = function()
    vim.api.nvim_buf_set_option(
        vim.api.nvim_get_current_buf(),
        "filetype",
        "futhark"
    )
end })

vim.opt.wildoptions:append('fuzzy')

-- Terminal colors!
-- black
vim.g.terminal_color_0  = "#6B7280"
vim.g.terminal_color_8  = "#6B7280"

-- red
vim.g.terminal_color_1  = "#ff646a"
vim.g.terminal_color_9  = "#f46d6d"

-- green
vim.g.terminal_color_2  = "#c1df7f"
vim.g.terminal_color_10 = "#e3ffa2"

-- yellow
vim.g.terminal_color_3  = "#f4bf75"
vim.g.terminal_color_11 = "#feca88"

-- blue
vim.g.terminal_color_4  = "#8ecee8"
vim.g.terminal_color_12 = "#a1d6ff"

-- magenta
vim.g.terminal_color_5  = "#d999cb"
vim.g.terminal_color_13 = "#f8b7ec"

-- cyan
vim.g.terminal_color_6  = "#9afaf3"
vim.g.terminal_color_14 = "#c7ffff"

-- white
vim.g.terminal_color_7  = "#565656"
vim.g.terminal_color_15 = "#373737"

if vim.g.neovide then
    vim.g.neovide_transparency = 0.8
    vim.g.neovide_scroll_animation_length = 0.1
    vim.g.neovide_cursor_animation_length = 0.02
    vim.g.neovide_cursor_trail_size = 0.2
    vim.g.neovide_padding_top = 20
    vim.g.neovide_padding_bottom = 20
    vim.g.neovide_padding_left = 20
    vim.g.neovide_padding_right = 20
end

-- holy shit yes
vim.keymap.set({ 'x' }, '<leader>y', '"+y', { desc = 'Copy from system clipboard' })

require("lazy").setup { 
    spec = {
        import = "plugins",
        dependencies = { 'LionC/nest.nvim' }
    },
    rocks = {
        hererocks = true 
    },
}
