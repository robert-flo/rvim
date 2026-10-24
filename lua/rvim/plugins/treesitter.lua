local TS = require("nvim-treesitter")

local ensure_installed = {
	"astro",
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"diff",
	"fish",
	"gitignore",
	"go",
	"graphql",
	"groovy",
	"html",
	"http",
	"java",
	"javascript",
	"jsdoc",
	"json",
	"kotlin",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"php",
	"printf",
	"properties",
	"python",
	"qmljs",
	"query",
	"regex",
	"rust",
	"scss",
	"sql",
	"svelte",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

TS.install(ensure_installed)

-- Filetype and Treesitter parser registrations
vim.filetype.add({
	extension = {
		mdx = "mdx",
		qml = "qml",
	},
})
vim.treesitter.language.register("markdown", "mdx")
vim.treesitter.language.register("qmljs", "qml")

local treesitter_group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = treesitter_group,
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if not lang or not vim.treesitter.language.add(lang) then
			return
		end

		if not vim.treesitter.highlighter.active[ev.buf] then
			vim.treesitter.start(ev.buf, lang)
		end

		vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Hook
local hooks = function(ev)
	local name, kind = ev.data.spec.name, ev.data.kind
	if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
		vim.cmd("TSUpdate")
	end
end
vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })
