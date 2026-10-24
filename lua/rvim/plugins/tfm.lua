local ok, tfm = pcall(require, "tfm")
if not ok then
	return
end

-- Register elio (/usr/bin/elio) as a supported terminal file manager
tfm.FILE_MANAGERS.elio = {
	cmd = "elio",
	set_file_chooser_output = "--chooser-file",
	set_focused_file = "",
}

tfm.setup({
	-- Set elio as default TFM
	file_manager = "elio",
	-- Do not replace netrw so oil.nvim remains our primary buffer explorer
	replace_netrw = false,
	-- Enable built-in :Tfm, :TfmSplit, :TfmVsplit, :TfmTabedit commands
	enable_cmds = true,
	-- Custom keybindings inside the TFM terminal buffer
	keybindings = {
		["<ESC>"] = "q",
		["<C-v>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.vsplit)<CR>",
		["<C-x>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.split)<CR>",
		["<C-t>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.tabedit)<CR>",
	},
	-- Window dimensions: edge-to-edge full width, 98% height aligned with rvim aesthetic
	ui = {
		border = "rounded",
		height = 0.98,
		width = 1,
		x = 0.5,
		y = 0.5,
	},
})
