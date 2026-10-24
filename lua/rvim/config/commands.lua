vim.api.nvim_create_user_command("ToggleFormatter", function()
	require("rvim.utils.editor").toggle_formatter()
end, { desc = "Toggle formatter for current buffer" })

vim.api.nvim_create_user_command("CopyRelativePath", function()
	require("rvim.utils.editor").copy_relative_path()
end, { desc = "Copy relative path to clipboard" })

vim.api.nvim_create_user_command("CopyAbsolutePath", function()
	require("rvim.utils.editor").copy_absolute_path()
end, { desc = "Copy absolute path to clipboard" })

vim.api.nvim_create_user_command("CopyRelativePathWithLine", function()
	require("rvim.utils.editor").copy_relative_path_with_line()
end, { desc = "Copy relative path with line number to clipboard" })

vim.api.nvim_create_user_command("CopyAbsolutePathWithLine", function()
	require("rvim.utils.editor").copy_absolute_path_with_line()
end, { desc = "Copy absolute path with line number to clipboard" })

vim.api.nvim_create_user_command("CopyFileName", function()
	require("rvim.utils.editor").copy_file_name()
end, { desc = "Copy file name to clipboard" })

vim.api.nvim_create_user_command("CopyWholeFile", function()
	require("rvim.utils.editor").copy_whole_file()
end, { desc = "Copy whole file to clipboard" })

vim.api.nvim_create_user_command("CopyGitUrl", function(opts)
	local mode = (opts.range > 0) and "v" or "n"
	require("rvim.utils.editor").copy_git_url(mode, opts.line1, opts.line2)
end, { range = "%", desc = "Copy Git URL to clipboard" })

