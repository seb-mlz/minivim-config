-- File: after/ftplugin/vue.lua
-- These keymaps will ONLY be active in Vue buffers.

-- Helper to create buffer-local keymaps
local nmap_leader = function(suffix, rhs, desc)
	-- { buffer = true } is the most important part!
	vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc, buffer = true })
end

-- Add a new leader group for `mini.clue`
-- This makes '<Leader>i' show up as '+i18n'
table.insert(_G.Config.leader_group_clues, {
	mode = "n",
	keys = "<Leader>i",
	desc = "+i18n",
})

-- Your i18n keymaps
nmap_leader("ia", ":I18nAdd<CR>", "i18n: [A]dd")
nmap_leader("iu", ":I18nUpdate<CR>", "i18n: [U]pdate")
nmap_leader("il", ":I18nList<CR>", "i18n: [L]ist")
nmap_leader("iv", ":I18nValidate<CR>", "i18n: [V]alidate")
nmap_leader("is", ":I18nGoto<CR>", "i18n: Go to [S]ource")

-- You can add any other Vue-specific settings her
