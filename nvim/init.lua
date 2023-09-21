vim.cmd([[
    set tabstop=4
    set expandtab
    set shiftwidth=4
    set smarttab

    let mapleader = " "
    let maplocalleader = "\\"

    set number

    command! Bwq w|bd

    augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source ~/.config/nvim/init.lua | PackerCompile
    augroup end
]])

map = vim.keymap.set

-- moyai
if not table.unpack then
    --- @diagnostic disable-next-line: deprecated
    table.unpack = unpack
end

require('packer').startup{function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "c", "lua", "zig" },
                highlight = { enable = true },
                indent = { enable = true }
            }
        end
    }

    -- Signatures while calling methods
    use { "ray-x/lsp_signature.nvim",
        config = function()
            require('lsp_signature').setup {}
        end
    }
    -- Show contexts
    use { "nvim-treesitter/nvim-treesitter-context" }


    -- Go to the last place in a file you had open previously
    use {
        "ethanholz/nvim-lastplace",
        config = function()
            require('nvim-lastplace').setup {}
        end,
    }

    -- Shows a loading thing for LSP servers
    use {
        "j-hui/fidget.nvim",
        tag = "legacy",
        config = function()
            require('fidget').setup { }
        end
    }

    -- Very pretty UI stuff for like renaming LSP actions and such
    use {
        "stevearc/dressing.nvim",
        config = function()
            require('dressing').setup { }
        end
    }

    use { "rcarriga/nvim-notify" }

    use { "akinsho/bufferline.nvim",
          config = function()
            require("bufferline").setup {
                options = {
                    always_show_bufferline = false,

                    separator_style = 'slant'
                },

                highlights = {
                    buffer_selected = {
                        bold = false,
                        italic = false
                    }
                }
            }
        end
    }
    -- use {
    --     "smjonas/snippet-converter.nvim",
    --     config = function()
    --         local template = {
    --             sources = {
    --                 ultisnips = {
    --                     vim.fn.stdpath("config") .. "/UltiSnips",
    --                 },
    --             },
    --             output = {
    --                 -- Specify the output formats and paths
    --                 vscode_luasnip = {
    --                     vim.fn.stdpath("config") .. "/luasnip_snippets",
    --                 },
    --             },
    --         }

    --         require("snippet_converter").setup {
    --             templates = { template },
    --         }
    --     end
    -- }

    -- Use to change surrounding chars/add
    -- cs"' (no i needed)
    -- ys(...)
    -- e.g. ysw"
    use { "tpope/vim-surround" }

    -- Allows you to add surrounding things as opposed to just manipulating them
    -- e.g. ysw' -> add ' around a word
    use {
        "machakann/vim-sandwich",
        config = function()
            -- Gives bindings similar to vim-surround.
            vim.cmd("runtime macros/sandwich/keymap/surround.vim")
        end
    }

    -- Highlights instances of letters on a line for easier f[x]
    -- TODO: Maybe remove now that we have hop.nvim?
    -- use { "unblevable/quick-scope" }

    -- Let's you jump around your file v quickly
    use {
        'smoka7/hop.nvim',
        config = function()
            local hop = require('hop')

            hop.setup {
                -- Keys used for the hints!
                keys = 'etovxqpdygfblzhckisuran'
            }

            map(
                { "n", "v" },
                "<Space><Space>",
                hop.hint_patterns,
                { desc = "Hop to a pattern!" }
            )
            map(
                "n",
                "<Space>f",
                function()
                    hop.hint_patterns { current_line_only = true }
                end,
                { desc = "Hop to a pattern inline!" }
            )
        end
    }

    -- Proof Assistant for interactive Coq development
    use { "whonore/Coqtail",
        branch = 'main',
        setup = function()
            vim.g.coqtail_nomap = 1
            vim.api.nvim_set_hl(0, "CoqtailChecked", { bg = "#353b45" })
            vim.api.nvim_set_hl(0, "CoqtailSent", { bg = "#333333" })
        end,
        config = function()
            vim.api.nvim_set_hl(0, "CoqtailChecked", { bg = "#353b45" })
            vim.api.nvim_set_hl(0, "CoqtailSent", { bg = "#333333" })
            map("n", "<Space>cl", "<Plug>CoqToLine", { desc = "Evaluate Coq to line" })
        end
    }

    -- Theme
    use { 'sam4llis/nvim-tundra',
        config = function()
            vim.opt.background = 'dark'
            vim.cmd('colorscheme tundra')
        end,
    }

    -- Indent guides
    use "lukas-reineke/indent-blankline.nvim"

    -- LSP Support
    use { "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            local on_attach = function(_, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local bufopts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set('n', 'gD',                            vim.lsp.buf.declaration,                            { desc = "declaration",             table.unpack(bufopts) })
                vim.keymap.set('n', 'gd',                            vim.lsp.buf.definition,                             { desc = "definition",              table.unpack(bufopts) })
                vim.keymap.set('n', 'K',                             vim.lsp.buf.hover,                                  { desc = "hover",                   table.unpack(bufopts) })
                vim.keymap.set('n', 'gi',                            vim.lsp.buf.implementation,                         { desc = "implementation",          table.unpack(bufopts) })
                vim.keymap.set('n', '<C-k>',                         vim.lsp.buf.signature_help,                         { desc = "signature_help",          table.unpack(bufopts) })
                vim.keymap.set('n', '<leader>wa',                    vim.lsp.buf.add_workspace_folder,                   { desc = "add_workspace_folder",    table.unpack(bufopts) })
                vim.keymap.set('n', '<leader>wr',                    vim.lsp.buf.remove_workspace_folder,                { desc = "remove_workspace_folder", table.unpack(bufopts) })
                vim.keymap.set('n', '<leader>D',                     vim.lsp.buf.type_definition,                        { desc = "type_definition",         table.unpack(bufopts) })
                vim.keymap.set('n', '<leader>rn',                    vim.lsp.buf.rename,                                 { desc = "rename",                  table.unpack(bufopts) })
                vim.keymap.set('n', '<leader>ca',                    vim.lsp.buf.code_action,                            { desc = "code_action",             table.unpack(bufopts) })
                vim.keymap.set("n", "<leader>ce",                    vim.lsp.buf.hover,                                  { desc = "LSP hover action.",       table.unpack(bufopts) })
                vim.keymap.set('n', 'gr',                            vim.lsp.buf.references,                             { desc = "Show references.",        table.unpack(bufopts) })

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
                    { desc="List workspace folders", table.unpack(bufopts) })
            end

            lspconfig.zls.setup { on_attach = on_attach }
            -- lspconfig.pylsp.setup {}
            lspconfig.pyright.setup { on_attach = on_attach }
            lspconfig.clangd.setup { on_attach = on_attach }
            lspconfig.rust_analyzer.setup { on_attach = on_attach }

            -- TODO: lua_ls
            lspconfig.lua_ls.setup {
                on_attach = on_attach,
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
            -- lspconfig.sumneko_lua.setup {
            --     on_attach = on_attach,
            --     settings = {
            --         Lua = {
            --             diagnostics = {
            --                 globals = { "vim" },
            --             },
            --             workspace = {
            --                 library = {
            --                     [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            --                     [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            --                 },
            --                 maxPreload = 100000,
            --                 preloadFileSize = 10000,
            --             },
            --         },
            --     },
            -- }

            lspconfig.racket_langserver.setup { on_attach = on_attach }
            lspconfig.arduino_language_server.setup { on_attach = on_attach }
            lspconfig.pyright.setup { on_attach = on_attach }
            lspconfig.clangd.setup {
                on_attach = on_attach,
                cmd = {
                    "clangd",
                    -- '--query-driver=/home/home/.platformio/packages/toolchain-gccarmnoneeabi/bin/arm-none-eabi-g++',
                    '--query-driver=/usr/bin/avr-gcc'
                },

            }
            lspconfig.hls.setup {
                settings = {
                    haskell = {
                        plugin = {
                            stan = { 
                                globalOn = false,
                            },
                        },
                    },
                },
                -- settings = {
                --     haskell = { 
                --         plugin = { 
                --             -- I cannot stand 4000 strict data type warnings, and HLS doesn't respect the stan config files :/
                --             stan = { globalOn = false }
                --         }
                --     }
                -- }
            }


            local opts = { noremap = true, silent = true }

            vim.keymap.set('n', '<leader>e',  vim.diagnostic.open_float, { desc = "Open floating diagnostic",  table.unpack(opts) })
            vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,  { desc = "Go to previous diagnostic", table.unpack(opts) })
            vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,  { desc = "Go to next diagnostic",     table.unpack(opts) })
            vim.keymap.set('n', '<leader>q',  vim.diagnostic.setloclist, { desc = "Set loc list",              table.unpack(opts) })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,   { desc = "Execute code action.",      table.unpack(opts) })
        end,
    }

    -- LaTeX
    use { "lervag/vimtex",
        config = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_quickfix_mode = 0
            -- vim.g.tex_conceal = "abdmg"
            -- vim.g.tex_superscripts = "[a-zA-Z]"
            -- vim.g.tex_subscripts="[a-zA-Z]"
            --
            vim.cmd [[
                let g:vimtex_syntax_conceal = {
                      \ 'accents': 1,
                      \ 'ligatures': 1,
                      \ 'cites': 1,
                      \ 'fancy': 1,
                      \ 'greek': 1,
                      \ 'math_bounds': 1,
                      \ 'math_delimiters': 1,
                      \ 'math_fracs': 1,
                      \ 'math_super_sub': 0,
                      \ 'math_symbols': 1,
                      \ 'sections': 0,
                      \ 'styles': 1,
                      \}
            ]]

            vim.cmd("set conceallevel=2")
        end
    }

    -- Uses the sign column line left of line numbers for git info
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            -- Always show the column for consistent UI
            vim.g.signcolumn = "yes"

            require('gitsigns').setup { }
        end
    }

    -- Easy alignment
    use { "junegunn/vim-easy-align",
        setup = function()
            for _, mode in ipairs({"n", "x"}) do
                vim.api.nvim_set_keymap(
                    mode,
                    "ga",
                    "<Plug>(EasyAlign)",
                    { noremap = false , silent = false }
                )
            end
        end
    }

    -- Preview lines when you do :[line_number]
    use { "nacro90/numb.nvim",
        event = "BufRead",
        config = function()
            require("numb").setup()
        end
    }

    -- Can pop up a list of diagnostics
    use { "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup { }
        end
    }

    -- Show errors kinda like what you get from rustc but inline
    use { "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            -- don't need dupes lol
            vim.diagnostic.config { virtual_text = false }

            require("lsp_lines").setup()

            vim.keymap.set(
                "n",
                "<Space>l",
                require('lsp_lines').toggle,
                { desc = "Toggle lsp_lines" }
            )
        end,

    }

    use { "NvChad/nvim-colorizer.lua",
        opt = true,
        setup = function()
            -- require("core.lazy_load").on_file_open "nvim-colorizer.lua"
        end,
        config = function()
            -- require("plugins.configs.others").colorizer()
        end,
    }

    use { "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    }

    -- TODO: Swap to this over ultisnips for perf
    -- use { "L3MON4D3/LuaSnip" ,
    --     wants = "friendly-snippets",
    --     after = "nvim-cmp",
    --     config = function()
    --         luasnips = require("luasnip")
    --         luasnips.config.setup { enable_autosnippets = true }
    --         require("luasnip/loaders/from_vscode")
    --             .load ({
    --                 paths = vim.fn.stdpath("config") .. "/luasnip_snippets"
    --             })
    --     end
    -- }

    -- use { "rafamadriz/friendly-snippets",
    --     module = { "cmp", "cmp_nvim_lsp" },
    --     event = "InsertEnter",
    -- }

    use { "SirVer/ultisnips",
        ft = { 'tex' },
        setup = function()
            vim.g.UltiSnipsSnipeptsDir = vim.fn.stdpath("config") .. "/UltiSnips"
            -- just don't be tab, that lags shit
            vim.g.UltiSnipsExpandTrigger = '<f5>'
            vim.g.UltiSnipsJumpForwardTrigger="<C-l>"
            vim.g.UltiSnipsJumpBackwardTrigger="<C-Shift-Tab>"
        end
    }

    use { "hrsh7th/nvim-cmp",
        -- after = "friendly-snippets",
        -- after = "LuaSnip",
        -- require = "quangnguyen30192/cmp-nvim-ultisnips",
        setup = function()
            vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
        end,

        config = function()
            require("plugins.cmp")
        end
    }

    use { "epwalsh/obsidian.nvim",
          require = { "hrsh7th/nvim-cmp", "nvim-telescope/telescope.nvim" },
          config = function()
            require("obsidian").setup({
                dir = "~/src/wiki",
                completion = {
                    nvim_cmp = true,
                }
            })
          end
    }

    -- use { "saadparwaiz1/cmp_luasnip",
    --     after = "LuaSnip",
    -- }

    use { "hrsh7th/cmp-nvim-lua",
        -- after = "cmp_luasnip",
    }

    use { "hrsh7th/cmp-nvim-lsp",
        after = "cmp-nvim-lua",
    }

    use { "hrsh7th/cmp-buffer",
        after = "cmp-nvim-lsp",
    }

    use { "hrsh7th/cmp-path",
        after = "cmp-buffer",
    }

    use {
        ft = { 'tex' },
        "quangnguyen30192/cmp-nvim-ultisnips",
        require = "SirVer/ultisnips"
    }

    -- misc plugins
    use { "windwp/nvim-autopairs",
        after = "nvim-cmp",
        config = function()
            -- require("plugins.configs.others").autopairs()
        end,
    }

    use { "goolord/alpha-nvim",
        after = "base46",
        disable = true,
        config = function()
            -- require "plugins.configs.alpha"
        end,
    }

    -- Easy commenting, as you'd expect
    use { "numToStr/Comment.nvim",
        module = "Comment",
        keys = { "gc", "gb" },
        config = function()
            -- require("plugins.configs.others").comment()
        end,
        setup = function()
            -- require("core.utils").load_mappings "comment"
        end,
    }

    -- file managing , picker etc
    use { "kyazdani42/nvim-tree.lua",
        ft = "alpha",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        config = function()
            -- require "plugins.configs.nvimtree"
        end,
        setup = function()
            -- require("core.utils").load_mappings "nvimtree"
        end,
    }

    use {
        "mbbill/undotree",
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
            vim.g.undotree_SetFocusWhenToggle = 1
        end
    }

    -- Fuzzy search window
    use { "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            -- require "plugins.configs.telescope"
        end,
        setup = function()
            -- require("core.utils").load_mappings "telescope"
        end,
    }

    use {
        "ixru/nvim-markdown"
    }

    -- Makes it so if you click a key, it'll pop-up what keys after do what
    -- e.g. hit g and it'll pop up e -> end of word, f -> file under cursor, etc.
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup { }
        end
    }

    use {
        "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
        requires = { { "nvim-treesitter" } },
        config = function()
        end
    }

    -- Speed up deferred plugins
    use { "lewis6991/impatient.nvim" }
end}
