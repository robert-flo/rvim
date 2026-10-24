---@class utils.editor
local M = {}

-- Root detection markers
local root_patterns = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

--- Get the current working directory
---@return string
local function get_cwd()
	return vim.uv.cwd() or vim.fn.getcwd()
end

--- Normalize a path (resolve symlinks, ensure consistent format)
---@param path string
---@return string
local function normalize(path)
	if path:sub(1, 1) == "~" then
		path = vim.fn.expand(path)
	end
	path = vim.uv.fs_realpath(path) or path
	return path:gsub("/$", "")
end

--- Find the project root directory
---@return string
local function get_root()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		path = get_cwd()
	end
	path = vim.fs.dirname(path)

	local root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
	if root then
		return normalize(vim.fs.dirname(root))
	end

	return normalize(get_cwd())
end

--- Check if a file exists
---@param filepath string
---@return boolean
local function file_exists(filepath)
	local stat = vim.uv.fs_stat(filepath)
	return stat ~= nil and stat.type == "file"
end

--- Open package.json in a floating window with 80% width and height
function M.open_package_json()
	local root = get_root()
	local package_json = root .. "/package.json"

	if not file_exists(package_json) then
		vim.notify("package.json not found in project root: " .. root, vim.log.levels.WARN)
		return
	end

	-- Calculate 90% dimensions
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)

	-- Center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create buffer and load file
	local buf = vim.fn.bufadd(package_json)
	vim.fn.bufload(buf)

	-- Create floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
		title = " package.json ",
		title_pos = "center",
	})

	-- Set window options
	vim.wo[win].winblend = 0
	vim.wo[win].cursorline = true

	-- Close on q or <Esc>
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, silent = true })
	vim.keymap.set("n", "<Esc>", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, silent = true })
end

--- Copy selected lines as a Markdown codeblock with filename and line number
function M.copy_as_codeblock()
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" then
		vim.notify("Buffer has no file name", vim.log.levels.WARN)
		return
	end

	local root = get_root()
	local relative = filepath:sub(#root + 2)
	local ft_to_lang = {
		typescriptreact = "tsx",
		javascriptreact = "jsx",
		typescript = "ts",
		javascript = "js",
	}
	local lang = ft_to_lang[vim.bo.filetype] or vim.bo.filetype

	local result = {}
	table.insert(result, "```" .. lang .. ' filename="' .. relative .. '" line=' .. start_line)
	for _, line in ipairs(lines) do
		table.insert(result, line)
	end
	table.insert(result, "```")

	local text = table.concat(result, "\n")
	vim.fn.setreg("+", text)
	vim.notify("Copied " .. #lines .. " lines as codeblock", vim.log.levels.INFO)
end

--- Delete all listed buffers that are not shown in any window
function M.delete_hidden_buffers()
	local visible_bufs = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		visible_bufs[vim.api.nvim_win_get_buf(win)] = true
	end

	local deleted = 0
	local skipped = 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted and not visible_bufs[buf] then
			if vim.bo[buf].modified then
				skipped = skipped + 1
			else
				vim.api.nvim_buf_delete(buf, {})
				deleted = deleted + 1
			end
		end
	end

	local msg = "Deleted " .. deleted .. " hidden buffer" .. (deleted == 1 and "" or "s")
	if skipped > 0 then
		msg = msg .. " (" .. skipped .. " skipped, unsaved changes)"
	end
	vim.notify(msg, vim.log.levels.INFO)
end

--- Enable or disable the current buffer's formatter
function M.toggle_formatter()
	local bufnr = vim.api.nvim_get_current_buf()
	local disabled = vim.b[bufnr].disable_autoformat

	if disabled then
		vim.b[bufnr].disable_autoformat = false
		vim.notify("Formatter enabled for this buffer", vim.log.levels.INFO)
	else
		vim.b[bufnr].disable_autoformat = true
		vim.notify("Formatter disabled for this buffer", vim.log.levels.WARN)
	end
end

--- Copy content to the system clipboard ('+' register) with notification
---@param content string
local function copy_to_clipboard(content)
	vim.fn.setreg("+", content)
	vim.notify('Copied "' .. content .. '" to the clipboard!', vim.log.levels.INFO)
end
M.copy_to_clipboard = copy_to_clipboard

--- Copy relative path of current buffer to clipboard
function M.copy_relative_path()
	local path = vim.fn.expand("%")
	if path == "" then
		vim.notify("No file name for current buffer", vim.log.levels.WARN)
		return
	end
	copy_to_clipboard(path)
end

--- Copy absolute path of current buffer to clipboard
function M.copy_absolute_path()
	local path = vim.fn.expand("%:p")
	if path == "" then
		vim.notify("No file name for current buffer", vim.log.levels.WARN)
		return
	end
	copy_to_clipboard(path)
end

--- Copy relative path with current line number to clipboard
function M.copy_relative_path_with_line()
	local path = vim.fn.expand("%")
	if path == "" then
		vim.notify("No file name for current buffer", vim.log.levels.WARN)
		return
	end
	copy_to_clipboard(path .. ":" .. vim.fn.line("."))
end

--- Copy absolute path with current line number to clipboard
function M.copy_absolute_path_with_line()
	local path = vim.fn.expand("%:p")
	if path == "" then
		vim.notify("No file name for current buffer", vim.log.levels.WARN)
		return
	end
	copy_to_clipboard(path .. ":" .. vim.fn.line("."))
end

--- Copy current buffer file name to clipboard
function M.copy_file_name()
	local name = vim.fn.expand("%:t")
	if name == "" then
		vim.notify("No file name for current buffer", vim.log.levels.WARN)
		return
	end
	copy_to_clipboard(name)
end

--- Copy current buffer file directory to clipboard (with trailing slash)
function M.copy_file_directory()
	local full_path = vim.fn.expand("%:p")
	local dir
	if full_path ~= "" then
		dir = vim.fn.expand("%:p:h")
	else
		dir = vim.fn.getcwd()
	end
	if dir ~= "" and dir:sub(-1) ~= "/" then
		dir = dir .. "/"
	end
	copy_to_clipboard(dir)
end
M.copy_directory = M.copy_file_directory

--- Copy entire buffer contents to clipboard
function M.copy_whole_file()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local content = table.concat(lines, "\n")
	copy_to_clipboard(content)
end

--- Copy GitHub/Git remote URL of current file and line range to clipboard
---@param mode string "n" for normal mode or "v" for visual mode
---@param line1 integer start line
---@param line2 integer end line
function M.copy_git_url(mode, line1, line2)
	local full_path = vim.fn.expand("%:p")
	if full_path == "" then
		vim.notify("No file name for current buffer", vim.log.levels.WARN)
		return
	end

	local repo_url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", ""):gsub("%.git$", "")
	if repo_url == "" then
		vim.notify("Not a git repository", vim.log.levels.WARN)
		return
	end

	-- Convert SSH format to HTTPS url
	repo_url = repo_url:gsub("^git@github%.com:", "https://github.com/")
	repo_url = repo_url:gsub("^git@([^:]+):", "https://%1/")
	repo_url = repo_url:gsub("^ssh://git@", "https://")

	local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
	if branch == "" then
		branch = vim.fn.system("git rev-parse --short HEAD"):gsub("\n", "")
	end

	-- Get relative path to repository root if possible
	local relative_file = vim.fn.expand("%:.")
	local repo_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
	if vim.v.shell_error == 0 and repo_root ~= "" then
		if full_path:sub(1, #repo_root) == repo_root then
			local rel = full_path:sub(#repo_root + 2)
			if rel ~= "" then
				relative_file = rel
			end
		end
	end

	local start_line = line1
	local end_line = line2
	if mode == "n" then
		start_line = vim.fn.line(".")
		end_line = start_line
	end

	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local url = string.format("%s/blob/%s/%s#L%d", repo_url, branch, relative_file, start_line)
	if mode == "v" and start_line ~= end_line then
		url = string.format("%s-L%d", url, end_line)
	end
	copy_to_clipboard(url)
end

-- Backward compatibility aliases
function M.yank_relative_path_with_line()
	M.copy_relative_path_with_line()
end

function M.yank_absolute_path_with_line()
	M.copy_absolute_path_with_line()
end

--- Open Snacks buffer picker jumping to existing window if buffer is already visible
function M.pick_buffers()
	local ok, snacks = pcall(require, "snacks")
	if not ok then
		return
	end
	snacks.picker.buffers({
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end
			vim.schedule(function()
				for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
						if vim.api.nvim_win_get_buf(win) == item.buf then
							vim.api.nvim_set_current_tabpage(tab)
							vim.api.nvim_set_current_win(win)
							return
						end
					end
				end
				vim.api.nvim_set_current_buf(item.buf)
			end)
		end,
	})
end

--- Open a Snacks file picker that includes directories and dispatches appropriately:
--- If a directory is confirmed: opens in Oil floating window.
--- If a file is confirmed: edits the file in buffer.
---@param opts? table { cwd?: string, title?: string, ft?: string|string[], hidden?: boolean, ignored?: boolean }
function M.pick_files_and_dirs(opts)
	opts = opts or {}
	local ok, snacks = pcall(require, "snacks")
	if not ok then
		vim.notify("snacks.nvim is required for pick_files_and_dirs", vim.log.levels.ERROR)
		return
	end

	local cwd = opts.cwd or snacks.git.get_root() or vim.fn.getcwd()
	local picker_opts = {
		cwd = cwd,
		title = opts.title or "Files & Dirs",
		args = { "--type", "d" },
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end
			local item_cwd = item.cwd or cwd
			local target = item.file or item.path or item.text
			local full_path = vim.fs.joinpath(item_cwd, target)
			vim.schedule(function()
				if vim.fn.isdirectory(full_path) == 1 then
					local oil_ok, oil = pcall(require, "oil")
					if oil_ok then
						oil.open_float(full_path, { preview = {} })
					else
						vim.cmd.edit(vim.fn.fnameescape(full_path))
					end
				else
					vim.cmd.edit(vim.fn.fnameescape(full_path))
				end
			end)
		end,
	}

	if opts.ft then
		picker_opts.ft = opts.ft
	end
	if opts.hidden ~= nil then
		picker_opts.hidden = opts.hidden
	end
	if opts.ignored ~= nil then
		picker_opts.ignored = opts.ignored
	end

	if opts.win then
		picker_opts.win = opts.win
	end

	snacks.picker.files(picker_opts)
end

--- Search files and directories anchored to repository root
function M.pick_repo_files_and_dirs()
	local ok, snacks = pcall(require, "snacks")
	local root = ok and (snacks.git.get_root() or vim.fn.getcwd()) or vim.fn.getcwd()
	M.pick_files_and_dirs({ cwd = root, title = "Repo Root (Files & Dirs)" })
end

--- Search markdown files anchored to repository root
function M.pick_markdown_files()
	local ok, snacks = pcall(require, "snacks")
	local root = ok and (snacks.git.get_root() or vim.fn.getcwd()) or vim.fn.getcwd()
	M.pick_files_and_dirs({
		cwd = root,
		ft = { "md", "markdown" },
		title = "Markdown Files (Repo Root)",
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
	})
end

--- Search files and directories across drive /z/
function M.pick_z_drive()
	M.pick_files_and_dirs({ cwd = "/z", title = "Drive /z/ (Files & Dirs)" })
end

--- Search files and directories across user $HOME
function M.pick_home_dir()
	M.pick_files_and_dirs({ cwd = vim.env.HOME, title = "Home ~/ (Files & Dirs)" })
end

return M
