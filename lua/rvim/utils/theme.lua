---@class rvim.utils.theme
local M = {}

--- Read active mode from Clavis system configuration
---@return string "light"|"dark"
function M.get_clavis_mode()
	local cfg_path = vim.fn.expand("~/.config/clavis/config.json")
	if vim.fn.filereadable(cfg_path) == 1 then
		local ok, content = pcall(vim.fn.readfile, cfg_path)
		if ok and #content > 0 then
			local json_str = table.concat(content, "\n")
			local parsed_ok, data = pcall(vim.fn.json_decode, json_str)
			if parsed_ok and data and data.theme and data.theme.mode then
				if data.theme.mode == "light" or data.theme.mode == "dark" then
					return data.theme.mode
				end
			end
		end
	end
	return "dark"
end

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

--- Apply theme (light or dark)
---@param mode "light"|"dark"
---@param notify? boolean
function M.set_theme(mode, notify)
	if mode == "light" then
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

	update_dashboard_highlights(mode)

	if notify then
		vim.notify("rvim theme: " .. mode:upper(), vim.log.levels.INFO, {
			title = "Theme Switcher",
			icon = mode == "light" and "☀️" or "🌙",
		})
	end
end

--- Toggle between light and dark theme
function M.toggle()
	local current = M.get_current_mode()
	local target = current == "light" and "dark" or "light"
	M.set_theme(target, true)
end

--- Initialize theme on startup based on Clavis preference
function M.init()
	local initial_mode = M.get_clavis_mode()
	M.set_theme(initial_mode, false)
end

return M
