-- Bookmarks: persistent, project-aware line bookmarks (heilgar/bookmarks.nvim)
-- Storage is SQLite. The pickers are Telescope-based, so Telescope is loaded
-- lazily on first use (rvim's own pickers stay on Snacks).
local M = {}

---Load Telescope with the bookmarks extension on first picker use.
function M.load()
	if M._telescope_ready then
		return
	end
	M._telescope_ready = true
	local ok_telescope, telescope = pcall(require, "telescope")
	if ok_telescope then
		telescope.setup({})
		pcall(telescope.load_extension, "bookmarks")
	end
end

local ok, bookmarks = pcall(require, "bookmarks")
if ok then
	bookmarks.setup({
		-- rvim owns all bindings through the which-key m suite
		default_mappings = false,
		-- Persistent SQLite storage in the Neovim data directory
		db_path = vim.fn.stdpath("data") .. "/rvim_bookmarks.db",
	})
end

return M
