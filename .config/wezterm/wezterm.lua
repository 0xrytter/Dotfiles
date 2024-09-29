local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.window_background_opacity = 0.95 -- Adjust this value as needed

config.color_scheme = "Catppuccin Mocha"

config.enable_tab_bar = false

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Font rules for different styles
config.font_rules = {
	{
		italic = true,
		font = wezterm.font("JetBrainsMono Nerd Font", { italic = true }),
	},
	{
		font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
		italic = false,
	},
	{
		font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold", italic = true }),
		italic = true,
	},
}

-- Font settings
config.font_size = 18 -- Set the font size
config.font = wezterm.font("JetBrainsMono Nerd Font") -- Set the normal font

-- Cursor settings
config.cursor_blink_rate = 500 -- Blink interval in milliseconds
config.cursor_thickness = 2 -- Thickness of the cursor

-- Environment variables
config.set_environment_variables = {
	TERM = "xterm-256color",
}

-- Mouse settings
config.hide_mouse_cursor_when_typing = true

-- Mouse bindings
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Middle" } },
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

-- Selection settings (not directly supported, so we can skip this)

-- Shell settings
config.default_prog = { "/usr/bin/tmux" }

-- Window settings
config.window_decorations = "NONE" -- Full decorations

return config
