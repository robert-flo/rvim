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
		breadcrumb = "",
		separator = icons.ui.Arrow,
		group = "",
		keys = {
			Space = "",
		},
		rules = false,
	},
	win = {
		no_overlap = true,
		border = "rounded",
		width = 0.5,
		height = { min = 5, max = 25 },
		padding = { 1, 2 },
		title = true,
		title_pos = "center",
		zindex = 1000,
		wo = {
			winblend = 10,
		},
	},
	layout = {
		width = { min = 20 },
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
	vim.api.nvim_set_hl(0, "WhichKey", { fg = "#e06c75", bold = true })
	vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = "#70b0ff" })
	vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = "#e5c07b", bold = true })
	vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = "#586e75" })
	vim.api.nvim_set_hl(0, "WhichKeyTitle", { fg = "#2aa198", bold = true })
end

set_which_key_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = set_which_key_highlights,
})

which_key.add({
	-- Groups
	{ "<leader>c", group = "Code" },
	{ "<leader>d", group = "Diff" },
	{ "<leader>s", group = "Split / Window" },
	{ "<leader>y", group = " Yank" },

	-- Git Suite (<leader>g) - Normal Mode
	mode = { "n" },
	{ "<leader>g", group = "󰊢 Git" },
	{ "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
	{ "<leader>gA", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
	{
		"<leader>gb",
		function()
			require("gitsigns").blame_line({ full = true })
		end,
		desc = "Blame",
	},
	{
		"<leader>gB",
		function()
			require("snacks").git.blame_line()
		end,
		desc = "Detailed Blame",
	},
	{
		"<leader>gc",
		function()
			Snacks.terminal("git commit")
		end,
		desc = "Commit Staged",
	},
	{ "<leader>gC", "<cmd>CoAuthor<cr>", desc = "Co-Authors" },
	{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff" },
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
	{ "<leader>gi", "<cmd>Gitsigns preview_hunk<cr>", desc = "Hunk Info" },
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
	{ "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
	{ "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
	{
		"<leader>gs",
		function()
			Snacks.picker.git_branches()
		end,
		desc = "Git Branches",
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

	-- GitHub subgroup (<leader>gh)
	{ "<leader>gh", group = "GitHub" },
	{
		"<leader>ghi",
		function()
			Snacks.picker.gh_issue()
		end,
		desc = "GitHub Issues (open)",
	},
	{
		"<leader>ghI",
		function()
			Snacks.picker.gh_issue({ state = "all" })
		end,
		desc = "GitHub Issues (all)",
	},
	{
		"<leader>ghp",
		function()
			Snacks.picker.gh_pr()
		end,
		desc = "GitHub Pull Requests (open)",
	},
	{
		"<leader>ghP",
		function()
			Snacks.picker.gh_pr({ state = "all" })
		end,
		desc = "GitHub Pull Requests (all)",
	},

	-- Octohub subgroup (<leader>go)
	{ "<leader>go", group = "Octohub" },
	{ "<leader>goo", "<cmd>Octohub repos<cr>", desc = "All Repos" },
	{ "<leader>gob", "<cmd>Octohub repos sort:size<cr>", desc = "Repos by Size" },
	{ "<leader>goc", "<cmd>Octohub repos sort:created<cr>", desc = "Repos by Created" },
	{ "<leader>gof", "<cmd>Octohub repos sort:forks<cr>", desc = "Repos by Forks" },
	{ "<leader>goi", "<cmd>Octohub repos sort:issues<cr>", desc = "Repos by Issues" },
	{ "<leader>gol", "<cmd>Octohub repos sort:language<cr>", desc = "Repos by Language" },
	{ "<leader>gos", "<cmd>Octohub repos sort:stars<cr>", desc = "Repos by Stars" },
	{ "<leader>gou", "<cmd>Octohub repos sort:updated<cr>", desc = "Repos by Updated" },
	{ "<leader>goU", "<cmd>Octohub repos sort:pushed<cr>", desc = "Repos by Pushed" },
	{ "<leader>goA", "<cmd>Octohub repos type:archived<cr>", desc = "Archived Repos" },
	{ "<leader>goF", "<cmd>Octohub repos type:forked<cr>", desc = "Forked Repos" },
	{ "<leader>goP", "<cmd>Octohub repos type:private<cr>", desc = "Private Repos" },
	{ "<leader>goS", "<cmd>Octohub repos type:starred<cr>", desc = "Starred Repos" },
	{ "<leader>goT", "<cmd>Octohub repos type:template<cr>", desc = "Template Repos" },
	{ "<leader>goL", "<cmd>Octohub repos languages<cr>", desc = "Filter by Language" },
	{ "<leader>goa", "<cmd>Octohub stats activity<cr>", desc = "Activity Stats" },
	{ "<leader>gog", "<cmd>Octohub stats contributions<cr>", desc = "Contribution Graph" },
	{ "<leader>gor", "<cmd>Octohub stats repo<cr>", desc = "Repo Stats" },
	{ "<leader>got", "<cmd>Octohub stats<cr>", desc = "All Stats" },
	{ "<leader>gop", "<cmd>Octohub web profile<cr>", desc = "Open GitHub Profile" },
	{ "<leader>gow", "<cmd>Octohub web repo<cr>", desc = "Open Repo in Browser" },

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
	{ "<leader>yd", "<cmd>CopyFileDirectory<cr>", desc = "File Directory" },
	{ "<leader>yf", "<cmd>CopyFileName<cr>", desc = "File Name" },
	{ "<leader>yg", "<cmd>CopyGitUrl<cr>", desc = "Copy Git URL" },
	{ "<leader>yl", "<cmd>CopyRelativePathWithLine<cr>", desc = "Relative Path with Line" },
	{ "<leader>yL", "<cmd>CopyAbsolutePathWithLine<cr>", desc = "Absolute Path with Line" },
	{ "<leader>yp", "<cmd>CopyRelativePath<cr>", desc = "Relative Path" },
	{ "<leader>yP", "<cmd>CopyAbsolutePath<cr>", desc = "Absolute Path" },
})

-- Visual Mode
which_key.add({
	mode = { "v" },
	{ "<leader>g", group = "󰊢 Git" },
	{ "<leader>ga", ":'<,'>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
	{ "<leader>gr", ":'<,'>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
	{ "<leader>gu", ":'<,'>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },

	-- Yank Suite (<leader>y) - Visual Mode
	{ "<leader>y", group = " Yank" },
	{ "<leader>yg", ":CopyGitUrl<cr>", desc = "Copy Git URL" },
})
