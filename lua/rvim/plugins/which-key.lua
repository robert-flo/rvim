local ok, which_key = pcall(require, "which-key")
if not ok then
	return
end

local icons = Rvim.icons
local Snacks = require("snacks")

local setup = {
	preset = "modern",
	plugins = {
		marks = true,
		registers = true,
		spelling = {
			enabled = true,
			suggestions = 30,
		},
		presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
	},
	icons = {
		breadcrumb = icons.ui.ArrowOpen,
		separator = icons.ui.Arrow,
		group = "",
		keys = {
			Space = icons.ui.Rocket,
		},
		rules = false,
	},
	win = {
		no_overlap = true,
		border = "rounded",
		width = 0.9,
		height = { min = 5, max = 25 },
		padding = { 1, 2 },
		title = true,
		title_pos = "center",
		zindex = 1000,
		wo = {
			winblend = 0,
		},
	},
	layout = {
		width = { min = 20, max = 30 },
		spacing = 6,
		align = "center",
	},
	show_help = false,
	show_keys = true,
	triggers = {
		{ "<auto>", mode = "nvisoct" },
		{ "<leader>", mode = { "n", "v" } },
	},
}

which_key.setup(setup)

local function set_which_key_highlights()
	local theme_utils = require("rvim.utils.theme")
	local mode = theme_utils.get_current_mode()
	if mode == "light" then
		local p = require("rvim.theme.palette").light
		vim.api.nvim_set_hl(0, "WhichKey", { fg = p.blue, bold = true })
		vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = p.fg })
		vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = p.blue_deep, bold = true })
		vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = p.fg_dim })
		vim.api.nvim_set_hl(0, "WhichKeyNormal", { fg = p.fg, bg = p.bg_float })
		vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = p.blue, bg = p.bg_float })
		vim.api.nvim_set_hl(0, "WhichKeyTitle", { fg = p.blue_deep, bg = p.bg_float, bold = true })
	else
		vim.api.nvim_set_hl(0, "WhichKey", { fg = "#e06c75", bold = true })
		vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = "#70b0ff" })
		vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = "#e5c07b", bold = true })
		vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = "#586e75" })
		vim.api.nvim_set_hl(0, "WhichKeyTitle", { fg = "#2aa198", bold = true })
	end
end

set_which_key_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = set_which_key_highlights,
})

which_key.add({
	-- Root Groups
	{ "<leader>b", group = "󰈔 Buffers" },
	{ "<leader>c", group = "󰘦 Code" },
	{ "<leader>d", group = " Diff" },
	{ "<leader>e", group = "󰉋 Explorer & Files" },
	{ "<leader>r", group = "󰛖 Refactor" },
	{ "<leader>m", group = "󰉋 TFM (Elio)" },
	{ "<leader>p", group = "󰏗 Packages" },
	{ "<leader>s", group = " Split / Window" },
	{ "<leader>t", group = "󰓩 Tabs" },
	{ "<leader>y", group = " Yank" },
	{ "<leader>;", group = " Pickers" },

	-- Normal Mode
	mode = { "n" },

	-- Express Root Actions
	{
		"<leader><space>",
		function()
			require("rvim.utils.editor").pick_repo_files_and_dirs()
		end,
		desc = "Repo Files & Dirs",
	},
	{
		"<leader>,",
		function()
			require("rvim.utils.editor").pick_buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>/",
		function()
			Snacks.picker.search_history()
		end,
		desc = "Search History",
	},
	{
		"<leader>:",
		function()
			Snacks.picker.command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>x",
		function()
			require("conform").format()
			vim.cmd("xa")
		end,
		desc = " Format, Save & Quit",
	},
	{
		"<leader>w",
		function()
			require("conform").format()
			vim.cmd("write")
		end,
		desc = "Format & Save",
	},
	{
		"<leader>f",
		function()
			require("conform").format()
		end,
		desc = "Format Code",
	},
	{
		"<leader>j",
		function()
			require("rvim.utils.editor").open_package_json()
		end,
		desc = "Open package.json",
	},
	{ "<leader>C", '"_C', desc = "Change to EOL" },
	{ "<leader>D", '"_D', desc = "Delete to EOL" },
	{ "<leader>py", '"0p', desc = "Paste Last Yank" },
	{ "<leader>pY", '"0P', desc = "Paste Before" },
	{ "<leader>o", "o<Esc>^Da", desc = "Clean Line Below" },
	{ "<leader>O", "O<Esc>^Da", desc = "Clean Line Above" },
	{
		"<leader>u",
		function()
			Snacks.picker.undo()
		end,
		desc = "Undo History",
	},
	{
		"<leader>?",
		function()
			Snacks.picker.help()
		end,
		desc = "Help Tags",
	},

	-- Git Suite (<leader>g) - Normal Mode
	{ "<leader>g", group = "󰊢 Git" },
	{ "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
	{ "<leader>gA", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
	{
		"<leader>gb",
		function()
			require("gitsigns").blame_line()
		end,
		desc = "Blame current line",
	},
	{
		"<leader>gB",
		function()
			require("gitsigns").blame()
		end,
		desc = "Blame buffer",
	},
	{
		"<leader>gc",
		function()
			Snacks.terminal("git commit")
		end,
		desc = "Commit Staged",
	},
	{ "<leader>gC", "<cmd>CoAuthor<cr>", desc = "Co-Authors" },
	{
		"<leader>gd",
		function()
			require("mini.diff").toggle_overlay()
		end,
		desc = "Toggle MiniDiff overlay",
	},
	{ "<leader>gD", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Gitsigns Diff HEAD" },
	{
		"<leader>gf",
		function()
			Snacks.picker.git_log_file()
		end,
		desc = "File Commits",
	},
	{
		"<leader>gg",
		function()
			require("rvim.utils.lazygit").open()
		end,
		desc = "Lazygit",
	},
	{
		"<leader>gh",
		function()
			require("gitsigns").stage_hunk()
		end,
		desc = "Toggle stage hunk",
	},
	{ "<leader>gi", "<cmd>Gitsigns preview_hunk<cr>", desc = "Hunk Info" },
	{
		"<leader>gI",
		function()
			Snacks.git.blame_line()
		end,
		desc = "Detailed Blame (Snacks)",
	},
	{ "<leader>gj", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
	{ "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
	{
		"<leader>gl",
		function()
			Snacks.picker.git_log_line()
		end,
		desc = "Line Commits",
	},
	{
		"<leader>gL",
		function()
			Snacks.picker.git_log()
		end,
		desc = "Git Commit Log",
	},
	{
		"<leader>gm",
		function()
			Snacks.picker.git_status()
		end,
		desc = "Git Status",
	},
	{
		"<leader>go",
		function()
			local async = require("gitsigns.async")
			local cache = require("gitsigns.cache").cache

			async.run(function()
				local bufnr = vim.api.nvim_get_current_buf()
				local lnum = vim.api.nvim_win_get_cursor(0)[1]
				local bcache = cache[bufnr]
				if not bcache then
					return
				end

				bcache:get_blame(lnum)
				local blame = bcache.blame
				if not blame or not blame.entries or not blame.entries[lnum] then
					return
				end

				local info = blame.entries[lnum]
				local sha = info.commit.sha

				if tonumber("0x" .. sha:sub(1, 8)) == 0 then
					vim.notify("Line not committed yet", vim.log.levels.WARN)
					return
				end

				vim.cmd.tabnew()
				require("gitsigns.actions.diffthis").show(bufnr, sha, info.filename)
				async.schedule()
				pcall(vim.api.nvim_win_set_cursor, 0, { info.orig_lnum or lnum, 0 })
			end)
		end,
		desc = "Open file from blamed commit",
	},
	{
		"<leader>gp",
		function()
			Snacks.picker.git_branches()
		end,
		desc = "Git Branches",
	},
	{ "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
	{ "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
	{
		"<leader>gs",
		function()
			local gs = require("gitsigns")
			if #(gs.get_hunks() or {}) > 0 then
				gs.stage_buffer()
			else
				gs.reset_buffer_index()
			end
		end,
		desc = "Toggle stage buffer",
	},
	{
		"<leader>gS",
		function()
			Snacks.picker.git_stash()
		end,
		desc = "Git Stash",
	},
	{ "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },
	{ "<leader>gv", "<cmd>Gitsigns select_hunk<cr>", desc = "Select Hunk" },
	{
		"<leader>gw",
		function()
			require("snacks").gitbrowse()
		end,
		desc = "Git Browse",
	},

	-- GitHub subgroup (<leader>gH)
	{ "<leader>gH", group = "GitHub" },
	{
		"<leader>gHi",
		function()
			Snacks.picker.gh_issue()
		end,
		desc = "GitHub Issues (open)",
	},
	{
		"<leader>gHI",
		function()
			Snacks.picker.gh_issue({ state = "all" })
		end,
		desc = "GitHub Issues (all)",
	},
	{
		"<leader>gHp",
		function()
			Snacks.picker.gh_pr()
		end,
		desc = "GitHub Pull Requests (open)",
	},
	{
		"<leader>gHP",
		function()
			Snacks.picker.gh_pr({ state = "all" })
		end,
		desc = "GitHub Pull Requests (all)",
	},

	-- Octohub subgroup (<leader>gO)
	{ "<leader>gO", group = "Octohub" },
	{ "<leader>gOo", "<cmd>Octohub repos<cr>", desc = "All Repos" },
	{ "<leader>gOb", "<cmd>Octohub repos sort:size<cr>", desc = "Repos by Size" },
	{ "<leader>gOc", "<cmd>Octohub repos sort:created<cr>", desc = "Repos by Created" },
	{ "<leader>gOf", "<cmd>Octohub repos sort:forks<cr>", desc = "Repos by Forks" },
	{ "<leader>gOi", "<cmd>Octohub repos sort:issues<cr>", desc = "Repos by Issues" },
	{ "<leader>gOl", "<cmd>Octohub repos sort:language<cr>", desc = "Repos by Language" },
	{ "<leader>gOs", "<cmd>Octohub repos sort:stars<cr>", desc = "Repos by Stars" },
	{ "<leader>gOu", "<cmd>Octohub repos sort:updated<cr>", desc = "Repos by Updated" },
	{ "<leader>gOU", "<cmd>Octohub repos sort:pushed<cr>", desc = "Repos by Pushed" },
	{ "<leader>gOA", "<cmd>Octohub repos type:archived<cr>", desc = "Archived Repos" },
	{ "<leader>gOF", "<cmd>Octohub repos type:forked<cr>", desc = "Forked Repos" },
	{ "<leader>gOP", "<cmd>Octohub repos type:private<cr>", desc = "Private Repos" },
	{ "<leader>gOS", "<cmd>Octohub repos type:starred<cr>", desc = "Starred Repos" },
	{ "<leader>gOT", "<cmd>Octohub repos type:template<cr>", desc = "Template Repos" },
	{ "<leader>gOL", "<cmd>Octohub repos languages<cr>", desc = "Filter by Language" },
	{ "<leader>gOa", "<cmd>Octohub stats activity<cr>", desc = "Activity Stats" },
	{ "<leader>gOg", "<cmd>Octohub stats contributions<cr>", desc = "Contribution Graph" },
	{ "<leader>gOr", "<cmd>Octohub stats repo<cr>", desc = "Repo Stats" },
	{ "<leader>gOt", "<cmd>Octohub stats<cr>", desc = "All Stats" },
	{ "<leader>gOp", "<cmd>Octohub web profile<cr>", desc = "Open GitHub Profile" },
	{ "<leader>gOw", "<cmd>Octohub web repo<cr>", desc = "Open Repo in Browser" },

	-- Toggle subgroup (<leader>gt)
	{ "<leader>gt", group = "Toggle" },
	{ "<leader>gtb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Blame" },
	{ "<leader>gtd", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Deleted" },
	{ "<leader>gtl", "<cmd>Gitsigns toggle_linehl<cr>", desc = "Line HL" },
	{ "<leader>gtn", "<cmd>Gitsigns toggle_numhl<cr>", desc = "Number HL" },
	{ "<leader>gts", "<cmd>Gitsigns toggle_signs<cr>", desc = "Signs" },
	{ "<leader>gtw", "<cmd>Gitsigns toggle_word_diff<cr>", desc = "Word Diff" },
	-- Yank Suite (<leader>y) - Normal Mode
	{ "<leader>y", group = " Yank" },
	{ "<leader>ya", ":%y+<cr>", desc = "Copy Whole File" },
	{
		"<leader>yb",
		function()
			require("rvim.utils.editor").copy_branch_name()
		end,
		desc = "Branch Name",
	},
	{ "<leader>yd", "<cmd>CopyFileDirectory<cr>", desc = "File Directory" },
	{
		"<leader>yf",
		function()
			require("rvim.utils.editor").yank_relative_path_with_line()
		end,
		desc = "Relative Path (#L<line>)",
	},
	{ "<leader>yF", "<cmd>CopyFileName<cr>", desc = "File Name" },
	{ "<leader>yg", "<cmd>GitLink<cr>", desc = "Copy Git URL (GitLink)" },
	{ "<leader>yG", "<cmd>CopyGitUrl<cr>", desc = "Copy Git URL (Custom)" },
	{
		"<leader>yh",
		function()
			require("rvim.utils.editor").copy_commit_hash()
		end,
		desc = "Commit Hash",
	},
	{ "<leader>yl", "<cmd>CopyRelativePathWithLine<cr>", desc = "Relative Path (:line)" },
	{ "<leader>yL", "<cmd>CopyAbsolutePathWithLine<cr>", desc = "Absolute Path (:line)" },
	{ "<leader>yn", "<cmd>CopyFileName<cr>", desc = "File Name" },
	{
		"<leader>yp",
		function()
			require("rvim.utils.editor").yank_absolute_path_with_line()
		end,
		desc = "Absolute Path (#L<line>)",
	},
	{ "<leader>yP", "<cmd>CopyAbsolutePath<cr>", desc = "Absolute Path" },
	{ "<leader>yr", "<cmd>CopyRelativePath<cr>", desc = "Relative Path" },
	{
		"<leader>yw",
		function()
			require("rvim.utils.editor").copy_word_under_cursor()
		end,
		desc = "Word Under Cursor",
	},

	-- Toggle Suite (<leader>U) - Normal Mode
	{ "<leader>U", group = "Toggle" },
	{
		"<leader>UB",
		function()
			require("snacks").toggle.dim():toggle()
		end,
		desc = "Toggle Dim",
	},
	{
		"<leader>UD",
		function()
			require("snacks").toggle.diagnostics():toggle()
		end,
		desc = "Toggle Diagnostics",
	},
	{
		"<leader>UH",
		function()
			require("snacks").toggle.inlay_hints():toggle()
		end,
		desc = "Toggle Inlay Hints",
	},
	{
		"<leader>UL",
		function()
			require("snacks").toggle.line_number():toggle()
		end,
		desc = "Toggle Line Numbers",
	},
	{
		"<leader>UN",
		function()
			require("snacks").toggle.option("wrap", { name = "Wrap" }):toggle()
		end,
		desc = "Toggle Line Wrap",
	},
	{
		"<leader>UR",
		function()
			require("snacks").toggle.option("relativenumber", { name = "Relative Numbers" }):toggle()
		end,
		desc = "Toggle Relative Numbers",
	},
	{
		"<leader>US",
		function()
			require("snacks").toggle.option("spell", { name = "Spellcheck" }):toggle()
		end,
		desc = "Toggle Spellcheck",
	},
	{
		"<leader>UW",
		function()
			require("snacks").toggle.words():toggle()
		end,
		desc = "Toggle Word References",
	},
	{
		"<leader>UZ",
		function()
			require("snacks").toggle.zen():toggle()
		end,
		desc = "Toggle Zen",
	},
	-- Pickers Suite (<leader>;) - Normal Mode
	{ "<leader>;", group = " Pickers" },
	{
		"<leader>;;",
		function()
			Snacks.picker.resume()
		end,
		desc = "Resume Picker",
	},
	{
		"<leader>;b",
		function()
			require("rvim.utils.editor").pick_buffers()
		end,
		desc = "List Buffers",
	},
	{
		"<leader>;c",
		function()
			Snacks.picker.lsp_incoming_calls()
		end,
		desc = "Incoming Calls",
	},
	{
		"<leader>;e",
		function()
			Snacks.picker.diagnostics()
		end,
		desc = "Diagnostics",
	},
	{
		"<leader>;f",
		function()
			require("rvim.utils.editor").pick_repo_files_and_dirs()
		end,
		desc = "Repo Files & Dirs",
	},
	{
		"<leader>;M",
		function()
			require("rvim.utils.editor").pick_markdown_files()
		end,
		desc = "Repo Markdown Files",
	},
	{
		"<leader>;z",
		function()
			require("rvim.utils.editor").pick_z_drive()
		end,
		desc = "Drive /z/ (Files & Dirs)",
	},
	{
		"<leader>;H",
		function()
			require("rvim.utils.editor").pick_home_dir()
		end,
		desc = "Home ~/ (Files & Dirs)",
	},
	{ "<leader>;a", "<cmd>Seeker files<cr>", desc = "Seeker Files" },
	{ "<leader>;F", "<cmd>Seeker git_files<cr>", desc = "Seeker Git Files" },
	{ "<leader>;G", "<cmd>Seeker grep<cr>", desc = "Seeker Grep" },
	{ "<leader>;W", "<cmd>Seeker grep_word<cr>", desc = "Seeker Grep Word" },
	{
		"<leader>;g",
		function()
			require("rvim.utils.lazygit").open()
		end,
		desc = "Lazygit",
	},
	{
		"<leader>;h",
		function()
			Snacks.picker.git_diff()
		end,
		desc = "Git Diff Hunks",
	},
	{
		"<leader>;n",
		function()
			Snacks.picker.notifications()
		end,
		desc = "Notifications",
	},
	{
		"<leader>;o",
		function()
			Snacks.picker.recent()
		end,
		desc = "Recent Files",
	},
	{
		"<leader>;r",
		function()
			Snacks.picker.grep()
		end,
		desc = "Live Grep",
	},
	{
		"<leader>;s",
		function()
			Snacks.picker.lsp_symbols()
		end,
		desc = "Document Symbols",
	},
	{
		"<leader>;w",
		function()
			Snacks.picker.grep_word()
		end,
		desc = "Grep Word",
	},
	{
		"<leader>;l",
		function()
			Snacks.picker.lines()
		end,
		desc = "Buffer Lines",
	},
	{
		"<leader>;m",
		function()
			Snacks.picker.git_status()
		end,
		desc = "Git Status",
	},
	{
		"<leader>;C",
		function()
			Snacks.picker.commands()
		end,
		desc = "Commands",
	},
	{
		"<leader>;u",
		function()
			Snacks.picker.undo()
		end,
		desc = "Undo History",
	},
	{
		"<leader>;?",
		function()
			Snacks.picker.help()
		end,
		desc = "Help Tags",
	},
	{
		"<leader>;x",
		"<cmd>restart<cr>",
		desc = "Reload / Restart Neovim",
	},
	{
		"<leader>;X",
		"<cmd>restart +qall!<cr>",
		desc = "Force Restart (Discard Unsaved)",
	},
	{
		"<leader>;t",
		"<cmd>Tfm<cr>",
		desc = "Terminal File Manager (Elio)",
	},
	{
		";t",
		"<cmd>Tfm<cr>",
		desc = "Terminal File Manager (Elio)",
	},
	{
		"<leader>;T",
		function()
			Snacks.picker.todo_comments()
		end,
		desc = "Todo Comments",
	},
	{
		";T",
		function()
			Snacks.picker.todo_comments()
		end,
		desc = "Todo Comments",
	},
	{
		"]t",
		function()
			require("todo-comments").jump_next()
		end,
		desc = "Next Todo Comment",
	},
	{
		"[t",
		function()
			require("todo-comments").jump_prev()
		end,
		desc = "Prev Todo Comment",
	},
	{ "]c", desc = "Next Git Hunk" },
	{ "[c", desc = "Prev Git Hunk" },
	{ "]x", desc = "Next Conflict Marker" },
	{ "[x", desc = "Prev Conflict Marker" },
	{ "]<space>", desc = "Blank Line Below" },
	{ "[<space>", desc = "Blank Line Above" },
	{ "]]", desc = "Next Reference" },
	{ "[[", desc = "Prev Reference" },
	-- Buffers Suite (<leader>b)
	{ "<leader>b", group = "󰈔 Buffers" },
	{
		"<leader>bb",
		function()
			require("rvim.utils.editor").pick_buffers()
		end,
		desc = "List Buffers",
	},
	{
		"<leader>bd",
		function()
			require("rvim.utils.editor").delete_hidden_buffers()
		end,
		desc = "Delete Hidden Buffers",
	},
	{ "<leader>bx", "<cmd>bdelete<cr>", desc = "Close Current Buffer" },
	{ "<leader>bo", "<cmd>%bd|e#|bd#<cr>", desc = "Close Other Buffers" },

	-- Code Suite (<leader>c)
	{ "<leader>c", group = "󰘦 Code" },
	{
		"<leader>ca",
		function()
			vim.lsp.buf.code_action()
		end,
		desc = "Code Action",
	},
	{
		"<leader>cc",
		function()
			vim.lsp.codelens.run()
		end,
		desc = "Run CodeLens",
	},
	{
		"<leader>cC",
		function()
			vim.lsp.codelens.refresh()
		end,
		desc = "Refresh CodeLens",
	},
	{
		"<leader>cd",
		function()
			vim.diagnostic.open_float()
		end,
		desc = "Line Diagnostics",
	},
	{
		"<leader>cf",
		function()
			require("conform").format()
		end,
		desc = "Format Code",
	},
	{
		"<leader>ci",
		function()
			require("snacks").toggle.inlay_hints():toggle()
		end,
		desc = "Toggle Inlay Hints",
	},
	{
		"<leader>cl",
		function()
			Snacks.picker.lsp_config()
		end,
		desc = "LSP Info",
	},
	{
		"<leader>cr",
		function()
			vim.lsp.buf.rename()
		end,
		desc = "Rename Symbol",
	},
	{
		"<leader>cR",
		function()
			Snacks.rename.rename_file()
		end,
		desc = "Rename File",
	},
	{ "<leader>cm", "<cmd>MDPreview<cr>", desc = "Markdown Live Preview" },
	{ "<leader>cM", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
	{ "<leader>ce", "<cmd>%Runner<cr>", desc = "Execute Buffer / File" },
	{ "<leader>cD", "<cmd>RootDir<cr>", desc = "Set Root Directory" },

	-- Diff Suite (<leader>d)
	{ "<leader>d", group = " Diff" },
	{ "<leader>dv", "<cmd>CodeDiff<cr>", desc = "Toggle CodeDiff" },
	{ "<leader>dh", "<cmd>CodeDiff history %<cr>", desc = "File history (current file)" },
	{ "<leader>dH", "<cmd>CodeDiff history<cr>", desc = "File history (repo)" },

	-- Explorer & Files Suite (<leader>e)
	{ "<leader>e", group = "󰉋 Explorer & Files" },
	{
		"<leader>ee",
		function()
			require("oil").open_float(nil, { preview = {} })
		end,
		desc = "File Explorer (Oil)",
	},
	{
		"<leader>ep",
		function()
			require("rvim.utils.editor").open_package_json()
		end,
		desc = "Open package.json",
	},
	{ "<leader>en", "<cmd>enew<cr>", desc = "New File" },
	{
		"<leader>em",
		function()
			require("rvim.utils.editor").pick_markdown_files()
		end,
		desc = "Markdown Files (Repo)",
	},
	{
		"<leader>ez",
		function()
			require("rvim.utils.editor").pick_z_drive()
		end,
		desc = "Browse /z/ Drive",
	},
	{
		"<leader>eh",
		function()
			require("rvim.utils.editor").pick_home_dir()
		end,
		desc = "Browse Home (~/)",
	},
	{ "<leader>er", "<cmd>RangerPicker<cr>", desc = "Ranger Picker" },
	{ "<leader>et", "<cmd>Tfm<cr>", desc = "TFM (Elio)" },
	{ "<leader>el", "<cmd>Tfm<cr>", desc = "Elio File Manager" },

	-- TFM / Terminal File Manager Suite (<leader>m)
	{ "<leader>m", group = "󰉋 TFM (Elio)" },
	{ "<leader>me", "<cmd>Tfm<cr>", desc = "Open Elio" },
	{ "<leader>mm", "<cmd>Tfm<cr>", desc = "Open Elio" },
	{ "<leader>mh", "<cmd>TfmSplit<cr>", desc = "TFM - Horizontal Split" },
	{ "<leader>mv", "<cmd>TfmVsplit<cr>", desc = "TFM - Vertical Split" },
	{ "<leader>mt", "<cmd>TfmTabedit<cr>", desc = "TFM - New Tab" },

	-- Packages Suite (<leader>p)
	{ "<leader>p", group = "󰏗 Packages" },
	{ "<leader>pe", function() require("snacks").profiler.scratch() end, desc = "Profiler Scratch" },
	{ "<leader>pf", function() require("snacks").profiler.pick() end, desc = "Profiler Pick" },
	{ "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" },
	{ "<leader>pmt", "<cmd>MasonToolsUpdate<cr>", desc = "Mason Tools Update" },
	{ "<leader>pt", function() require("snacks").profiler.toggle() end, desc = "Profiler Toggle" },
	{ "<leader>pu", "<cmd>lua vim.pack.update()<cr>", desc = "Update Plugins (vim.pack)" },
	{ "<leader>py", '"0p', desc = "Paste Last Yank" },
	{ "<leader>pY", '"0P', desc = "Paste Before" },

	-- Refactor Suite (<leader>r)
	{ "<leader>r", group = "󰛖 Refactor" },
	{ "<leader>ra", "<cmd>Replace<cr>", desc = "Project Search & Replace" },
	{ "<leader>rw", ":Replace <C-r><C-w><cr>", desc = "Replace Word Everywhere" },
	{ "<leader>rb", ":%s///gc<Left><Left><Left><Left>", desc = "Replace Buffer" },
	{ "<leader>rs", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", desc = "Replace Word Buffer" },
	{ "<leader>rc", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left>", desc = "Replace Word Buffer (Confirm)" },

	-- Split / Window Suite (<leader>s)
	{ "<leader>s", group = " Split / Window" },
	{ "<leader>s/", "<cmd>split<cr>", desc = "Horizontal Split" },
	{ "<leader>sv", "<cmd>vsplit<cr>", desc = "Vertical Split" },
	{ "<leader>sa", "<cmd>vsplit<cr>", desc = "Vertical Split" },
	{ "<leader>ss", "<cmd>AutoTile<cr>", desc = "AutoTile Split" },
	{ "<leader>se", "<C-w>=", desc = "Equalize Splits" },
	{ "<leader>sx", "<cmd>close<cr>", desc = "Close Current Split" },
	{ "<leader>so", "<C-w>o", desc = "Close Other Splits" },
	{ "<leader>sh", "<C-w>h", desc = "Focus Left" },
	{ "<leader>sj", "<C-w>j", desc = "Focus Down" },
	{ "<leader>sk", "<C-w>k", desc = "Focus Up" },
	{ "<leader>sl", "<C-w>l", desc = "Focus Right" },
	{ "<leader>sH", "<cmd>vertical resize -10<cr>", desc = "Decrease Width" },
	{ "<leader>sL", "<cmd>vertical resize +10<cr>", desc = "Increase Width" },
	{ "<leader>sJ", "<cmd>resize -5<cr>", desc = "Decrease Height" },
	{ "<leader>sK", "<cmd>resize +5<cr>", desc = "Increase Height" },
	{ "<leader>sT", "<C-w>T", desc = "Split to Tab" },
	{ "<leader>sZ", function() Snacks.zen.zoom() end, desc = "Zoom Split" },
	{ "<leader>s`", "<C-w>p", desc = "Previous Window" },

	-- Tabs Suite (<leader>t)
	{ "<leader>t", group = "󰓩 Tabs" },
	{ "<leader>te", "<cmd>tabedit<cr>", desc = "New Clean Tab" },
	{ "<leader>tx", "<cmd>tabclose<cr>", desc = "Close Tab" },
	{ "<leader>tl", "<cmd>tabnext<cr>", desc = "Next Tab" },
	{ "<leader>th", "<cmd>tabprev<cr>", desc = "Previous Tab" },
	{ "<leader>td", "<cmd>tab split<cr>", desc = "Duplicate Current Buffer" },
	{ "<leader>to", "<cmd>tabonly<cr>", desc = "Close Other Tabs" },
	{ "<leader>tH", ":-tabmove<cr>", desc = "Move Tab Left" },
	{ "<leader>tL", ":+tabmove<cr>", desc = "Move Tab Right" },
	{
		"<leader>tp",
		function()
			require("rvim.utils.editor").pick_tabs()
		end,
		desc = "Tab Picker",
	},


	-- Quit (<leader>q)
	{ "<leader>q", "<cmd>qa!<cr>", desc = "Force Quit (Without Saving)" },

	-- Q Pickers Suite (<leader>Q)
	{ "<leader>Q", group = "Pickers" },
	{ "<leader>Qa", "<cmd>lua Snacks.picker.autocmds()<cr>", desc = "Autocmds" },
	{ "<leader>Qc", "<cmd>lua Snacks.picker.command_history()<cr>", desc = "Command History" },
	{ "<leader>QC", "<cmd>lua Snacks.picker.colorschemes()<cr>", desc = "Colorschemes" },
	{ "<leader>Qd", "<cmd>lua Snacks.picker.help()<cr>", desc = "Docs" },
	{ "<leader>Qg", "<cmd>lua Snacks.picker.commands()<cr>", desc = "Commands" },
	{ "<leader>Qh", "<cmd>lua Snacks.picker.highlights()<cr>", desc = "Highlights" },
	{ "<leader>Qj", "<cmd>lua Snacks.picker.jumps()<cr>", desc = "Jump List" },
	{ "<leader>Qk", "<cmd>lua Snacks.picker.keymaps()<cr>", desc = "Keymaps" },
	{ "<leader>Qm", "<cmd>lua Snacks.picker.marks()<cr>", desc = "Marks" },
	{ "<leader>QM", "<cmd>lua Snacks.picker.man()<cr>", desc = "Man Pages" },
	{ "<leader>Qn", "<cmd>lua Snacks.picker.notifications()<cr>", desc = "Notifications" },
	{ "<leader>Qs", "<cmd>lua Snacks.picker.search_history()<cr>", desc = "Search History" },
	{ "<leader>Qt", "<cmd>lua Snacks.picker.treesitter()<cr>", desc = "Treesitter Find" },
	{ "<leader>Qf", function()
		require("rvim.utils.editor").pick_filetype()
	end, desc = "Change Filetype" },
	{ "<leader>Qi", "<cmd>lua vim.show_pos()<cr>", desc = "Inspect Position" },
	{ "<leader>QT", desc = "Cycle Theme (Light / Osaka / Onedark)" },

	-- Writing Suite (<leader>z)
	{ "<leader>z", group = "Writing" },
	{
		"<leader>zc",
		function()
			require("snacks").toggle.option("spell", { name = "Spellcheck" }):toggle()
		end,
		desc = "Toggle Spellcheck",
	},
	{
		"<leader>zd",
		function()
			require("snacks").toggle.dim():toggle()
		end,
		desc = "Toggle Dim",
	},
	{ "<leader>zf", "<cmd>w !sudo tee % >/dev/null<cr>", desc = "Force Write (sudo)" },
	{ "<leader>zj", "]s", desc = "Next Misspell" },
	{ "<leader>zk", "[s", desc = "Previous Misspell" },
	{
		"<leader>zn",
		function()
			local buf = vim.api.nvim_get_current_buf()
			local prev = vim.b[buf].disable_autoformat
			vim.b[buf].disable_autoformat = true
			pcall(vim.cmd, "write")
			vim.b[buf].disable_autoformat = prev
		end,
		desc = "Write Without Formatting",
	},
	{
		"<leader>zw",
		function()
			require("snacks").toggle.zen():toggle()
		end,
		desc = "Toggle Zen",
	},
	{
		"<leader>zW",
		function()
			require("snacks").zen.zoom()
		end,
		desc = "Zoom",
	},
	{ "ZR", "<cmd>restart<cr>", desc = "Reload / Restart Neovim" },
})

-- Visual Mode
which_key.add({
	mode = { "v" },
	{ "<leader>g", group = "󰊢 Git" },
	{ "<leader>ga", ":'<,'>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
	{ "<leader>gr", ":'<,'>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
	{ "<leader>gu", ":'<,'>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },

	-- Refactor Suite (<leader>r) - Visual Mode
	{ "<leader>r", group = "󰛖 Refactor" },
	{ "<leader>rv", '"y:%s/\\V<C-r>"//gc<Left><Left><Left>', desc = "Replace Selection in Buffer" },

	-- Yank Suite (<leader>y) - Visual Mode
	{ "<leader>y", group = " Yank" },
	{ "<leader>yg", ":GitLink<cr>", desc = "Copy Git URL (GitLink)" },
	{ "<leader>yG", ":CopyGitUrl<cr>", desc = "Copy Git URL (Custom)" },
	{
		"<leader>yf",
		function()
			require("rvim.utils.editor").yank_relative_path_with_line(vim.fn.line("'<"), vim.fn.line("'>"))
		end,
		desc = "Relative Path (#L<start>-L<end>)",
	},
	{
		"<leader>yp",
		function()
			require("rvim.utils.editor").yank_absolute_path_with_line(vim.fn.line("'<"), vim.fn.line("'>"))
		end,
		desc = "Absolute Path (#L<start>-L<end>)",
	},
	{
		"<leader>yl",
		function()
			require("rvim.utils.editor").copy_relative_path_with_line(vim.fn.line("'<"), vim.fn.line("'>"))
		end,
		desc = "Relative Path (:start-end)",
	},
	{
		"<leader>yL",
		function()
			require("rvim.utils.editor").copy_absolute_path_with_line(vim.fn.line("'<"), vim.fn.line("'>"))
		end,
		desc = "Absolute Path (:start-end)",
	},

	-- Code Suite (<leader>c) - Visual Mode
	{ "<leader>c", group = "󰘦 Code" },
	{
		"<leader>ca",
		function()
			vim.lsp.buf.code_action()
		end,
		desc = "Code Action",
	},
	{
		"<leader>cf",
		function()
			require("conform").format()
		end,
		desc = "Format Code",
	},
	{
		"<leader>cc",
		function()
			require("rvim.utils.editor").copy_as_codeblock()
		end,
		desc = "Copy as Codeblock",
	},
	{ "<leader>ce", ":'<,'>Runner<cr>", desc = "Execute Selection" },
	-- Safe Registers - Visual Mode
	{ "<leader>c", '"_c', desc = "Change (No Yank)" },
	{ "<leader>C", '"_C', desc = "Change to End of Line" },
	{ "<leader>d", '"_d', desc = "Delete (No Yank)" },
	{ "<leader>D", '"_D', desc = "Delete to End of Line" },
	{ "<leader>py", '"0p', desc = "Paste Last Yank" },
})
