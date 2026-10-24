local ok, rm = pcall(require, "render-markdown")
if not ok then
	return
end

rm.setup({
	heading = {
		sign = false,
		icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
	},
	code = {
		sign = false,
		width = "block",
		right_pad = 1,
	},
	pipe_table = {
		style = "full",
	},
	latex = {
		enabled = false, -- prevent warnings if external latex tools are not installed
	},
})
