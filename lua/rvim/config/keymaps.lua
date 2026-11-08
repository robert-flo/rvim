local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without updating the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>C", '"_C', { desc = "Change to End of Line" })
keymap.set("v", "<Leader>c", '"_c', { desc = "Change (No Yank)" })
keymap.set("v", "<Leader>C", '"_C', { desc = "Change to End of Line" })
keymap.set("n", "<Leader>D", '"_D', { desc = "Delete to End of Line" })
keymap.set("v", "<Leader>d", '"_d', { desc = "Delete (No Yank)" })
keymap.set("v", "<Leader>D", '"_D', { desc = "Delete to End of Line" })

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Quick save
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Clear search highlights
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Move selected block vertically
keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move block down", silent = true })
keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move block up", silent = true })

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit<CR>")
keymap.set("n", "<tab>", ":tabnext<CR>", opts)
keymap.set("n", "<s-tab>", ":tabprev<CR>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
keymap.set("n", "<Leader>se", "<C-w>=", { desc = "Equalize window splits" })
keymap.set("n", "<Leader>sx", "<cmd>close<CR>", { desc = "Close current split window" })
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

keymap.set("v", "<leader>cc", ":<C-u>lua require('rvim.utils.editor').copy_as_codeblock()<CR>")

keymap.set("n", "<leader>j", function()
	require("rvim.utils.editor").open_package_json()
end, { desc = "Open package.json in floating window" })

keymap.set("n", "<leader>bd", function()
	require("rvim.utils.editor").delete_hidden_buffers()
end, { desc = "Delete hidden buffers" })

-- Session / Restart & Quit
keymap.set("n", "ZR", "<cmd>restart<CR>", { desc = "Reload / Restart Neovim" })
keymap.set("n", "<Leader>za", "<cmd>qa!<CR>", { desc = "Force quit all without saving" })
keymap.set("n", "<Leader>zr", "<cmd>restart<CR>", { desc = "Reload / Restart Neovim" })
keymap.set("n", "<Leader>zR", "<cmd>restart +qall!<CR>", { desc = "Force Restart (Discard Unsaved)" })
