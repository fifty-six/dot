return {
	{
		"saghen/blink.cmp",
		-- todo: cmp-latex-symbols
		dependencies = { "rafamadriz/friendly-snippets" },

		version = "1.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			keymap = {
				preset = "enter",

				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				menu = {
					border = "rounded",
				},
				-- TODO: can we not show this on initial typing, only on tab?
				documentation = {
					window = {
						border = "rounded",
					},
					auto_show = true,
					auto_show_delay_ms = 0,
				},
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					-- When the LSP is being really slow, having buffer
					-- completions while we wait is really nice.
					lsp = {
						timeout_ms = 200,
						fallback = {},
						score_offset = 100,
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},

		opts_extend = { "sources.default" },
	},
}
