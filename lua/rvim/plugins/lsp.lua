require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"tree-sitter-cli",
		"lua-language-server",
		"prettier",
		"prettierd",
		"selene",
		"shellcheck",
		"shfmt",
		"stylua",
		"eslint-lsp",
		"oxlint",
		"oxfmt",
		"tailwindcss-language-server",
		"vtsls",
		"copilot-language-server",
		"rust-analyzer",
		"kotlin-language-server",
		"ktlint",
		"jdtls",
		"google-java-format",
		"lemminx",
		"xmlformatter",
		"bash-language-server",
		"pyright",
		"clangd",
		"clang-format",
	},
	auto_update = false,
	run_on_start = true,
})

local capabilities = {
	workspace = {
		fileOperations = {
			didRename = true,
			willRename = true,
		},
	},
}
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
})

vim.lsp.enable({
	"eslint",
	"oxlint",
	"lua_ls",
	"cssls",
	"vtsls",
	"tailwindcss",
	"glsl_analyzer",
	"rust_analyzer",
	"clangd",
	"bashls",
	"pyright",
	"kotlin_language_server",
	"jdtls",
	"lemminx",
	"qmlls",
})
