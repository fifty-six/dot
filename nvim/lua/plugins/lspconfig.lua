local nest = require('nest')

local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    nest.applyKeymaps {
        buffer = bufnr,
        { 'g', {
            { 'D', vim.lsp.buf.declaration, options = { desc = "declaration" }},
            { 'd', vim.lsp.buf.definition, desc = "definition" },
            { 'i', vim.lsp.buf.implementation, desc = "implementation" },
            { 'r', vim.lsp.buf.references, desc = "Show references." },
        }},
        { '<leader>', {

            { 'wa', vim.lsp.buf.add_workspace_folder, desc = "add_workspace_folder" },
            { 'wr', vim.lsp.buf.remove_workspace_folder, desc = "remove_workspace_folder" },
            { 'D',  vim.lsp.buf.type_definition, desc = "type_definition" },
            { 'rn', vim.lsp.buf.rename, desc = "rename" },
            { 'ce', vim.lsp.buf.hover, desc = "LSP hover action." },
        }},
        { 'K', vim.lsp.buf.hover, desc = "hover" },
        { '<C-k>', vim.lsp.buf.signature_help, desc = "signature_help" }
    }

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    do
        ---@format disable

    end

    vim.keymap.set(
        'n',
        '<leader>ih',
        function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
        end
    )


    vim.keymap.set(
        { 'n', 'v' },
        '<leader>ca',
        vim.lsp.buf.code_action,
        { desc = "code_action", table.unpack(bufopts) }
    )

    vim.keymap.set(
        'n',
        '<space>f',
        function()
            vim.lsp.buf.format { async = true }
        end,
        { desc = "Format", table.unpack(bufopts) }
    )

    vim.keymap.set(
        'n',
        '<space>wl',
        function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        { desc = "List workspace folders", table.unpack(bufopts) }
    )
end

return {
    {
        'Julian/lean.nvim',
        event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

        dependencies = {
            'neovim/nvim-lspconfig',
            'nvim-lua/plenary.nvim',
        },

        opts = {
            lsp = {
                on_attach = on_attach,
            },
            mappings = true,
        }
    },

    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        lazy = false,   -- This plugin is already lazy
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    on_attach = function(idk, bufnr)
                        local bufopts = { noremap = true, silent = true, buffer = bufnr }

                        -- Call the LSP on_attach
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
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                python = { "isort", "black" },
                rust = { "rustfmt", lsp_format = "fallback" },
                nix = { "nixd" }
            }
        },
        config = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()";
        end
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = { "folke/neoconf.nvim", "folke/neodev.nvim" },
        -- event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("neoconf").setup {}
            require("neodev").setup {}

            local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            o = { on_attach = on_attach, capabilities = capabilities }

            local lsps = {
                'futhark_lsp',
                'zls',
                -- { 'pylsp', plugins = { rope_autoimport = { enabled = true } } },
                -- 'pyright',
                'basedpyright',
                -- 'clangd',
                -- 'rust_analyzer',
                'racket_langserver',
                'arduino_language_server',
                -- 'verible',
                -- 'veridian',
                'dafny',
                'jsonnet_ls',
                'nixd',
                'ts_ls',
                'purescriptls',
                'jinja_lsp',
            }

            lspconfig.clangd.setup({
                cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
                init_options = {
                    fallbackFlags = { '-std=c++17' },
                },
            })

            for _, v in pairs(lsps) do
                if type(v) == "string" then
                    lspconfig[v].setup(o)
                else
                    -- Add our default opts, then remove the main value string
                    opts = { table.unpack(o), table.unpack(v) }
                    opts[v[1]] = nil

                    lspconfig[v[1]].setup(opts)
                end
            end


            lspconfig.sourcekit.setup({
                filetypes = { "swift", "objective-c", "objective-cpp" },
                table.unpack(o)
            })

            lspconfig.lua_ls.setup {
                before_init = require("neodev.lsp").before_init,
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {
                                'vim',
                                'require'
                            },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }

            -- I really gotta figure out a less shit way for clangd to not explode on embedded stuff
            -- lspconfig.clangd.setup {
            --     on_attach = on_attach,
            --     capabilities = capabilities,
            --     cmd = {
            --         "clangd",
            --         -- '--query-driver=/home/home/.platformio/packages/toolchain-gccarmnoneeabi/bin/arm-none-eabi-g++',
            --         -- '--query-driver=/usr/bin/avr-gcc'
            --     },

            -- }

            lspconfig.hls.setup {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    haskell = {
                        plugin = {
                            stan = {
                --             -- I cannot stand 4000 strict data type warnings, and HLS doesn't respect the stan config files :/
                                globalOn = false,
                            },
                        },
                    },
                },
            }


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
