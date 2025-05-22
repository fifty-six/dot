if not table.unpack then
    --- @diagnostic disable-next-line: deprecated
    table.unpack = unpack
end

map = vim.keymap.set

return {
    'LionC/nest.nvim'
}
