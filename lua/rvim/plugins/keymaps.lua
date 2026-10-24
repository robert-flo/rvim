local keymap = vim.keymap

local map = function(keymaps)
	for _, keymap_entry in ipairs(keymaps) do
		local lhs = keymap_entry[1]
		local rhs = keymap_entry[2]
		local mode = keymap_entry.mode or "n"
		local opts = {
			desc = keymap_entry.desc,
			silent = keymap_entry.silent ~= false,
			noremap = keymap_entry.noremap ~= false,
			expr = keymap_entry.expr,
			nowait = keymap_entry.nowait,
			buffer = keymap_entry.buffer,
		}
		keymap.set(mode, lhs, rhs, opts)
	end
end

-- Oil - File explorer
map({
	{
		"sf",
		function()
			require("oil").open_float(nil, { preview = {} })
		end,
		desc = "Toggle file explorer",
	},
})

-- LSP
local Snacks = require("snacks")
map({
	-- { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
	-- {
	-- 	"gr",
	-- 	vim.lsp.buf.references,
	-- 	desc = "References",
	-- 	nowait = true,
	-- },
	{
		"gI",
		function()
			local clients = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })
			if #clients > 0 then
				local params = vim.lsp.util.make_position_params(0, "utf-16")
				clients[1]:request("workspace/executeCommand", {
					command = "typescript.goToSourceDefinition",
					arguments = { params.textDocument.uri, params.position },
				}, function(err, result)
					if err then
						vim.notify("goToSourceDefinition: " .. err.message, vim.log.levels.ERROR)
						return
					end
					if result and #result > 0 then
						vim.lsp.util.show_document(result[1], "utf-16", { focus = true })
					else
						vim.notify("No source definition found", vim.log.levels.INFO)
					end
				end, 0)
			else
				vim.lsp.buf.implementation()
			end
		end,
		desc = "Goto Source Definition / Implementation",
	},
	-- { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
	-- { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
	{
		"gd",
		function()
			Snacks.picker.lsp_definitions({ jump = { reuse_win = false } })
		end,
		desc = "LSP Goto Definition",
	},
	{ "gD", Snacks.picker.lsp_declarations, desc = "LSP Goto Declaration" },
	{ "gy", Snacks.picker.lsp_type_definitions, desc = "LSP Goto T[y]pe Definition" },
	{ "gr", Snacks.picker.lsp_references, desc = "LSP Goto Definition" },
	{ "K", vim.lsp.buf.hover, desc = "Hover" },
	{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
	{
		"<c-k>",
		vim.lsp.buf.signature_help,
		desc = "Signature Help",
		mode = "i",
	},
	{
		"<c-j>",
		function()
			vim.diagnostic.jump({ count = 1, float = true })
		end,
		desc = "Jump to next diagnostic",
		mode = "n",
	},
	{
		"<leader>ca",
		vim.lsp.buf.code_action,
		desc = "Code Action",
		mode = { "n", "x" },
	},
	{
		"<leader>cc",
		vim.lsp.codelens.run,
		desc = "Run Codelens",
		mode = { "n", "x" },
	},
	{ "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens" },
	{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
	{
		"<leader>f",
		function()
			require("conform").format()
		end,
		desc = "Format code",
		mode = { "n", "x" },
	},
	{
		"<leader>cf",
		function()
			require("conform").format()
		end,
		desc = "Format code",
		mode = { "n", "x" },
	},
})

-- Snacks
map({
	{ "<leader>cl", Snacks.picker.lsp_config, desc = "Lsp Info" },
	{ "<leader>cR", Snacks.rename.rename_file, desc = "Rename File" },
	{ ";f", Snacks.picker.files, desc = "Find files" },
	{ ";r", Snacks.picker.grep, desc = "Live grep" },
	{ ";s", Snacks.picker.lsp_symbols, desc = "LSP Document Symbols" },
	{ ";o", Snacks.picker.recent, desc = "Recent files" },
	{ ";;", Snacks.picker.resume, desc = "Resume picker" },
	{
		"\\\\",
		function()
			require("rvim.utils.editor").pick_buffers()
		end,
		desc = "List buffers",
	},
	{
		";b",
		function()
			require("rvim.utils.editor").pick_buffers()
		end,
		desc = "List buffers",
	},
	{ ";e", Snacks.picker.diagnostics, desc = "Diagnostics" },
	{ ";c", Snacks.picker.lsp_incoming_calls, desc = "LSP incoming calls" },
	{ ";n", Snacks.picker.notifications, desc = "Notifications" },
	{ ";w", Snacks.picker.grep_word, desc = "Grep word under cursor" },
	{
		";g",
		function()
			require("rvim.utils.lazygit").open()
		end,
		desc = "Lazygit",
	},
	{
		";h",
		Snacks.picker.git_diff,
		desc = "Git Diff (Hunks)",
	},
	{ ";l", Snacks.picker.lines, desc = "Buffer Lines" },
	{ ";m", Snacks.picker.git_status, desc = "Git Status (Modified Files)" },
	{ ";C", Snacks.picker.commands, desc = "Commands" },
	{ ";u", Snacks.picker.undo, desc = "Undo History" },
	{ ";?", Snacks.picker.help, desc = "Help Tags" },
	{
		"]]",
		function()
			Snacks.words.jump(vim.v.count1)
		end,
		desc = "Next Reference",
		mode = { "n", "t" },
	},
	{
		"[[",
		function()
			Snacks.words.jump(-vim.v.count1)
		end,
		desc = "Prev Reference",
		mode = { "n", "t" },
	},
})

-- CodeDiff
map({
	{ "<leader>dv", "<cmd>CodeDiff<cr>", desc = "Toggle CodeDiff" },
	-- File history
	{ "<leader>dh", "<cmd>CodeDiff history %<cr>", desc = "File history (current file)" },
	{ "<leader>dH", "<cmd>CodeDiff history<cr>", desc = "File history (repo)" },
})
