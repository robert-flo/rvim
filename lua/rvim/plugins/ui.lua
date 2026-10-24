local icons = Rvim.icons
local lualine_utils = require("rvim.utils.lualine")
local lazygit_utils = require("rvim.utils.lazygit")

require("solarized-osaka").setup({
	style = "vivid",
	transparent = true,
})
vim.cmd([[colorscheme solarized-osaka]])

require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

-- Custom tabline setup
require("rvim.utils.tabline").setup()
vim.o.showtabline = 1
vim.o.tabline = "%!v:lua.require('rvim.utils.tabline').render()"

local Snacks = require("snacks")

-- Pre-seed dashboard startup stats for native vim.pack.add
local elapsed_ms = math.floor((vim.uv.hrtime() - (_G._rvim_start_time or vim.uv.hrtime())) / 1e6 * 100 + 0.5) / 100
Snacks.dashboard.lazy_stats = {
	startuptime = math.max(elapsed_ms, 3.5),
	count = 24,
	loaded = 24,
}

Snacks.setup({
	dashboard = {
		enabled = true,
		preset = {
			keys = {
				{
					icon = icons.ui.Search,
					key = "f",
					desc = "Find File (;f)",
					action = ":lua Snacks.dashboard.pick('files')",
				},
				{ icon = icons.ui.NewFile, key = "n", desc = "New File", action = ":ene | startinsert" },
				{
					icon = icons.ui.List,
					key = "r",
					desc = "Live Grep (;r)",
					action = ":lua Snacks.dashboard.pick('live_grep')",
				},
				{
					icon = icons.documents.Files,
					key = "o",
					desc = "Recent Files (;o)",
					action = ":lua Snacks.dashboard.pick('oldfiles')",
				},
				{
					icon = icons.git.Branch,
					key = "g",
					desc = "Lazygit (;g)",
					action = ":lua require('rvim.utils.lazygit').open()",
				},
				{
					icon = icons.ui.Gear,
					key = "c",
					desc = "Config",
					action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
				},
				{ icon = icons.ui.SignOut, key = "q", desc = "Quit", action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{
				icon = icons.ui.Keyboard,
				title = "Keymaps",
				section = "keys",
				indent = 2,
				padding = 1,
			},
			{
				icon = icons.documents.File,
				title = "Recent Files",
				section = "recent_files",
				indent = 2,
				padding = 1,
			},
			{
				icon = icons.documents.OpenFolder,
				title = "Projects",
				section = "projects",
				indent = 2,
				padding = 1,
			},
			{ section = "startup" },
		},
	},
	indent = { enabled = true },
	scroll = { enabled = false },
	picker = {
		enabled = true,
		sources = {
			files = { hidden = true },
			grep = { hidden = true },
		},
		layouts = {
			default = {
				layout = {
					width = 0,
					height = 0.98,
					col = 0,
					row = 0,
				},
			},
			vertical = {
				layout = {
					width = 0,
					height = 0.98,
					col = 0,
					row = 0,
				},
			},
			telescope = {
				layout = {
					width = 0,
					height = 0.98,
					col = 0,
					row = 0,
				},
			},
		},
		win = {
			preview = {
				wo = {
					number = false,
					relativenumber = false,
					signcolumn = "no",
					wrap = true,
					conceallevel = 2,
					concealcursor = "nvc",
				},
			},
		},
	},
	styles = {
		terminal = {
			width = 0,
			height = 0.98,
			col = 0,
			row = 0,
		},
		lazygit = {
			width = 0,
			height = 0.98,
			col = 0,
			row = 0,
		},
	},
	notifier = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	lazygit = {
		enabled = true,
		configure = true, -- auto-sets nvim-remote preset & syncs theme
		win = {
			width = 0,
			height = 0.98,
			col = 0,
			row = 0,
		},
		config = {
			-- Open files selected in lazygit in the pane it was launched from,
			-- instead of the nvim-remote preset's new tab. See utils/lazygit.lua.
			os = {
				edit = lazygit_utils.edit_command(),
				editAtLine = lazygit_utils.edit_command({ at_line = true }),
			},
		},
		theme = {
			activeBorderColor = { fg = "WarningMsg", bold = true },
		},
	},
})

require("tiny-cmdline").setup({
	position = {
		y = "20%",
	},
})

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
		refresh = {
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
				-- Macro
				"RecordingEnter",
				"RecordingLeave",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },

		lualine_c = {
			lualine_utils.root_dir(),
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{
				lualine_utils.pretty_path({
					length = 0,
					relative = "cwd",
					modified_hl = "MatchParen",
					directory_hl = "",
					filename_hl = "Bold",
					modified_sign = "",
					readonly_icon = " 󰌾 ",
				}),
			},
		},
		lualine_x = {
			lualine_utils.macro_recording(),
			{
				"diagnostics",
				symbols = {
					error = icons.diagnostics.Error,
					warn = icons.diagnostics.Warn,
					info = icons.diagnostics.Info,
					hint = icons.diagnostics.Hint,
				},
			},
			{
				"diff",
				symbols = {
					added = icons.git.added,
					modified = icons.git.modified,
					removed = icons.git.removed,
				},
				source = function()
					local gitsigns = vim.b.gitsigns_status_dict
					if gitsigns then
						return {
							added = gitsigns.added,
							modified = gitsigns.changed,
							removed = gitsigns.removed,
						}
					end
				end,
			},
		},
		lualine_y = {
			{ "progress", separator = " ", padding = { left = 1, right = 1 } },
		},
		lualine_z = {
			{ "location", padding = { left = 1, right = 1 } },
		},
	},
})

require("incline").setup({
	window = {
		margin = { vertical = 0, horizontal = 1 },
		zindex = 10,
	},
	hide = {
		cursorline = "smart",
	},
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if vim.bo[props.buf].modified then
			filename = "[+] " .. filename
		end

		local icon, hl = MiniIcons.get("file", filename)
		return { { icon, group = hl }, { " " }, { filename } }
	end,
})

require("codediff").setup({
	explorer = {
		width = 50,
		auto_open_on_cursor = true,
		view_mode = "tree", -- "list" or "tree"
		line_stats = {
			enabled = true,
		},
	},
	diff = {
		compact = true,
		compact_context_lines = 8,
		compact_sync_folds = true, -- open/close folds in both panes together
	},
	keymaps = {
		view = {},
	},
})

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
		format = function(diagnostic)
			return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
		end,
	},
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
		},
	},
})
