local icons = Rvim.icons
local lualine_utils = require("rvim.utils.lualine")
local lazygit_utils = require("rvim.utils.lazygit")

local theme_utils = require("rvim.utils.theme")
theme_utils.init()

require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

-- Custom tabline setup
require("rvim.utils.tabline").setup()
vim.o.showtabline = 1
vim.o.tabline = "%!v:lua.require('rvim.utils.tabline').render()"

local Snacks = require("snacks")

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local mode = theme_utils.get_current_mode()
		if mode == "light" then
			local p = require("rvim.theme.palette").light
			vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = p.blue_deep, bold = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = p.violet, bold = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = p.amber, bold = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = p.blue, bold = false })
			vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = p.fg_dim })
			vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = p.green, italic = true, bold = true })
		else
			local colors = {
				blue = "#268bd2",
				cyan = "#2aa198",
				green = "#859900",
				yellow = "#b58900",
				orange = "#cb4b16",
				magenta = "#d33682",
				violet = "#6c71c4",
				base0 = "#839496",
				base1 = "#93a1a1",
			}
			vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = colors.cyan, bold = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = colors.violet, bold = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = colors.orange, bold = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = colors.blue, bold = false })
			vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = colors.base1 })
			vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = colors.green, italic = true, bold = true })
		end
	end,
})

-- Dashboard cursor hiding and clean empty lines (eob: " ")
local function setup_dashboard_cursor()
	local function cursor_blend(value)
		local hl = vim.api.nvim_get_hl(0, { name = "Cursor", create = true })
		hl.blend = value
		pcall(vim.api.nvim_set_hl, 0, "Cursor", hl)
		pcall(vim.cmd, "set guicursor+=a:Cursor/lCursor")
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "SnacksDashboardOpened",
		callback = function()
			cursor_blend(100)
			pcall(function()
				vim.opt_local.fillchars:append("eob: ")
			end)
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function()
			if vim.bo.filetype == "snacks_dashboard" then
				cursor_blend(100)
				pcall(function()
					vim.opt_local.fillchars:append("eob: ")
				end)
			end
		end,
	})

	vim.api.nvim_create_autocmd("BufLeave", {
		callback = function()
			if vim.bo.filetype == "snacks_dashboard" then
				cursor_blend(0)
			end
		end,
	})
end

local function calc_dashboard_width()
	local cols = vim.o.columns
	local gap = 4
	local target_total = math.floor(cols * 0.98)
	return math.max(60, math.floor((target_total - gap) / 2))
end

vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("rvim_dashboard_resize", { clear = true }),
	callback = function()
		if Snacks and Snacks.config and Snacks.config.dashboard then
			Snacks.config.dashboard.width = calc_dashboard_width()
		end
	end,
})

setup_dashboard_cursor()

local _weather_cache = nil
local function get_weather()
	if _weather_cache then
		return _weather_cache
	end
	local cache_file = vim.fn.stdpath("cache") .. "/rvim_weather.txt"
	local stat = vim.uv.fs_stat(cache_file)
	if stat and stat.type == "file" and stat.size > 0 and (os.time() - stat.mtime.sec < 3600) then
		local f = io.open(cache_file, "r")
		if f then
			local content = f:read("*a")
			f:close()
			if content and #content > 0 then
				_weather_cache = vim.trim(content):gsub(", .-:", ":")
				return _weather_cache
			end
		end
	end
	pcall(function()
		vim.fn.jobstart({ "sh", "-c", "curl -s --connect-timeout 2 'wttr.in/?0&format=3' > " .. cache_file }, { detach = true })
	end)
	return _weather_cache or ""
end

local function dashboard_greeting()
	local hour = tonumber(vim.fn.strftime("%H")) or 12
	local time_greeting = "Buenas noches"
	local time_icon = "󰖝 "
	if hour >= 6 and hour < 12 then
		time_greeting = "Buenos días"
		time_icon = "󰖙 "
	elseif hour >= 12 and hour < 19 then
		time_greeting = "Buenas tardes"
		time_icon = "󰖚 "
	end
	local user = os.getenv("USER") or os.getenv("USERNAME") or "developer"
	local date_str = vim.fn.strftime("%d/%m/%Y")
	local weather = get_weather()
	local weather_part = (weather and weather ~= "") and ("  •  󰖐 " .. weather) or ""
	return string.format("%s %s, %s  •  %s%s", time_icon, time_greeting, user, date_str, weather_part)
end

-- Pre-seed dashboard startup stats for native vim.pack.add
local elapsed_ms = math.floor((vim.uv.hrtime() - (_G._rvim_start_time or vim.uv.hrtime())) / 1e6 * 100 + 0.5) / 100
Snacks.dashboard.lazy_stats = {
	startuptime = math.max(elapsed_ms, 3.5),
	count = 32,
	loaded = 32,
}

local function make_key_item(icon, key, desc, action)
	return {
		key = key,
		action = action,
		desc = desc,
		icon = icon,
		text = {
			{ icon .. "  ", hl = "SnacksDashboardIcon" },
			{ desc, hl = "SnacksDashboardDesc", width = 34 },
			{ key, hl = "SnacksDashboardKey" },
		},
	}
end

local dashboard_pane_width = calc_dashboard_width()

-- Wrapper de Snacks.util.blend: evita nil-fg en DiffAdd con temas transparentes
local original_blend = Snacks.util.blend
Snacks.util.blend = function(fg, bg, alpha)
	local d = vim.o.background == "dark"
	local fix = function(c, def)
		return (type(c) == "string" and #c == 7 and c:sub(1, 1) == "#") and c or def
	end
	return original_blend(fix(fg, d and "#ffffff" or "#000000"), fix(bg, d and "#000000" or "#ffffff"), alpha)
end

-- SnacksPickerDimmed dinamico (mezcla Normal/Comment) para fondos transparentes
local function set_dimmed_hl()
	local fg = Snacks.util.blend(Snacks.util.color("Normal") or "#abb2bf", Snacks.util.color("Comment") or "#5c6370", 1)
	vim.api.nvim_set_hl(0, "SnacksPickerDimmed", { fg = fg })
end
set_dimmed_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = set_dimmed_hl,
})

-- Layouts por fuente para el picker
local function files_layout(preview_width, height, width)
	preview_width = preview_width or 0.6
	height = height or 0.8
	width = width or 0.9
	return {
		layout = {
			box = "horizontal",
			width = width,
			min_width = 120,
			height = height,
			{
				box = "vertical",
				border = "rounded",
				title = "{title} {live} {flags}",
				{ win = "input", height = 1, border = "bottom" },
				{ win = "list", border = "none" },
			},
			{ win = "preview", title = "{preview}", border = "rounded", width = preview_width },
		},
	}
end

local function palette_layout(height, width)
	height = height or 0.4
	width = width or 0.6
	return {
		preview = false,
		layout = {
			backdrop = false,
			row = 1,
			width = width,
			min_width = 80,
			height = height,
			border = "rounded",
			box = "vertical",
			{
				win = "input",
				height = 1,
				border = "rounded",
				title = "{title} {live} {flags}",
				title_pos = "center",
			},
			{ win = "list", border = "hpad" },
			{ win = "preview", title = "{preview}", border = "rounded" },
		},
	}
end

Snacks.setup({
	dashboard = {
		enabled = true,
		width = dashboard_pane_width,
		row = 2,
		pane_gap = 4,
		preset = {
			header = [[
██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
██╔══██╗ ██║   ██║ ██║ ████╗ ████║
██████╔╝ ██║   ██║ ██║ ██╔████╔██║
██╔══██╗ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
██║  ██║  ╚████╔╝  ██║ ██║ ╚═╝ ██║
╚═╝  ╚═╝   ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
			keys = {
				make_key_item(icons.ui.Search, "f", "Find File (;f)", ":lua Snacks.dashboard.pick('files')"),
				make_key_item(icons.ui.NewFile, "e", "New File", ":ene | startinsert"),
				make_key_item(icons.ui.List, "r", "Live Grep (;r)", ":lua Snacks.dashboard.pick('live_grep')"),
				make_key_item(icons.documents.Files, "o", "Recent Files (;o)", ":lua Snacks.dashboard.pick('oldfiles')"),
				make_key_item(icons.documents.OpenFolder, "t", "File Manager (elio / ;t)", ":lua require('tfm').open()"),
				make_key_item(icons.documents.File, "b", "Buffers (;b)", ":lua Snacks.dashboard.pick('buffers')"),
				make_key_item(icons.git.Branch, "g", "Lazygit (;g)", ":lua require('rvim.utils.lazygit').open()"),
				make_key_item(icons.git.Diff, "d", "Code Diff", ":CodeDiff"),
				make_key_item(icons.ui.Package, "m", "Mason Tools", ":Mason"),
				make_key_item(icons.ui.Gear, "c", "Config", ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })"),
				make_key_item(icons.ui.Fire, "z", "Force Quit (q!)", ":q!"),
				make_key_item(icons.ui.SignOut, "q", "Quit", ":qa"),
			},
		},
		sections = {
			{ section = "header" },
			{
				align = "center",
				padding = 1,
				text = {
					{ dashboard_greeting(), hl = "SnacksDashboardSpecial" },
				},
			},
			function(self)
				local pane_w = self.opts.width or 60
				local color_indent = math.max(0, math.floor((pane_w - 59) / 2))
				return {
					pane = 2,
					section = "terminal",
					cmd = "colorscript -e square | sed '/^$/d'",
					height = 3,
					indent = color_indent,
					padding = 1,
					ttl = 24 * 3600,
				}
			end,
			{
				pane = 2,
				title = "Notifications",
				key = "n",
				icon = " ",
				section = "terminal",
				cmd = vim.fn.stdpath("config") .. "/bin/rvim-dashboard-notify",
				height = 7,
				padding = 1,
				action = function()
					vim.ui.open("https://github.com/notifications")
				end,
				enabled = true,
			},
			{
				pane = 2,
				icon = " ",
				desc = "Browse Repo",
				padding = 1,
				key = "B",
				action = function()
					Snacks.gitbrowse()
				end,
				enabled = function()
					return Snacks.git.get_root() ~= nil
				end,
			},
			{
				pane = 2,
				title = "Open Issues",
				icon = " ",
				key = "i",
				section = "terminal",
				cmd = vim.fn.stdpath("config") .. "/bin/rvim-dashboard-issues",
				height = 8,
				padding = 1,
				indent = 2,
				ttl = 5 * 60,
				enabled = true,
				action = function()
					vim.fn.jobstart("gh issue list --web", { detach = true })
				end,
			},
			{
				pane = 2,
				icon = " ",
				title = "Open PRs",
				key = "P",
				section = "terminal",
				cmd = vim.fn.stdpath("config") .. "/bin/rvim-dashboard-prs",
				height = 8,
				padding = 1,
				indent = 2,
				ttl = 5 * 60,
				enabled = true,
				action = function()
					vim.fn.jobstart("gh pr list --web", { detach = true })
				end,
			},
			{
				pane = 2,
				icon = " ",
				title = "Git Status & Workspace",
				section = "terminal",
				cmd = vim.fn.stdpath("config") .. "/bin/rvim-dashboard-status",
				height = 6,
				padding = 1,
				indent = 2,
				ttl = 60,
				enabled = true,
			},
			{
				pane = 2,
				icon = icons.documents.File,
				title = "Recent Files",
				section = "recent_files",
				limit = 8,
				indent = 2,
				padding = 1,
				enabled = true,
			},
			{
				pane = 2,
				icon = icons.documents.OpenFolder,
				title = "Projects",
				section = "projects",
				limit = 6,
				indent = 2,
				padding = 1,
				enabled = true,
			},
			function(self)
				local pane_w = self.opts.width or 60
				local key_indent = math.max(2, math.floor((pane_w - 40) / 2))
				return vim.tbl_map(function(item)
					local it = vim.deepcopy(item)
					it.indent = key_indent
					return it
				end, self.opts.preset.keys)
			end,
			{ section = "startup" },
		},
	},
	indent = {
		enabled = true,
		priority = 1,
		char = icons.ui.SeparatorLight,
		only_scope = false,
		only_current = false,
		hl = {
			"SnacksIndent1",
			"SnacksIndent2",
			"SnacksIndent3",
			"SnacksIndent4",
			"SnacksIndent5",
			"SnacksIndent6",
			"SnacksIndent7",
			"SnacksIndent8",
		},
	},
	dim = {
		enabled = true,
		scope = {
			min_size = 5,
			max_size = 20,
			siblings = true,
		},
	},
	input = {
		enabled = true,
		icon = icons.ui.Edit,
		icon_hl = "SnacksInputIcon",
		icon_pos = "left",
		prompt_pos = "title",
		win = { style = "input" },
		expand = true,
	},
	scope = {
		enabled = true,
		keys = {
			textobject = {
				ii = {
					min_size = 2, -- tamano minimo del scope
					edge = false, -- scope interior
					cursor = false,
					treesitter = { blocks = { enabled = false } },
					desc = "inner scope",
				},
				ai = {
					cursor = false,
					min_size = 2,
					treesitter = { blocks = { enabled = false } },
					desc = "full scope",
				},
			},
			jump = {
				["[a"] = {
					min_size = 1, -- permite scopes de una linea
					bottom = false,
					cursor = false,
					edge = true,
					treesitter = { blocks = { enabled = false } },
					desc = "jump to top edge of scope",
				},
				["]a"] = {
					min_size = 1,
					bottom = true,
					cursor = false,
					edge = true,
					treesitter = { blocks = { enabled = false } },
					desc = "jump to bottom edge of scope",
				},
			},
		},
	},
	scratch = {
		enabled = true,
		name = "Scratch",
		ft = "markdown",
		root = vim.fn.stdpath("data") .. "/scratch",
		autowrite = true,
		filekey = {
			cwd = true,
			branch = true,
			count = true,
		},
		win = {
			width = 120,
			height = 40,
			bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
			minimal = false,
			noautocmd = false,
			zindex = 20,
			wo = { winhighlight = "NormalFloat:Normal" },
			border = "rounded",
			title_pos = "center",
			footer_pos = "center",
			keys = {
				["execute"] = {
					"<cr>",
					function(self)
						local ft = vim.bo[self.buf].filetype
						if ft == "lua" then
							return Snacks.debug.run({ buf = self.buf })
						end
						local runners = { python = "python3", javascript = "node", sh = "bash", bash = "bash" }
						local runner = runners[ft]
						if not runner then
							Snacks.notify.warn("Sin runner para filetype " .. ft)
							return
						end
						vim.cmd("silent! write")
						Snacks.terminal({ runner, vim.api.nvim_buf_get_name(self.buf) }, {
							win = { position = "bottom" },
							interactive = false,
						})
					end,
					desc = "Execute buffer",
					mode = { "n", "x" },
				},
			},
		},
		win_by_ft = {
			lua = {
				keys = {
					["source"] = {
						"<leader>cr",
						function(self)
							local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
							Snacks.debug.run({ buf = self.buf, name = name })
						end,
						desc = "Source buffer",
						mode = { "n", "x" },
					},
				},
			},
		},
	},
	terminal = {
		enabled = true,
		win = {
			border = "rounded",
		},
	},
	zen = {
		enabled = true,
		toggles = {
			dim = true,
			git_signs = false,
			mini_diff_signs = false,
		},
		show = {
			statusline = false,
			tabline = false,
		},
		win = { style = "zen" },
		zoom = {
			toggles = {},
			show = { statusline = true, tabline = true },
			win = {
				backdrop = false,
				width = 0,
			},
		},
	},
	scroll = { enabled = false },
	picker = {
		enabled = true,
		icon = icons.ui.Search,
		icon_hl = "SnacksPickerIcon",
		icon_pos = "left",
		prompt_pos = "title",
		expand = true,
		sources = {
			files = { hidden = true, layout = files_layout() },
			grep = { hidden = true },
			buffers = { layout = files_layout() },
			commands = { layout = palette_layout() },
			command_history = { layout = palette_layout() },
			git_files = { layout = files_layout() },
			git_branches = { layout = { preset = "vertical" } },
			git_status = { layout = files_layout() },
			help = { layout = { preset = "ivy_split" } },
			man = { layout = { preset = "ivy_split" } },
			icons = {
				icon_sources = { "nerd_fonts", "emoji" },
				layout = palette_layout(),
			},
			notifications = { layout = palette_layout() },
			projects = { layout = files_layout(0.8) },
			recent = { layout = files_layout() },
			search_history = { layout = palette_layout() },
			smart = { layout = files_layout() },
			undo = { layout = { preset = "ivy" } },
			zoxide = { layout = files_layout(0.7) },
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
			input = {
				keys = {
					["<Esc>"] = { "close", mode = { "n", "i" } },
					["<C-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
					["<C-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
				},
			},
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
			width = 0.9,
			height = 0.9,
			border = "rounded",
		},
	},
	notifier = {
		enabled = true,
		timeout = 2000,
		width = { min = 40, max = 0.4 },
		height = { min = 1, max = 0.6 },
		margin = { top = 0, right = 1, bottom = 0 },
		padding = true,
		sort = { "level", "added" },
		level = vim.log.levels.TRACE,
		icons = {
			debug = icons.ui.Bug,
			error = icons.diagnostics.Error,
			info = icons.diagnostics.Information,
			trace = icons.ui.Bookmark,
			warn = icons.diagnostics.Warning,
		},
		style = "compact",
		top_down = true,
		date_format = "%R",
		more_format = " ↓ %d lines ",
		refresh = 50,
	},
	statuscolumn = { enabled = true },
	words = { enabled = true },
	lazygit = {
		enabled = true,
		configure = true, -- auto-sets nvim-remote preset & syncs theme
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

-- Colores por modo para el statusline
local mode_colors = {
	n = "#51afef", -- azul
	i = "#98be65", -- verde
	v = "#c678dd", -- magenta
	V = "#c678dd",
	["\22"] = "#c678dd", -- visual block
	c = "#ECBE7B", -- amarillo
	R = "#FF8800", -- reemplazo
	Rv = "#FF8800",
	t = "#ec5f67", -- terminal
	no = "#bbc2cf",
	s = "#a9a1e1", -- select
	S = "#a9a1e1",
	["\19"] = "#a9a1e1", -- select block
	ic = "#ECBE7B",
	cv = "#ec5f67",
	ce = "#ec5f67",
	r = "#008080",
	rm = "#008080",
	["r?"] = "#008080",
	["!"] = "#ec5f67",
}

local function mode_color()
	local c = mode_colors[vim.fn.mode()]
	if not c then
		return nil
	end
	return { fg = c }
end

-- Clientes LSP activos (maximo 3, excluye typos_lsp)
local function lsp_clients()
	local max_lsps = 3
	local excluded_lsps = { "typos_lsp" }

	local names = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if not vim.list_contains(excluded_lsps, client.name) then
			table.insert(names, client.name)
			if #names >= max_lsps then
				break
			end
		end
	end

	if #names == 0 then
		return "No LSP"
	end
	return table.concat(names, ", ")
end

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
		lualine_a = {
			{ "mode", color = mode_color },
		},
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
				lsp_clients,
				icon = icons.ui.Gear,
				color = { gui = "bold" },
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
			{ "searchcount", color = { gui = "bold" } },
			{ "selectioncount", color = { gui = "bold" } },
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
		winhighlight = {
			active = { Normal = "InclineNormal" },
			inactive = { Normal = "InclineNormalNC" },
		},
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
