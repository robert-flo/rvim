local ok, seeker = pcall(require, "seeker")
if not ok then
	return
end

seeker.setup({
	picker_provider = "snacks",
	toggle_key = "<C-e>",
	exclude_toggle_key = "<C-x>",
})
