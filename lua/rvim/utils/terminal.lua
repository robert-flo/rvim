---Terminal suite commands, ported from nvim2k's homegrown.terminal module.
local M = {}

M.open = function(command, position)
	local Snacks = require("snacks")
	-- Map legacy aliases for termim compatibility
	if position == "split" then
		position = "bottom"
	elseif position == "vsplit" then
		position = "right"
	end

	local cmd = command ~= "" and command or nil
	Snacks.terminal.toggle(cmd, { win = { position = position or "bottom" } })
end

function M.setup()
	vim.api.nvim_create_user_command("Fterm", function(input)
		M.open(input.args, "float")
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("Sterm", function(input)
		M.open(input.args, "bottom")
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("Vterm", function(input)
		M.open(input.args, "right")
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("Tterm", function(input)
		M.open(input.args, "current")
	end, { nargs = "*" })
end

return M
