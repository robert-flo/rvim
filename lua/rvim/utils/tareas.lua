-- Tasks: TAREA-NNN notes per repository, with status and pickers.
-- One subfolder per repository under a central root, one file per task.
-- The first line "Estado: <idea|plan|hecha|no>" is the status, cycled from the buffer.

local STATUS = { "idea", "plan", "hecha", "no" }
local OPEN = { idea = true, plan = true }
local CLOSED = { hecha = true, ["no"] = true }

local M = {}

--- Central root of the tasks, overridable with vim.g.rvim_tasks_dir
function M.root()
	return vim.g.rvim_tasks_dir or vim.fn.expand("~/z/vaults/rf-tareas")
end

--- Name of the repository of the current buffer (basename of the git root), "general" if outside a repo
function M.repo_name(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(bufnr)
	-- Desde un TAREA existente, el repo es su propia subcarpeta
	-- (permite crear varias tareas seguidas y crear desde el picker)
	if file ~= "" and file:find(M.root(), 1, true) == 1 then
		return vim.fs.basename(vim.fs.dirname(file))
	end
	local dir = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd() or "."
	local top = vim.fs.root(dir, ".git")
	return top and vim.fs.basename(top) or "general"
end

local function next_number(dir)
	local max = 0
	for name, _ in vim.fs.dir(dir) do
		local n = tonumber(name:match("^TAREA%-(%d+)%.md$"))
		if n and n > max then
			max = n
		end
	end
	return max + 1
end

--- Create a new TAREA in the subfolder of the current repository and open it
function M.new()
	local repo = M.repo_name()
	local dir = M.root() .. "/" .. repo
	vim.fn.mkdir(dir, "p")
	local n = next_number(dir)
	local path = ("%s/TAREA-%03d.md"):format(dir, n)
	vim.fn.writefile({
		"Estado: idea",
		"",
		("# TAREA %03d"):format(n),
		"",
	}, path)
	vim.cmd("edit " .. vim.fn.fnameescape(path))
	vim.api.nvim_win_set_cursor(0, { 4, 0 })
	vim.notify(("Tarea %03d creada en %s"):format(n, repo), vim.log.levels.INFO, { title = "Tareas" })
end

--- Status of a task file on disk (first line "Estado: <status>"); nil if it does not have one
function M.status(file)
	local f = io.open(file, "r")
	if not f then
		return nil
	end
	local first = f:read("*l")
	f:close()
	return first and first:match("^Estado:%s*(%S+)") or nil
end

--- Cycle the status of the current buffer's TAREA (idea -> plan -> done -> no) and write if it is under the root
function M.cycle()
	local buf = vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(buf)
	if file == "" then
		return vim.notify("There is no file open in this buffer", vim.log.levels.WARN, { title = "Tareas" })
	end
	local first = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
	local cur = first:match("^Estado:%s*(%S+)")
	local nxt = "idea"
	if cur then
		for i, s in ipairs(STATUS) do
			if s == cur then
				nxt = STATUS[i % #STATUS + 1]
			end
		end
		vim.api.nvim_buf_set_lines(buf, 0, 1, false, { "Estado: " .. nxt })
	else
		vim.api.nvim_buf_set_lines(buf, 0, 0, false, { "Estado: " .. nxt, "" })
	end
	if file:find(M.root(), 1, true) == 1 then
		vim.cmd("silent! write")
	end
	vim.notify(("Estado: %s"):format(nxt), vim.log.levels.INFO, { title = "Tareas" })
end

local function head_of(file)
	local f = io.open(file, "r")
	if not f then
		return nil
	end
	local status, title, heading
	for line in f:lines() do
		if not status then
			status = line:match("^Estado:%s*(%S+)")
		end
		if line:match("%S") then
			if line:match("^%s*#") then
				heading = heading or line:gsub("^%s*#+%s*", ""):gsub("%s+$", "")
			elseif line:match("^%s*Estado:") then
				-- la primera linea es el estado, no es titulo
			elseif not title then
				title = line:gsub("^%s+", ""):gsub("%s+$", "")
			end
		end
		if status and title then
			break
		end
	end
	f:close()
	return status or "idea", title or heading or "(no title)"
end

--- All tasks as picker items: { file, status, text = "repo · TAREA-NNN · status · title" }
function M.items()
	local r = M.root()
	local out = {}
	if vim.fn.isdirectory(r) == 0 then
		return out
	end
	for repo, kind in vim.fs.dir(r) do
		if kind == "directory" then
			local dir = r .. "/" .. repo
			for name, _ in vim.fs.dir(dir) do
				local num = name:match("^TAREA%-(%d+)%.md$")
				if num then
					local file = dir .. "/" .. name
					local status, title = head_of(file)
					out[#out + 1] = {
						file = file,
						status = status or "idea",
						text = ("%s · TAREA-%s · %s · %s"):format(repo, num, status or "idea", title or "(no title)"),
					}
				end
			end
		end
	end
	table.sort(out, function(a, b)
		return a.text < b.text
	end)
	return out
end

--- Filter items by view: "all" (everything), "open" (idea/plan), "closed" (done/no)
function M.filter(items, view)
	if view == "open" then
		return vim.tbl_filter(function(it)
			return OPEN[it.status] == true
		end, items)
	elseif view == "closed" then
		return vim.tbl_filter(function(it)
			return CLOSED[it.status] == true
		end, items)
	end
	return items
end

--- Open the tasks picker: "all", "open" or "closed"
function M.list(view)
	view = view or "all"
	local items = M.filter(M.items(), view)
	require("snacks").picker({
		title = ("Tareas (%s)"):format(view),
		items = items,
		format = function(item, _)
			return { { item.text } }
		end,
	})
end

return M
