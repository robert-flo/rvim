--- Theme-wide highlight refinements, ported from nvim2k (plugin/after/highlights.lua).
--- Dark themes (solarized-osaka, onedark) get the block exactly as the nvim2k author
--- designed and tested it: every background cleared to none, plus fixed search, cursor
--- and visual colors. Clavis Light is left untouched: without changing the terminal
--- (niri) background, clearing backgrounds in light mode would put light text over the
--- terminal's dark background, so the light theme keeps its own opaque values.
local M = {}

local transparent_groups = {
	"Normal",
	"NormalFloat",
	"FloatBorder",
	"Pmenu",
	"Terminal",
	"EndOfBuffer",
	"FoldColumn",
	"Folded",
	"SignColumn",
}

local dark_colors = {
	Search = { bg = "#8BCD5B", fg = "#202020" },
	CurSearch = { bg = "#EFBD5D", fg = "#000000" },
	IncSearch = { bg = "#F15664", fg = "#000000" },
	CursorLine = { bg = "#1A1A1F" },
	CursorColumn = { bg = "#1A1A1F" },
	Visual = { bg = "#103070" },
}

local dark_themes = { ["solarized-osaka"] = true, ["onedark"] = true }
local light_themes = { ["clavis-light"] = true }

--- Dark mode is decided by the active theme identity; for unknown themes
--- (colorscheme picker previews, ad-hoc :colorscheme) fall back to background.
--- Whether the active theme is dark, decided by theme identity; for unknown
--- themes (colorscheme picker previews, ad-hoc :colorscheme) fall back to
--- background. Public so other modules style against the theme, not the flag.
function M.is_dark()
	local name = vim.g.colors_name
	if dark_themes[name] then
		return true
	end
	if light_themes[name] then
		return false
	end
	return vim.o.background ~= "light"
end

--- Apply refinements for the active theme.
--- Dark: full nvim2k block, verbatim. Light: no-op (see file comment).
function M.apply()
	-- Keep background in step with the theme identity. Switching themes through
	-- the colorscheme picker never updates it, which leaves the whole session
	-- reading the previous theme's mode.
	if dark_themes[vim.g.colors_name] then
		vim.o.background = "dark"
	elseif light_themes[vim.g.colors_name] then
		vim.o.background = "light"
	end

	if not M.is_dark() then
		return
	end

	for _, group in ipairs(transparent_groups) do
		vim.api.nvim_set_hl(0, group, { bg = "none" })
	end
	for group, opts in pairs(dark_colors) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

--- Register the ColorScheme hook so refinements re-apply on every theme change
--- (startup, <leader>QT cycle, colorscheme picker previews).
function M.setup()
	local group = vim.api.nvim_create_augroup("RvimHighlights", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		pattern = "*",
		callback = function()
			M.apply()
		end,
	})
end

return M
