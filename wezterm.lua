local wezterm = require 'wezterm'

wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "config.lua")

return {
    font = wezterm.font("FiraCode Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}),
    font_size = 12.0,

    enable_tab_bar = false,
    -- use_fancy_tab_bar = false,
    -- show_tabs_in_tab_bar = false,
    -- show_new_tab_button_in_tab_bar = false,

    window_padding = {
        left = 15,
        right = 15,
        top = 15,
        bottom = 15,
    },
    window_background_opacity = 0.7,
    -- text_background_opacity = 0.7,
    adjust_window_size_when_changing_font_size = false,

    colors = {
        foreground = "#D1D5DB",
        background = "#000000",
        cursor_bg = "#D1D5DB",
        cursor_fg = "#111827",
        cursor_border = "#D1D5DB",
        selection_fg = "#D1D5DB",
        selection_bg = "#374151",
        ansi = {
            "#6B7280", "#ff646a", "#c1df7f", "#f4bf75",
            "#8ecee8", "#d999cb", "#9afaf3", "#565656",
        },
        brights = {
            "#6B7280", "#f46d6d", "#e3ffa2", "#feca88",
            "#a1d6ff", "#f8b7ec", "#c7ffff", "#373737",
        },
        indexed = { [16] = "#957FB8" },
    },

    inactive_pane_hsb = {
        saturation = 0.6,
        brightness = 0.8,
    },

    color_scheme = "custom",
};
