return {
    { "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-omni", "hrsh7th/cmp-nvim-lsp", "kdheepak/cmp-latex-symbols" },
        init = function()
            vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
        end,

        config = function()
            local function border(hl_name)
                return {
                    { "╭", hl_name },
                    { "─", hl_name },
                    { "╮", hl_name },
                    { "│", hl_name },
                    { "╯", hl_name },
                    { "─", hl_name },
                    { "╰", hl_name },
                    { "│", hl_name },
                }
            end

            local cmp = require("cmp")
            -- local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

            -- require("cmp_nvim_ultisnips").setup{}

            default_sources = {
                { name = "nvim_lsp" },
                { name = 'mkdnflow' },
                { name = "ultisnips" },
                { name = "buffer" },
                { name = "nvim_lua" },
                { name = "path" },
                { name = "omni" },
                { name = "otter" },
            }

            cmp.setup {
                window = {
                    completion = {
                        border = border "CmpBorder",
                        winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
                    },
                    documentation = cmp.config.window.bordered()
                },
                -- I think this was exploding something
                -- snippet = {
                --     expand = function(args)
                --         -- require("luasnip").lsp_expand(args.body)
                --         vim.fn["UltiSnips#Anon"](args.body)
                --     end,
                -- },
                mapping = {
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),

                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    ["<C-Space>"] = cmp.mapping.complete(),

                    ["<C-e>"] = cmp.mapping.close(),

                    ["<CR>"] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },

                    ["<Tab>"] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                                -- elseif require("luasnip").expand_or_jumpable() then
                                --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
                            else
                                fallback()
                            end
                        end, { "i", "s", }
                    ),
                    ["<S-Tab>"] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                                -- elseif require("luasnip").jumpable(-1) then
                                --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                            else
                                fallback()
                            end
                        end, { "i", "s", }
                    ),
            },
            sources = { table.unpack(default_sources) }
        }

            cmp.setup.filetype({ "coq", "rust" }, {
                sources = {
                    { name = "latex_symbols", option = { strategy = 0 } },
                    table.unpack(default_sources)
                }
            })
    end
} }
