local nerdy_ok, nerdy = pcall(require, "nerdy")
if nerdy_ok then
	nerdy.setup({
		max_recents = 80,
		use_new_command = true,
	})
end
