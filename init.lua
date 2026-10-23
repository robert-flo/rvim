if vim.loader then
	vim.loader.enable()
end

-- _G.dd = function(...)
--     require("util.debug").dump(...)
-- end
-- vim.print = _G.dd

_G.Rvim = require("rvim.utils")
require("rvim.config.options")
require("rvim.config.keymaps")
require("rvim.config.autocmds")
require("rvim.config.commands")
require("rvim.config.workarounds")
require("rvim.plugins")
