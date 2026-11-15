local p = require("rvim.theme.palette").light

local theme = {
	normal = {
		a = { bg = p.blue, fg = p.bg, gui = "bold" },
		b = { bg = p.bg_alt, fg = p.fg, gui = "bold" },
		c = { bg = p.bg_alt, fg = p.fg },
	},
	insert = {
		a = { bg = p.green, fg = p.bg, gui = "bold" },
		b = { bg = p.bg_alt, fg = p.fg, gui = "bold" },
		c = { bg = p.bg_alt, fg = p.fg },
	},
	visual = {
		a = { bg = p.violet, fg = p.bg, gui = "bold" },
		b = { bg = p.bg_alt, fg = p.fg, gui = "bold" },
		c = { bg = p.bg_alt, fg = p.fg },
	},
	replace = {
		a = { bg = p.red, fg = p.bg, gui = "bold" },
		b = { bg = p.bg_alt, fg = p.fg, gui = "bold" },
		c = { bg = p.bg_alt, fg = p.fg },
	},
	command = {
		a = { bg = p.amber, fg = p.bg, gui = "bold" },
		b = { bg = p.bg_alt, fg = p.fg, gui = "bold" },
		c = { bg = p.bg_alt, fg = p.fg },
	},
	inactive = {
		a = { bg = p.bg_alt, fg = p.fg_muted },
		b = { bg = p.bg_alt, fg = p.fg_muted },
		c = { bg = p.bg_alt, fg = p.fg_muted },
	},
}

return theme
