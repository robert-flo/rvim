gh = function(x)
	return "https://github.com/" .. x
end

vim.pack.add({
	-- UI
	{ src = gh("craftzdog/solarized-osaka.nvim") },
	{ src = gh("nvim-mini/mini.icons") },
	{ src = gh("folke/which-key.nvim") },
	{ src = gh("folke/snacks.nvim") },
	{ src = gh("folke/trouble.nvim") },
	{ src = gh("nvim-lualine/lualine.nvim") },
	{ src = gh("b0o/incline.nvim") },
	{ src = gh("esmuellert/codediff.nvim") },
	{ src = gh("rachartier/tiny-cmdline.nvim") },
	-- Editor
	{ src = gh("stevearc/conform.nvim") },
	{ src = gh("nvim-treesitter/nvim-treesitter") },
	{ src = gh("nvim-mini/mini.pairs") },
	{ src = gh("craftzdog/mini.diff"), version = "feat/grouping" },
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("^1") },
	{ src = gh("folke/todo-comments.nvim") },
	{ src = gh("lewis6991/gitsigns.nvim") },
	{ src = gh("linrongbin16/gitlinker.nvim") },
	{ src = gh("brenoprata10/nvim-highlight-colors") },
	-- LSP
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("WhoIsSethDaniel/mason-tool-installer.nvim") },
	-- Util
	{ src = gh("stevearc/oil.nvim") },
	{ src = gh("zbirenbaum/copilot.lua") },
	{ src = gh("2kabhishek/co-author.nvim") },
	{ src = gh("2kabhishek/utils.nvim") },
	{ src = gh("2kabhishek/pickme.nvim") },
	{ src = gh("2kabhishek/octohub.nvim") },
	{ src = gh("2kabhishek/seeker.nvim") },
	{ src = gh("2kabhishek/homegrown.nvim") },
	{ src = gh("MeanderingProgrammer/render-markdown.nvim") },
	{ src = gh("rolv-apneseth/tfm.nvim") },
})

if #vim.api.nvim_get_runtime_file("lua/rvim/plugins/local.lua", false) > 0 then
	require("rvim.plugins.local")
end

require("rvim.plugins.ui")
require("rvim.plugins.treesitter")
require("rvim.plugins.editor")
require("rvim.plugins.lsp")
require("rvim.plugins.util")
require("rvim.plugins.octohub")
require("rvim.plugins.seeker")
require("rvim.plugins.homegrown")
require("rvim.plugins.render-markdown")
require("rvim.plugins.tfm")
require("rvim.plugins.keymaps")
require("rvim.plugins.which-key")
