-- Bookmarks: persistent, project-aware line bookmarks (heilgar/bookmarks.nvim)
-- Storage is SQLite; the pickers are Telescope-based, so a minimal dedicated
-- Telescope setup is loaded here (rvim's own pickers stay on Snacks).
local ok, bookmarks = pcall(require, "bookmarks")
if not ok then
	return
end

bookmarks.setup({
	-- rvim owns all bindings through the which-key m suite
	default_mappings = false,
	-- Persistent SQLite storage in the Neovim data directory
	db_path = vim.fn.stdpath("data") .. "/rvim_bookmarks.db",
})

local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
	telescope.setup({})
	pcall(telescope.load_extension, "bookmarks")
end
