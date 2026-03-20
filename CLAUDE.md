# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration built primarily on **mini.nvim**, a collection of small, independent Lua modules. The config is called "MiniMax" and provides a polished, feature-rich Neovim experience with minimal dependencies.

## Project Structure

```
├ init.lua          Initial file executed during startup
├ plugin/           Files automatically sourced during startup
├── 10_options.lua  Built-in Neovim behavior (options and diagnostics)
├── 20_keymaps.lua  Custom mappings (general and Leader key mappings)
├── 30_mini.lua     MINI module configurations
├── 40_plugins.lua  Non-MINI plugins (LSP, tree-sitter, formatters, etc.)
├ snippets/         User-defined snippets (global.json for all filetypes)
├ after/            Override behavior added by plugins
├── ftplugin/       Filetype-specific behavior (php.lua, vue.lua, markdown.lua)
├── lsp/            LSP server configurations (lua_ls.lua, phpactor.lua, etc.)
├── snippets/       Higher priority snippet files
├ lua/              Custom Lua modules and commands
├── modules/        Custom functionality modules (i18n.lua)
├── commands/       Custom Neovim commands (i18n.lua)
```

## Key Architecture Concepts

### Plugin Management
- Uses **mini.deps** as the plugin manager
- Plugins are loaded in two stages:
  - `now()` - immediate loading for critical startup functionality
  - `later()` - deferred loading after first screen draw for better startup performance
  - `now_if_args()` - loads immediately only if Neovim is started with file arguments

### Configuration Philosophy
- **Leader key** is `<Space>` (defined in 10_options.lua)
- **Two-key Leader mappings**: First key = semantic group, second key = action
  - `<Leader>f` - Find/fuzzy operations (files, grep, help, etc.)
  - `<Leader>e` - Explore/Edit config files
  - `<Leader>b` - Buffer operations
  - `<Leader>g` - Git operations
  - `<Leader>l` - Language/LSP operations
  - `<Leader>s` - Session management
  - `<Leader>v` - Visits (file tracking)
  - `<Leader>m` - Map (mini.map)
  - `<Leader>t` - Terminal
  - `<Leader>o` - Other utilities

### Global Config Table
- `_G.Config` table stores shared state between scripts
- `_G.Config.new_autocmd(event, pattern, callback, desc)` - helper to create autocommands in the custom group

## Language Support

### LSP Servers (configured in plugin/40_plugins.lua)
Currently enabled servers:
- `lua_ls` - Lua
- `vue_ls` - Vue.js
- `vtsls` - TypeScript/JavaScript
- `phpactor` - PHP
- `tailwindcss` - Tailwind CSS
- `emmet_language_server` - Emmet
- `vimfony` - Symfony (PHP framework)
- `pyright` - Python

LSP server configurations can be customized in `after/lsp/<server_name>.lua` files.

### Linting (nvim-lint)
- Vue: `eslint_d`
- PHP: `phpstan`

Configured to run on `BufEnter`, `BufWritePost`, and `InsertLeave`.

### Formatting (conform.nvim)
- Lua: `stylua`
- Vue/TypeScript/JavaScript: `eslint_d`
- PHP: `php-cs-fixer`
- **Format on save** is enabled with 600ms timeout
- Uses LSP as fallback when dedicated formatter unavailable

## Custom Utilities

### i18n Translation Manager
Custom utility for managing internationalization files. Located in `lua/modules/i18n.lua` and `lua/commands/i18n.lua`.

**User Commands:**
- `:I18nAdd [key]` - Add new translation key (prompts for French and English translations)
- `:I18nUpdate [key]` - Update existing translation key
- `:I18nList` - Display all translation keys in popup
- `:I18nValidate` - Validate JSON files
- `:I18nSort` - Sort JSON files alphabetically

**Configuration:**
- Default i18n directory: `i18n/lang`
- Languages: `fr`, `en`
- Backend script: `~/.config/minivim/lua/scripts/i18n-manager.js` (uses Bun runtime)
- Project root detection: searches for `package.json`, `nuxt.config.js/ts`, or `.git`

## Important MINI Modules

Key modules to understand:
- **mini.pick** - Fuzzy finder (files, grep, buffers, git, LSP symbols)
- **mini.files** - File explorer with column view (Miller columns)
- **mini.completion** - Two-stage async completion (LSP + fallback)
- **mini.diff** - Git diff visualization with hunks
- **mini.git** - Git integration (show info, diff, log)
- **mini.ai** - Extended textobjects (function, argument, buffer, etc.)
- **mini.surround** - Add/delete/replace surroundings
- **mini.snippets** - Snippet management (expand with `<C-j>`, navigate with `<C-l>`/`<C-h>`)

## Common Workflows

### Editing Config Files
- `<Space>ei` - Edit init.lua
- `<Space>eo` - Edit options (10_options.lua)
- `<Space>ek` - Edit keymaps (20_keymaps.lua)
- `<Space>em` - Edit MINI config (30_mini.lua)
- `<Space>ep` - Edit plugins (40_plugins.lua)

### File Operations
- `<Space>ed` - Open file explorer at cwd
- `<Space>ef` - Open file explorer at current file directory
- `<Space>ff` - Find files (requires ripgrep for best performance)
- `<Space>fg` - Live grep in files (requires ripgrep)
- `<Space>fb` - Pick from buffers

### LSP Operations
- `<Space>la` - Code actions
- `<Space>ls` - Go to definition
- `<Space>lr` - Rename symbol
- `<Space>lf` - Format code (uses conform.nvim)
- `<Space>ld` - Show diagnostics in popup
- `<Space>fS` - Find document symbols
- `<Space>fs` - Find workspace symbols

### Git Operations
- `<Space>gg` - Open LazyGit
- `<Space>gs` - Show git info at cursor
- `<Space>go` - Toggle diff overlay
- `<Space>gd` - Show unstaged diff
- `<Space>ga` - Show staged diff
- `<Space>gl` - Git log
- `<Space>fc` - Pick from commits

## Installation & Updates

### Plugin Management
- `:DepsUpdate` - Update all plugins
- `:DepsSnapSave` - Save snapshot of current plugin versions
- Mason is available for installing LSP servers, formatters, and linters (`:Mason`)

### First Time Setup
On first run, `mini.nvim` is automatically bootstrapped via git clone. Tree-sitter parsers for Lua, vimdoc, and markdown are pre-configured but need to be added to the `languages` table in `plugin/40_plugins.lua` for additional languages.

## File Type Specific Notes

### PHP
- LSP: phpactor + vimfony (Symfony support)
- Linter: phpstan
- Formatter: php-cs-fixer
- Custom config in `after/ftplugin/php.lua`

### Vue/TypeScript
- LSP: vue_ls + vtsls
- Linter/Formatter: eslint_d
- Tailwind CSS support enabled
- Custom config in `after/ftplugin/vue.lua`

### Markdown
- Custom filetype config in `after/ftplugin/markdown.lua`

## Development Notes

### Adding New LSP Server
1. Install the LSP server (manually or via Mason)
2. Add server name to `vim.lsp.enable()` call in `plugin/40_plugins.lua`
3. (Optional) Create `after/lsp/<server_name>.lua` for custom configuration

### Adding Custom Modules
1. Create module file in `lua/modules/<name>.lua`
2. Create command file in `lua/commands/<name>.lua` (if needed)
3. Require in `plugin/40_plugins.lua` within a `later()` block

### Tree-sitter Languages
Add language parsers by:
1. Adding language to `languages` table in `plugin/40_plugins.lua`
2. Running `:TSUpdate` (happens automatically via post_checkout hook)

## Color Scheme

Currently using **catppuccin-frappe**. Alternative mini.hues-based schemes available:
- miniwinter (default mini.nvim scheme)
- minispring, minisummer, miniautumn
- randomhue

Change in `plugin/40_plugins.lua`.
