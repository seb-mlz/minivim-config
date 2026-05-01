local M = {}

M.capture_inbox = function()
	local date = os.date("%Y-%m-%d")
	-- Utilise le chemin absolu vers ton coffre synchronisé
	local inbox_path = vim.fn.expand("~/obsidian/vault/00 - Inbox/")
	local filename = inbox_path .. date .. ".md"

	-- 1. Créer le dossier s'il n'existe pas
	if vim.fn.isdirectory(inbox_path) == 0 then
		vim.fn.mkdir(inbox_path, "p")
	end

	-- 2. Si le fichier n'existe pas, on le crée avec le header
	local f = io.open(filename, "r")
	if f == nil then
		local file = io.open(filename, "w")
		if file then
			file:write("---\n")
			file:write("date: " .. os.date("%Y-%m-%d") .. "\n")
			file:write("tags: #inbox\n")
			file:write("---\n\n")
			file:write("# 📥 Log du " .. date .. "\n\n")
			file:close()
		end
	else
		f:close()
	end

	-- 3. Ouvrir le fichier
	vim.cmd("edit " .. filename)

	-- 4. Aller à la fin du fichier et passer en mode insertion
	-- On ajoute une ligne vide avant pour séparer les entrées
	local last_line = vim.api.nvim_buf_line_count(0)
	vim.api.nvim_buf_set_lines(0, last_line, last_line, false, { "", "## " .. os.date("%H:%M") .. " : " })

	-- Placer le curseur à la fin et passer en mode insertion
	vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 100 })
	vim.cmd("startinsert!")
end

return M
