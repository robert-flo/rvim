---@class rvim.utils.theme
local M = {}

local current_theme ---@type "light"|"osaka"|"onedark"|nil

--- Get current mode in active Neovim session
---@return string "light"|"dark"
function M.get_current_mode()
	return vim.o.background == "light" and "light" or "dark"
end

--- Update Snacks dashboard highlights according to active mode
---@param mode "light"|"dark"
local function update_dashboard_highlights(mode)
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
end

local function theme_state_path()
	return vim.fn.stdpath("state") .. "/rvim_theme"
end

local function load_persisted_theme()
	local ok, lines = pcall(vim.fn.readfile, theme_state_path())
	if ok and #lines > 0 then
		local t = vim.trim(lines[1])
		if t == "light" or t == "osaka" or t == "onedark" then
			return t
		end
	end
	return nil
end

local function persist_theme(theme)
	pcall(vim.fn.writefile, { theme }, theme_state_path())
end

--- Apply one of the three rvim themes
---@param theme "light"|"osaka"|"onedark"
---@param notify? boolean
function M.set_theme(theme, notify)
	if theme == "light" then
		vim.o.background = "light"
		require("rvim.theme.clavis_light").setup()

		-- Actualizar tema de Lualine a Clavis Light
		local lualine_ok, lualine = pcall(require, "lualine")
		if lualine_ok then
			local light_lualine = require("rvim.theme.lualine")
			pcall(lualine.setup, {
				options = {
					theme = light_lualine,
				},
			})
			pcall(lualine.refresh)
		end
	elseif theme == "onedark" then
		vim.o.background = "dark"
		local onedark_ok, onedark = pcall(require, "onedark")
		if onedark_ok then
			onedark.setup({ style = "dark", transparent = true })
		end
		vim.cmd([[colorscheme onedark]])

		-- Restaurar Lualine a tema auto / onedark
		local lualine_ok, lualine = pcall(require, "lualine")
		if lualine_ok then
			pcall(lualine.setup, {
				options = {
					theme = "auto",
				},
			})
			pcall(lualine.refresh)
		end
	else
		vim.o.background = "dark"
		local osaka_ok, osaka = pcall(require, "solarized-osaka")
		if osaka_ok then
			osaka.setup({
				style = "vivid",
				transparent = true,
			})
		end
		vim.cmd([[colorscheme solarized-osaka]])

		-- Restaurar Lualine a tema auto / solarized-osaka
		local lualine_ok, lualine = pcall(require, "lualine")
		if lualine_ok then
			pcall(lualine.setup, {
				options = {
					theme = "auto",
				},
			})
			pcall(lualine.refresh)
		end
	end

	current_theme = theme
	update_dashboard_highlights(theme == "light" and "light" or "dark")

	if notify then
		vim.notify("rvim theme: " .. theme:upper(), vim.log.levels.INFO, {
			title = "Theme Cycle",
			icon = theme == "light" and "☀️" or "🌙",
		})
	end
end

--- Cycle Clavis Light -> Solarized Osaka -> Onedark -> Clavis Light
function M.cycle()
	local order = { "light", "osaka", "onedark" }
	local target = "light"
	for i, name in ipairs(order) do
		if current_theme == name then
			target = order[(i % #order) + 1]
			break
		end
	end
	M.set_theme(target, true)
	persist_theme(target)
end

--- Initialize theme on startup: restore the last chosen theme, defaulting to Solarized Osaka dark
function M.init()
	M.set_theme(load_persisted_theme() or "osaka", false)
end

return M
