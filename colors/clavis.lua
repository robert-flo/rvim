if vim.o.background == "light" then
	require("rvim.theme.clavis_light").setup()
else
	require("solarized-osaka").setup({
		style = "vivid",
		transparent = true,
	})
	vim.cmd([[colorscheme solarized-osaka]])
end
