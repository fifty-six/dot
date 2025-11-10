local hostname = vim.fn.hostname()

if string.find(hostname, "zetier") == nil then
    return {}
end

return {
    -- oops
    { "ntpeters/vim-better-whitespace" },

    {
        "stevearc/conform.nvim",

        opts = {
            formatters_by_ft = {
                python = { "isort", "yapf" },
            },

            format_after_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        },
    },
}
