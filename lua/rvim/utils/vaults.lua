---@class rvim.utils.vaults
local M = {}

local Snacks = require("snacks")

M.cfg = {
	root = "/z/vaults",
	daybook = "PJ-NIRI-fo-daybook-vault",
	daily_dir = "",
	daily_format = "%Y-%m-%d",
}

--- Override default vault configuration
---@param opts table partial config (root, daybook, daily_dir, daily_format)
M.setup = function(opts)
	M.cfg = vim.tbl_deep_extend("force", M.cfg, opts or {})
end

-- rg globs that keep Obsidian internals out of the pickers
local exclude_globs = { "!.obsidian/**", "!.trash/**", "!.smart-env/**", "!.space/**" }

--- List vault directory names under the configured root
---@return string[]
M.list = function()
	local dirs = {}
	for _, name in ipairs(vim.fn.readdir(M.cfg.root)) do
		if vim.fn.isdirectory(M.cfg.root .. "/" .. name) == 1 and not name:match("^%.") then
			dirs[#dirs + 1] = name
		end
	end
	table.sort(dirs)
	return dirs
end

local function vault_path(name)
	return M.cfg.root .. "/" .. name
end

local function picker_opts(extra)
	return vim.tbl_deep_extend("force", { glob = exclude_globs }, extra or {})
end

--- Open or create a daybook note for a date string
---@param date string
M.open_daybook = function(date)
	local parts = { M.cfg.root, M.cfg.daybook }
	if M.cfg.daily_dir ~= "" then
		parts[#parts + 1] = M.cfg.daily_dir
	end
	parts[#parts + 1] = date .. ".md"
	local path = table.concat(parts, "/")
	vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
	if vim.fn.filereadable(path) == 0 then
		vim.fn.writefile({ "# " .. date, "" }, path)
	end
	vim.cmd("edit " .. vim.fn.fnameescape(path))
end

--- Shift today by `n` units of `kind` in `sign` direction
---@param kind "days"|"weeks"|"months"|"years"
---@param n integer
---@param sign integer 1 for later, -1 for ago
---@return string date formatted with `daily_format`
M.shifted_date = function(kind, n, sign)
	local t = os.date("*t")
	local delta = n * (sign or 1)
	if kind == "days" then
		t = os.date("*t", os.time(t) + delta * 86400)
	elseif kind == "weeks" then
		t = os.date("*t", os.time(t) + delta * 7 * 86400)
	else
		t.month = t.month + delta * (kind == "months" and 1 or 12)
		t = os.date("*t", os.time(t))
	end
	return os.date(M.cfg.daily_format, os.time(t))
end

--- Open or create the daybook note at a date offset
---@param kind "days"|"weeks"|"months"|"years"
---@param n integer
---@param sign integer
M.daybook_offset = function(kind, n, sign)
	M.open_daybook(M.shifted_date(kind, n, sign))
end

--- Open or create today's daybook note
M.today = function()
	M.open_daybook(os.date(M.cfg.daily_format))
end

--- Pick a vault, then browse its files
M.open_vault = function()
	vim.ui.select(M.list(), { prompt = "Select Vault:" }, function(choice)
		if choice then
			Snacks.picker.files(picker_opts({ cwd = vault_path(choice) }))
		end
	end)
end

--- Browse files across every vault
M.files_all = function()
	Snacks.picker.files(picker_opts({ cwd = M.cfg.root }))
end

--- Live grep across every vault
M.grep_all = function()
	Snacks.picker.grep(picker_opts({ cwd = M.cfg.root }))
end

--- Pick incomplete markdown todos (`- [ ]`) across every vault
M.todos = function()
	Snacks.picker.grep(picker_opts({ cwd = M.cfg.root, pattern = "- \\[ \\]" }))
end

--- Create a note: pick a vault, then type its path
M.create_note = function()
	vim.ui.select(M.list(), { prompt = "Select Vault:" }, function(choice)
		if not choice then
			return
		end
		vim.ui.input({ prompt = "Note Path: ", completion = "file" }, function(input)
			if not input or input == "" then
				return
			end
			local path = vault_path(choice) .. "/" .. input
			if path:sub(-3) ~= ".md" then
				path = path .. ".md"
			end
			vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
			if vim.fn.filereadable(path) == 0 then
				vim.fn.writefile({ "# " .. vim.fn.fnamemodify(path, ":t:r"), "" }, path)
			end
			vim.cmd("edit " .. vim.fn.fnameescape(path))
		end)
	end)
end

--- Toggle the markdown todo on the current line
M.toggle_todo = function()
	local line = vim.api.nvim_get_current_line()
	local new = nil
	if line:find("%- %[ %]") then
		new = line:gsub("%- %[ %]", "- [x]", 1)
	elseif line:find("%- %[x%]") then
		new = line:gsub("%- %[x%]", "- [ ]", 1)
	end
	if not new then
		vim.notify("No todo on the current line", vim.log.levels.WARN, { title = "Vaults" })
		return
	end
	vim.api.nvim_set_current_line(new)
end

--- Jump to the next or previous incomplete markdown todo
---@param direction integer 1 for next, -1 for previous
M.jump_todo = function(direction)
	local flags = direction == 1 and "W" or "Wb"
	if vim.fn.search("\\- \\[ \\]", flags) == 0 then
		vim.notify("No more incomplete todos", vim.log.levels.INFO, { title = "Vaults" })
	end
end

--- Mark every incomplete markdown todo in the current buffer as done
M.mark_all_todos = function()
	local view = vim.fn.winsaveview()
	vim.cmd("silent! keepjumps keeppatterns %s/- \\[ \\]/- [x]/e")
	vim.fn.winrestview(view)
	vim.notify("All todos marked as done", vim.log.levels.INFO, { title = "Vaults" })
end

--- Commit the current note into its vault's git repository
M.commit_note = function()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		return
	end
	local vault, vault_len = nil, 0
	for _, name in ipairs(M.list()) do
		local base = vault_path(name) .. "/"
		if file:find(base, 1, true) == 1 and #base > vault_len then
			vault, vault_len = vault_path(name), #base
		end
	end
	if not vault then
		vim.notify("Current buffer is not inside any vault", vim.log.levels.WARN, { title = "Vaults" })
		return
	end
	if vim.fn.isdirectory(vault .. "/.git") == 0 then
		vim.notify("Vault is not a git repository: " .. vault, vim.log.levels.WARN, { title = "Vaults" })
		return
	end
	local rel = file:sub(#vault + 2)
	vim.fn.system({ "git", "-C", vault, "add", "--", rel })
	vim.fn.system({ "git", "-C", vault, "commit", "-m", "note: " .. vim.fn.fnamemodify(file, ":t") })
	if vim.v.shell_error ~= 0 then
		vim.notify("git commit failed", vim.log.levels.ERROR, { title = "Vaults" })
	else
		vim.notify("Committed: " .. rel, vim.log.levels.INFO, { title = "Vaults" })
	end
end

--- which-key spec entries for the daybook date offsets (8 families x 1-9)
---@return table[]
M.offset_specs = function()
	local specs = {}
	local fams = {
		{ key = "d", kind = "days", sign = 1, label = "Days Later" },
		{ key = "D", kind = "days", sign = -1, label = "Days Ago" },
		{ key = "w", kind = "weeks", sign = 1, label = "Weeks Later" },
		{ key = "W", kind = "weeks", sign = -1, label = "Weeks Ago" },
		{ key = "m", kind = "months", sign = 1, label = "Months Later" },
		{ key = "M", kind = "months", sign = -1, label = "Months Ago" },
		{ key = "y", kind = "years", sign = 1, label = "Years Later" },
		{ key = "Y", kind = "years", sign = -1, label = "Years Ago" },
	}
	for _, fam in ipairs(fams) do
		for i = 1, 9 do
			specs[#specs + 1] = {
				string.format("<leader>v%s%d", fam.key, i),
				function()
					require("rvim.utils.vaults").daybook_offset(fam.kind, i, fam.sign)
				end,
				desc = string.format("Daybook %d %s", i, fam.label),
			}
		end
	end
	return specs
end

return M
