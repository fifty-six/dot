-- "required' (they are not required)
---@diagnostic disable: missing-fields

local Util = require("util")
require("nest")

return {
    -- Highlighting
    {
        -- dependencies = { "andymass/vim-matchup" },
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "c", "lua", "zig" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "markdown" }
                },
                indent = { enable = true },
                matchup = { enable = true },
                -- disable = { "latex", "tex" }
            }
            vim.treesitter.language.register("bash", "zsh")
        end
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
            require 'nvim-treesitter.configs'.setup {
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        -- You can optionally set descriptions to the mappings (used in the desc parameter of
                        -- nvim_buf_set_keymap) which plugins like which-key display
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        -- You can also use captures from other query groups like `locals.scm`
                        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                        ["ap"] = "@parameter.outer",
                        ["ip"] = "@parameter.inner",
                    },
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V', -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true or false
                    include_surrounding_whitespace = true,
                },
            },
        }
        end
    },

    { "godlygeek/tabular" },
    -- Signatures while calling methods
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            require('lsp_signature').setup {}
        end
    },
    -- Show contexts
    -- { "nvim-treesitter/nvim-treesitter-context" },
    -- Go to the last place in a file you had open previously
    {
        "ethanholz/nvim-lastplace",
        config = function()
            require('nvim-lastplace').setup {}
        end,
    },
    -- Shows a loading thing for LSP servers
     {
         "j-hui/fidget.nvim",
         branch = "legacy",
         config = function()
             require('fidget').setup {}
         end
     },
     -- Very pretty UI stuff for like renaming LSP actions and such
     {
         "stevearc/dressing.nvim", opts = {}
     },
     {
         "rcarriga/nvim-notify",
         config = function()
             vim.notify = require('notify')

             vim.notify.setup({
                 background_colour = "#000000",
             })

         end
     },
     { "folke/neodev.nvim", opts = {} },
     {
         "akinsho/bufferline.nvim",
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
     },
     -- cs"' (no i needed)
     -- ys(...)
     -- e.g. ysw"
     {
         "kylechui/nvim-surround",
         event = "VeryLazy",
         config = function()
             require("nvim-surround").setup {}
         end
     },
     { "tpope/vim-unimpaired" },
     {
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
     },
     -- Proof Assistant for interactive Coq development
     {
         "whonore/Coqtail",
         branch = 'main',
         init = function()
             vim.g.coqtail_nomap = 1
             vim.api.nvim_set_hl(0, "CoqtailChecked", { bg = "#353b45" })
             vim.api.nvim_set_hl(0, "CoqtailSent", { bg = "#333333" })
         end,
         config = function()
             vim.api.nvim_set_hl(0, "CoqtailChecked", { bg = "#353b45" })
             vim.api.nvim_set_hl(0, "CoqtailSent", { bg = "#333333" })
             map("n", "<Space>cl", "<Plug>CoqToLine", { desc = "Evaluate Coq to line" })
         end
     },
     -- Theme
     {
         'sam4llis/nvim-tundra',
         priority = 1000,
         config = function()
             require('nvim-tundra').setup {
                 transparent_background = true,
                 plugins = {
                     telescope = true,
                     lsp = true,
                     semantic_tokens = true,
                     treesitter = true,
                     nvimtree = true,
                     cmp = true,
                     context = true,
                     dbui = true,
                     gitsigns = true,
                     neogit = true,
                     textfsm = true
                 }
             }

             vim.opt.background = 'dark'
             vim.cmd('colorscheme tundra')
         end,
     },
     -- Indent guides
     { "lukas-reineke/indent-blankline.nvim" },
     { "folke/neoconf.nvim" },
     -- LaTeX
     {
         "lervag/vimtex",
         config = function()
             vim.g.tex_flavor = "latex"
             vim.g.vimtex_view_method = "zathura"
             vim.g.vimtex_quickfix_mode = 0
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
                 let g:vimtex_matchparen_enabled = 0
             ]]
         end
     },

     { "sindrets/diffview.nvim" },

     -- Uses the sign column line left of line numbers for git info
     {
         'lewis6991/gitsigns.nvim',
         config = function()
             -- Always show the column for consistent UI
             vim.g.signcolumn = "yes"

             require('gitsigns').setup {
                 on_attach = function(bufnr)
                     local gitsigns = require("gitsigns")

                     local function map(mode, l, r, opts)
                         opts = opts or {}
                         opts.buffer = bufnr
                         vim.keymap.set(mode, l, r, opts)
                     end

                     -- Navigation
                     map("n", "]h", function()
                         if vim.wo.diff then
                             vim.cmd.normal({ "]h", bang = true })
                         else
                             gitsigns.nav_hunk("next")
                         end
                     end)

                     map("n", "[h", function()
                         if vim.wo.diff then
                             vim.cmd.normal({ "[h", bang = true })
                         else
                             gitsigns.nav_hunk("prev")
                         end
                     end)

                     -- Actions
                     map('n', '<leader>ghs', gitsigns.stage_hunk, { desc =  "Stage hunk" })
                     map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = "Reset hunk" })
                     map('v', '<leader>ghs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage hunk" })
                     map('v', '<leader>ghr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Reset hunk" })
                     map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = "Stage buffer" })
                     map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = "Unstage hunk" })
                     map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = "Reset buffer" })
                     map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = "Preview hunk" })
                     map('n', '<leader>ghb', function() gitsigns.blame_line{full=true} end, { desc = "Blame link" })
                     map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
                     map('n', '<leader>ghd', gitsigns.diffthis, { desc = "Diff this" })
                     map('n', '<leader>ghD', function() gitsigns.diffthis('~') end, { desc = "diff this but with a tilde" })
                     map('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = "toggle deleted" })

                     -- Text object
                     map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                 end,
             }
         end
     },
     -- Easy alignment
     {
         "junegunn/vim-easy-align",
         init = function()
             for _, mode in ipairs({ "n", "x" }) do
                 vim.api.nvim_set_keymap(
                     mode,
                     "ga",
                     "<Plug>(EasyAlign)",
                     { noremap = false, silent = false }
                 )
             end
         end
     },
     -- Preview lines when you do :[line_number]
     {
         "nacro90/numb.nvim",
         event = "BufRead",
         config = function()
             require("numb").setup()
         end
     },
     -- Can pop up a list of diagnostics
     {
         "folke/trouble.nvim",
         dependencies = "kyazdani42/nvim-web-devicons",
         config = function()
             require("trouble").setup {}
         end
     },
     -- Show errors inline
     {
         "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
         config = function()
             -- don't need dupes 
             vim.diagnostic.config { virtual_text = false }
             vim.diagnostic.config { virtual_lines = { only_current_line = true } }

             require("lsp_lines").setup()

             vim.keymap.set(
                 "n",
                 "<Space>l",
                 require('lsp_lines').toggle,
                 { desc = "Toggle lsp_lines" }
             )
         end,

     },

     {
         "NvChad/nvim-colorizer.lua",
         opts = {user_default_options = {names = false, mode='background'}}
     },

     {
         "williamboman/mason.nvim",
         config = function()
             require("mason").setup()
         end,
     },
     -- TODO: Swap to this over ultisnips for perf
     -- { "L3MON4D3/LuaSnip" ,
     --     wants = "friendly-snippets",
     --     dependencies = "nvim-cmp",
     --     config = function()
     --         luasnips = require("luasnip")
     --         luasnips.config.setup { enable_autosnippets = true }
     --         require("luasnip/loaders/from_vscode")
     --             .load ({
     --                 paths = vim.fn.stdpath("config") .. "/luasnip_snippets"
     --             })
     --     end
     -- }
     -- { "rafamadriz/friendly-snippets",
     --     module = { "cmp", "cmp_nvim_lsp" },
     --     event = "InsertEnter",
     -- }
     {
         "SirVer/ultisnips",
         ft = { 'tex', 'markdown' },
         init = function()
             vim.g.UltiSnipsSnipeptsDir = vim.fn.stdpath("config") .. "/UltiSnips"
             -- just don't be tab, that lags shit
             vim.g.UltiSnipsExpandTrigger = '<f5>'
             vim.g.UltiSnipsJumpForwardTrigger = "<C-l>"
             vim.g.UltiSnipsJumpBackwardTrigger = "<C-Shift-Tab>"
         end
     },
     {
         'echasnovski/mini.nvim',
         config = function()
             -- require('mini.completion').setup()
         end
     },
     { "hrsh7th/cmp-nvim-lua" },
     {
         "hrsh7th/cmp-nvim-lsp",
         dependencies = "cmp-nvim-lua",
     },
     {
         "hrsh7th/cmp-buffer",
         dependencies = "cmp-nvim-lsp",
     },
     {
         "hrsh7th/cmp-path",
         dependencies = "cmp-buffer",
     },
     {
         ft = { 'tex' },
         "quangnguyen30192/cmp-nvim-ultisnips",
         dependencies = "SirVer/ultisnips"
     },
     {
         "windwp/nvim-autopairs",
         dependencies = "nvim-cmp",
     },
     {
         "numToStr/Comment.nvim",
         module = "Comment",
         keys = { "gc", "gb" },
         -- idk why this doesn't auto-load from lazy.nvim's call?
         config = function()
             require('Comment').setup()
         end,
     },
     -- file managing , picker etc
     {
         "kyazdani42/nvim-tree.lua",
         ft = "alpha",
         cmd = { "NvimTreeToggle", "NvimTreeFocus" },
     },
     {
         "mbbill/undotree",
         config = function()
             vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
             vim.g.undotree_SetFocusWhenToggle = 1
         end
     },
     {
         "nvim-telescope/telescope.nvim",
         cmd = "Telescope",
         version = false, -- telescope did only one release, so use HEAD for now
         dependencies = {
             {
                 "nvim-telescope/telescope-fzf-native.nvim",
                 build = "make",
                 enabled = vim.fn.executable("make") == 1,
                 config = function()
                     Util.on_load("telescope.nvim", function()
                         require("telescope").load_extension("fzf")
                     end)
                 end,
             },
             "nvim-lua/plenary.nvim" },
         keys = {
             {
                 "<leader>,",
                 "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
                 desc = "Switch Buffer",
             },
             { "<leader>:",  "<cmd>Telescope command_history<cr>",                          desc = "Command History" },
             -- find
             { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
             { "<leader>fc", Util.telescope.config_files(),                                 desc = "Find Config File" },
             { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                 desc = "Recent" },
             -- git
             { "<leader>gc", "<cmd>Telescope git_commits<CR>",                              desc = "commits" },
             { "<leader>gs", "<cmd>Telescope git_status<CR>",                               desc = "status" },
             -- search
             { '<leader>s"', "<cmd>Telescope registers<cr>",                                desc = "Registers" },
             { "<leader>sa", "<cmd>Telescope autocommands<cr>",                             desc = "Auto Commands" },
             { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",                desc = "Buffer" },
             { "<leader>sc", "<cmd>Telescope command_history<cr>",                          desc = "Command History" },
             { "<leader>sC", "<cmd>Telescope commands<cr>",                                 desc = "Commands" },
             { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>",                      desc = "Document diagnostics" },
             { "<leader>sD", "<cmd>Telescope diagnostics<cr>",                              desc = "Workspace diagnostics" },
             { "<leader>sh", "<cmd>Telescope help_tags<cr>",                                desc = "Help Pages" },
             { "<leader>sH", "<cmd>Telescope highlights<cr>",                               desc = "Search Highlight Groups" },
             { "<leader>sk", "<cmd>Telescope keymaps<cr>",                                  desc = "Key Maps" },
             { "<leader>sM", "<cmd>Telescope man_pages<cr>",                                desc = "Man Pages" },
             { "<leader>sm", "<cmd>Telescope marks<cr>",                                    desc = "Jump to Mark" },
             { "<leader>so", "<cmd>Telescope vim_options<cr>",                              desc = "Options" },
             { "<leader>sR", "<cmd>Telescope resume<cr>",                                   desc = "Resume" },
             -- { "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
             -- { "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
             -- { "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
             -- { "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
             -- { "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
             -- { "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
             -- { "<leader>/", Util.telescope("live_grep"), desc = "Grep (root dir)" },
             -- { "<leader>sw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
             -- { "<leader>sW", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
             -- { "<leader>sw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
             -- { "<leader>sW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
             -- { "<leader>uC", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
             -- {
             --   "<leader>ss",
             --   function()
             --     require("telescope.builtin").lsp_document_symbols({
             --       symbols = require("lazyvim.config").get_kind_filter(),
             --     })
             --   end,
             --   desc = "Goto Symbol",
             -- },
             -- {
             --   "<leader>sS",
             --   function()
             --     require("telescope.builtin").lsp_dynamic_workspace_symbols({
             --       symbols = require("lazyvim.config").get_kind_filter(),
             --     })
             --   end,
             --   desc = "Goto Symbol (Workspace)",
             -- },
         },
         opts = function()
             local actions = require("telescope.actions")

             local open_with_trouble = function(...)
                 return require("trouble.providers.telescope").open_with_trouble(...)
             end
             local open_selected_with_trouble = function(...)
                 return require("trouble.providers.telescope").open_selected_with_trouble(...)
             end
             local find_files_no_ignore = function()
                 local action_state = require("telescope.actions.state")
                 local line = action_state.get_current_line()
                 Util.telescope("find_files", { no_ignore = true, default_text = line })()
             end
             local find_files_with_hidden = function()
                 local action_state = require("telescope.actions.state")
                 local line = action_state.get_current_line()
                 Util.telescope("find_files", { hidden = true, default_text = line })()
             end

             return {
                 defaults = {
                     prompt_prefix = " ",
                     selection_caret = " ",
                     -- open files in the first window that is an actual file.
                     -- use the current window if no other window is available.
                     get_selection_window = function()
                         local wins = vim.api.nvim_list_wins()
                         table.insert(wins, 1, vim.api.nvim_get_current_win())
                         for _, win in ipairs(wins) do
                             local buf = vim.api.nvim_win_get_buf(win)
                             if vim.bo[buf].buftype == "" then
                                 return win
                             end
                         end
                         return 0
                     end,
                     mappings = {
                         i = {
                             ["<c-t>"] = open_with_trouble,
                             ["<a-t>"] = open_selected_with_trouble,
                             ["<a-i>"] = find_files_no_ignore,
                             ["<a-h>"] = find_files_with_hidden,
                             ["<C-Down>"] = actions.cycle_history_next,
                             ["<C-Up>"] = actions.cycle_history_prev,
                             ["<C-f>"] = actions.preview_scrolling_down,
                             ["<C-b>"] = actions.preview_scrolling_up,
                         },
                         n = {
                             ["q"] = actions.close,
                         },
                     },
                 },
             }
         end,
     },

     { 'nvim-telescope/telescope-ui-select.nvim' },

     {
         "aarondiel/spread.nvim",
         requires = { "nvim-treesitter/nvim-treesitter" },
         config = function()
             local spread = require("spread")
             local default_options = {
                 silent = true,
                 noremap = true
             }

             vim.keymap.set(
                 "n",
                 "<leader>ss",
                 spread.out,
                 {
                     desc = "Spread out",
                     table.unpack(default_options)
                 }
             )
             vim.keymap.set(
                 "n",
                 "<leader>ssc",
                 spread.combine,
                 { desc = "Spread: combine", table.unpack(default_options) }
             )
         end
     },

     -- TODO: file issue about using require in keys fn - causes error before installation.
     {
         "trmckay/based.nvim",
         keys = function()
             local based = require("based")

             return { { "<leader>B", based.convert, desc = "Convert base" } }
         end
     },

     {
         "smartpde/debuglog",
         config = function()
             local dlog = require("debuglog")
             dlog.setup {}
             dlog.enable("*")
         end
     },

     {
         "stevearc/oil.nvim",
        opts = {},
    },

    {
        'TheBlob42/houdini.nvim',
        opts = {
            -- Disable this in visual [block] mode as we can't quickly scroll up/down
            escape_sequences = {
                ['v'] = false,
                ['V'] = false,
                [''] = false
            }
        }
    },

     -- {
     --     'rmagatti/goto-preview',
     --     opts = { default_mappings = true }
     -- },

     {
         'stevearc/overseer.nvim',
         opts = {},
     },

     {
         'akinsho/git-conflict.nvim', 
         version = "*", 
         config = function()
             require('git-conflict').setup {}
         end
     },

     { 'tpope/vim-fugitive' },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
        }
    },

    {
        "folke/zen-mode.nvim",
        opts = { 
            window = {
                width = 85,
                height = .7,

                options = {
                    number = false,
                    signcolumn = "no",
                }
            },
        }
    },

    {
        "3rd/image.nvim",
        branch = "develop",
        build = false,
        opts = {
            processor = "magick_cli",
            integrations = {
                markdown = {
                    -- This makes it work with ZenMode
                    floating_windows = true,

                    download_remote_images = false,
                    only_render_image_at_cursor = true,

                    resolve_image_path = function(document_path, image_path, fallback)
                        local obs = require("obsidian").get_client()
                        local vault_root = obs:vault_root().filename

                        -- If we're in a vault, try using vault behavior
                        if document_path:find(vault_root, 1, 1) then
                            local obs_rel = obs:vault_relative_path(image_path)

                            if (
                                obs_rel
                                and vim.fn.filereadable(vault_root .. "/" .. obs_rel.filename) == 1
                            ) then
                                return vault_root .. "/" .. obs_rel.filename
                            end

                            local attachment_path = document_path:match("(.*/)") .. "attachments/" .. image_path

                            if vim.fn.filereadable(attachment_path) then
                                return attachment_path
                            end
                        end

                        if image_path:sub(1, 10) == "data:image" then
                            local utils = require("image/utils")

                            return utils.resolve_base64_image(image_path)
                        end

                        return fallback(document_path, image_path)
                    end,
                }
            }
        }
    },
    --

    { 'echasnovski/mini.clue', config = function()
        local miniclue = require('mini.clue')
        miniclue.setup({
            window = {
                delay = 0,
            },
            triggers = {
                { mode = 'n', keys = '<localleader>' },
                { mode = 'x', keys = '<localleader>' },

                -- Leader triggers
                { mode = 'n', keys = '<Leader>' },
                { mode = 'x', keys = '<Leader>' },

                -- Built-in completion
                { mode = 'i', keys = '<C-x>' },

                -- `g` key
                { mode = 'n', keys = 'g' },
                { mode = 'x', keys = 'g' },

                -- Marks
                { mode = 'n', keys = "'" },
                { mode = 'n', keys = '`' },
                { mode = 'x', keys = "'" },
                { mode = 'x', keys = '`' },

                -- Registers
                { mode = 'n', keys = '"' },
                { mode = 'x', keys = '"' },
                { mode = 'i', keys = '<C-r>' },
                { mode = 'c', keys = '<C-r>' },

                -- Window commands
                { mode = 'n', keys = '<C-w>' },

                -- `z` key
                { mode = 'n', keys = 'z' },
                { mode = 'x', keys = 'z' },
            },

            clues = {
                -- Enhance this by adding descriptions for <Leader> mapping groups
                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.z(),
            },
        })
    end },

    -- oops
    { "ntpeters/vim-better-whitespace" },

    { "jinh0/eyeliner.nvim" },

    --    {
    --        "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    --        dependencies = { { "nvim-treesitter" } },
    --        config = function()
    --        end
    --    },
    --  -- Speed up deferred plugins
    --  { "lewis6991/impatient.nvim" }
}
