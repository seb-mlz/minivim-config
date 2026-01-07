-- File: after/lsp/vimfony.lua
--
-- This config will only be loaded by `vim.lsp.enable`
-- if a .git directory is found in the project root.

local git_root = vim.fs.root(0, ".git")

-- Do not start vimfony if we are not in a git repository
if git_root == nil then
	return {
		autostart = false,
	}
end

-- Return the config table for nvim-lspconfig
return {
	cmd = { "vimfony" },
	filetypes = { "php", "twig", "yaml", "xml" },
	root_dir = git_root,
	single_file_support = true,
	init_options = {
		roots = { "templates" },
		container_xml_path = (git_root .. "/var/cache/dev/App_KernelDevDebugContainer.xml"),
		vendor_dir = git_root .. "/vendor",
		-- Optional:
		-- php_path = "/usr/bin/php",
	},
}
