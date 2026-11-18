---elio integration helpers built on top of tfm.nvim (configured for the
---elio binary in lua/rvim/plugins/tfm.lua): contextual opens, a titled float,
---a clean bottom edge while elio is on screen, and last-directory memory.
local M = {}

local VAULTS_DIR = "/z/vaults"
local state_path = vim.fn.stdpath("state") .. "/rvim_elio_dir"

---Resolve the directory elio should open in: an explicit dir, else the current
---file's directory, else the working directory.
---@param dir string|nil
---@return string
local function resolve_dir(dir)
	if dir and dir ~= "" then
		return dir
	end
	local file_dir = vim.fn.expand("%:p:h")
	if file_dir ~= "" and vim.fn.isdirectory(file_dir) == 1 then
		return file_dir
	end
	return vim.fn.getcwd()
end

---Remember the last directory elio opened in, persisted across sessions.
---@param dir string
local function remember_dir(dir)
	local f = io.open(state_path, "w")
	if f then
		f:write(dir)
		f:close()
	end
end

---Read the remembered directory, ignoring stale or deleted paths.
---@return string|nil
local function last_dir()
	local f = io.open(state_path, "r")
	if not f then
		return nil
	end
	local dir = f:read("*l")
	f:close()
	if dir and dir ~= "" and vim.fn.isdirectory(dir) == 1 then
		return dir
	end
	return nil
end

---Polish the floating window: border title with the open directory and a
---clean bottom edge while elio is on screen.
---@param dir string
local function polish(dir)
	pcall(vim.api.nvim_win_set_config, 0, {
		title = " elio: " .. vim.fn.fnamemodify(dir, ":~") .. " ",
		title_pos = "center",
	})
	local previous = vim.o.laststatus
	vim.o.laststatus = 0
	vim.api.nvim_create_autocmd({ "TermClose", "BufWipeout" }, {
		buffer = vim.api.nvim_get_current_buf(),
		once = true,
		callback = function()
			if vim.o.laststatus == 0 then
				vim.o.laststatus = previous
			end
		end,
	})
end

---Open elio in `dir` (or the contextual directory) with tfm.nvim's `open_mode`
---(the mode files selected inside elio are opened with on exit).
---@param dir string|nil
---@param open_mode string|nil
function M.open(dir, open_mode)
	local ok, tfm = pcall(require, "tfm")
	if not ok then
		vim.notify("tfm.nvim not available", vim.log.levels.WARN)
		return
	end
	local target = resolve_dir(dir)
	remember_dir(target)
	tfm.open(target, open_mode)
	polish(target)
end

---Open elio at the Obsidian vaults root.
function M.vaults()
	M.open(VAULTS_DIR)
end

---Reopen elio in the last directory it opened in.
function M.last()
	M.open(last_dir())
end

return M
