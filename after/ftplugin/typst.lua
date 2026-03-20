-- ┌────────────────────────────────┐
-- │ Typst filetype configuration  │
-- └────────────────────────────────┘
--
-- This file is sourced automatically when opening .typ files

-- Document editing settings
vim.opt_local.wrap = true -- Enable line wrapping for documents
vim.opt_local.linebreak = true -- Break lines at word boundaries
vim.opt_local.breakindent = true -- Preserve indentation in wrapped lines
vim.opt_local.conceallevel = 2 -- Conceal markup for cleaner view
vim.opt_local.spell = true -- Enable spell checking
vim.opt_local.spelllang = "en_us" -- English spell checking (add "fr" if needed)

-- Text width and formatting
vim.opt_local.textwidth = 80 -- Wrap at 80 characters for gq
vim.opt_local.colorcolumn = "" -- Remove color column for documents

-- Indentation
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Typst-specific keybindings (using <Leader>l prefix for language/LSP operations)
local map = vim.keymap.set
local opts = { buffer = true, silent = true }

-- Compile current file
map("n", "<leader>lc", "<cmd>!typst compile %<CR>", vim.tbl_extend("force", opts, { desc = "Compile Typst document" }))

-- Watch current file (compile on save)
map("n", "<leader>lw", function()
	local file = vim.fn.expand("%")
	vim.notify("Starting Typst watch for " .. file, vim.log.levels.INFO)
	vim.fn.jobstart("typst watch " .. vim.fn.shellescape(file), {
		detach = true,
		on_exit = function()
			vim.notify("Typst watch stopped", vim.log.levels.INFO)
		end,
	})
end, vim.tbl_extend("force", opts, { desc = "Watch Typst document" }))

-- Open compiled PDF (assumes same name as .typ file)
map("n", "<leader>lo", function()
	local pdf = vim.fn.expand("%:r") .. ".pdf"
	if vim.fn.filereadable(pdf) == 1 then
		vim.fn.jobstart("xdg-open " .. vim.fn.shellescape(pdf), { detach = true })
	else
		vim.notify("PDF not found: " .. pdf, vim.log.levels.WARN)
	end
end, vim.tbl_extend("force", opts, { desc = "Open compiled PDF" }))
