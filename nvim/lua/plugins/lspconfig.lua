local nest = require('nest')

local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

    function toggle_inlay_hint()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    end

    function list_workspace_folders()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end

    nest.applyKeymaps {
        buffer = bufnr,
        { 'g', {
            { 'D', vim.lsp.buf.declaration, options = { desc = "Go to declaration" }},
            { 'd', vim.lsp.buf.definition, options = { desc = "Go to definition" } },
            { 'i', vim.lsp.buf.implementation, options = { desc = "Go to implementation" } },
            { 'r', vim.lsp.buf.references, options = { desc = "Show references." } },
        }},

        { '<leader>', {
            -- Workspaces
            { 'w', {
                { 'a', vim.lsp.buf.add_workspace_folder, options = { desc = "add_workspace_folder" }},
                { 'r', vim.lsp.buf.remove_workspace_folder, options = { desc = "remove_workspace_folder" }},
                { 'l', list_workspace_folders, options = { desc = "List workspace folders" }},
            }},

            { 'D',  vim.lsp.buf.type_definition, options = { desc = "type_definition" }},
            { 'rn', vim.lsp.buf.rename, options = { desc = "Rename" }},
            { 'ih', toggle_inlay_hint, options = { desc = "Toggle inlay hint" }},
            { '<space>f', function() vim.lsp.buf.format { async = true } end, { desc = "Format buffer" }},

            { mode = 'nv', 'ca', vim.lsp.buf.code_action, options = { desc = "Code action" }},
        }},

        { 'K', vim.lsp.buf.hover, options = { desc = "hover" } },

        { '<C-k>', vim.lsp.buf.signature_help, options = { desc = "signature_help" } },
    }
end

return {
    {
        'mrcjkb/rustaceanvim',
        version = '^4',
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    on_attach = function(idk, bufnr)
                        local bufopts = { noremap = true, silent = true, buffer = bufnr }

                        on_attach(idk, bufnr)

                        -- override the hover action to be rustacean's
                        vim.keymap.set("n", "<leader>ce", function() vim.cmd.RustLsp { 'hover', 'actions' } end,
                            { desc = "LSP hover action.", table.unpack(bufopts) })
                    end
                }
            }
        end
    },

    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black
                }
            })
        end
    },

    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                rust = { "rustfmt", lsp_format = "fallback" },
                nix = { "alejandra" }
            }
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()";
        end,
    },

    -- lsp stuff for lua modules (specifically useful for nvim plugin completions)
    { "folke/lazydev.nvim", opts = {} },

    {
        "neovim/nvim-lspconfig",
        dependencies = { "folke/neoconf.nvim" },
        -- event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("neoconf").setup {}

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local servers = {
                common = {
                    on_attach = on_attach,
                    capabilities = capabilities
                },
                servers = {
                    futhark_lsp = {},
                    zls = {},
                    basedpyright = {},
                    racket_langserver = {},
                    arduino_language_server = {},
                    dafny = {},
                    jsonnet_ls = {},
                    nixd = {},
                    nil_ls = {},
                    ts_ls = {},
                    purescriptls = {},
                    jinja_lsp = {},
                    clangd = {
                        cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
                        -- init_options = {
                        --     fallbackFlags = { '-std=c++17' },
                        -- },
                    },
                    lua_ls = require("lsp.lua_ls"),
                    sourcekit = {
                        filetypes = { "swift", "objective-c", "objective-cpp" },
                    },
                    hls = {
                        settings = {
                            haskell = {
                                plugin = {
                                    stan = {
                                        -- I cannot stand 4000 strict data type warnings, and HLS doesn't respect the stan config files :/
                                        globalOn = false,
                                    },
                                },
                            },
                        },
                    },
                },
            }

            vim.lsp.config('*', servers.common)

            vim.iter(pairs(servers.servers)):each(function(name, cfg)
                ---@diagnostic disable-next-line: param-type-mismatch -- it's also a function
                local ok, res = pcall(vim.lsp.config, name, cfg)

                if not ok then
                    vim.notify(("Failed to configure %s, %s"):format(name, res))
                end

                vim.lsp.enable(name)
            end)

            local opts = { noremap = true, silent = true }

            do
                vim.keymap.set('n', '<leader>e',  vim.diagnostic.open_float, { desc = "Open floating diagnostic",  table.unpack(opts) })
                vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,  { desc = "Go to previous diagnostic", table.unpack(opts) })
                vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,  { desc = "Go to next diagnostic",     table.unpack(opts) })
                vim.keymap.set('n', '<leader>q',  vim.diagnostic.setloclist, { desc = "Set loc list",              table.unpack(opts) })
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,   { desc = "Execute code action.",      table.unpack(opts) })
            end
        end,
    },
}
