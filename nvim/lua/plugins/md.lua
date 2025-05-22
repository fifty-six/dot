-- "required' (they are not required)
---@diagnostic disable: missing-fields

local opts = { noremap=true, silent=false }

return {
    { "epwalsh/obsidian.nvim",
        dependencies = { "hrsh7th/nvim-cmp", "nvim-telescope/telescope.nvim" },
        config = function()
            require("obsidian").setup({
                dir = "~/src/wiki",
                daily_notes = {
                    folder = "daily"
                },
                completion = {
                    nvim_cmp = true,
                }
            })
        end
    },

    {
        "mickael-menu/zk-nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("zk").setup {
                -- I do not like their LSP ngl
                lsp = { auto_attach = { enabled = false } }
            }
            require("telescope").load_extension("zk")

        end,
        keys = {
            -- Create a new note after asking for its title.
            {"<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = "ZkNew", table.unpack(opts) }},

            -- Open notes.
            {"<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", {desc = "Open Notes", table.unpack(opts)}},
            -- Open notes associated with the selected tags.
            {"<leader>zt", "<Cmd>ZkTags<CR>", {desc="Open notes w/ assoc. tags", table.unpack(opts)}},

            -- Search for the notes matching a given query.
            {"<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", {desc = "Search for notes matching query", table.unpack(opts)}},
            -- Search for the notes matching the current visual selection.
            {"<leader>zf", ":'<,'>ZkMatch<CR>", {desc="Search for notes matching selection", table.unpack(opts)}},
        }
    },

    {
        "arakkkkk/marktodo.nvim",
        -- dir = "~/src/marktodo.nvim",
        config = function()
            require("marktodo").setup {
                default_root_path = "/home/home/src/wiki",
                filter = "completion:[%s]",
                -- localized to-dos for certain 'groups' of things that I look at myself
                exclude_ops = "-g '!**/todo.md'",
                marktodo_patterns = {
                    priority = "%(([A-Z ]?)%)"
                },
            }
        end,
    },

    { "jakewvincent/mkdnflow.nvim",
        config = function()
            require("mkdnflow").setup {
                to_do = {
                    symbols = { 'x', ' ', '-', '/', 'X' },
                    complete = 'x'
                }
            }
        end
    },

    { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
    { "jbyuki/nabla.nvim", config = function()
        vim.cmd [[
            nmap <leader>p :lua require("nabla").popup()
        ]]
        -- I do not want this for .tex files
        -- require"nabla".enable_virt({
        --     autogen = true, -- auto-regenerate ASCII art when exiting insert mode
        --     silent = true,     -- silents error messages
        -- })
    end },

    { "benlubas/molten-nvim",
        build = ":UpdateRemotePlugins",
        config = function()
            -- Use virtual text instead of the floating window
            vim.g.molten_virt_text_output = true
            vim.g.molten_auto_open_output = false

            vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
                { silent = true, desc = "Initialize the plugin" })
            vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
                { silent = true, desc = "run operator selection" })
            vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>",
                { silent = true, desc = "evaluate line" })
            vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>",
                { silent = true, desc = "re-evaluate cell" })
            vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
                { silent = true, desc = "evaluate visual selection" })
            vim.keymap.set("n", "<localleader>rd", ":MoltenDelete<CR>",
                { silent = true, desc = "molten delete cell" })
            vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>",
                { silent = true, desc = "hide output" })
            vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>",
                { silent = true, desc = "show/enter output" })
        end
    },

    { "jmbuhr/otter.nvim",
        dependencies = {
            {
                'hrsh7th/nvim-cmp', -- optional, for completion
                'neovim/nvim-lspconfig',
                'nvim-treesitter/nvim-treesitter'
            }
        },
        opts = {
            lsp = {
                diagnostic_update_events = { "BufWritePost", "InsertLeave", "TextChanged" },
            },
            buffers = {
                set_filetype = true,
            }
        }
    },

    { "quarto-dev/quarto-nvim",
        config = function()
            local quarto = require("quarto")
            quarto.setup({
                lspFeatures = {
                    -- NOTE: put whatever languages you want here:
                    languages = { "r", "python", "rust", "lua" },
                    chunks = "all",
                    diagnostics = {
                        enabled = true,
                        triggers = { "BufWritePost", "InsertLeave", "TextChanged" },
                    },
                    completion = {
                        enabled = true,
                    },
                },
                keymap = {
                    -- NOTE: setup your own keymaps:
                    hover = "H",
                    definition = "gd",
                    rename = "<leader>rn",
                    references = "gr",
                    format = "<leader>gf",
                },
                codeRunner = {
                    enabled = true,
                    default_method = "molten",
                },
                dependencies = {
                    'jmbuhr/otter.nvim',
                }
            })

            local runner = require("quarto.runner")
            vim.keymap.set("n", "<localleader>rc", runner.run_cell,  { desc = "run cell", silent = true })
            vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
            vim.keymap.set("n", "<localleader>rA", runner.run_all,   { desc = "run all cells", silent = true })
            vim.keymap.set("n", "<localleader>rl", runner.run_line,  { desc = "run line", silent = true })
            vim.keymap.set("v", "<localleader>r",  runner.run_range, { desc = "run visual range", silent = true })
            vim.keymap.set("n", "<localleader>RA", function()
                runner.run_all(true)
            end, { desc = "run all cells of all languages", silent = true })
        end
    },

    {
        "GCBallesteros/jupytext.nvim",
        config = function()
            require("jupytext").setup({
                style = "markdown",
                output_extension = "md",
                force_ft = "markdown",
            })
        end
    }

}
