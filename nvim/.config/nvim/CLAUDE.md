# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using Packer.nvim as the plugin manager. The config follows a modular Lua architecture with a focus on containerized LSP servers and integrated note-taking.

## Key Commands

**Plugin Management (Neovim commands):**
- `:PackerSync` - Install/update all plugins
- `:PackerCompile` - Regenerate packer_compiled.lua after plugin changes

**Treesitter:**
- `:TSUpdate` - Update syntax parsers (auto-runs on plugin install)

## Architecture

**Entry Point:** `init.lua` requires the `wizetux` module.

**Core Configuration (`lua/wizetux/`):**
- `init.lua` - Orchestrator that loads remap → set → packer in order
- `remap.lua` - Keymappings (leader key is `,`)
- `set.lua` - Vim options and settings
- `packer.lua` - Plugin declarations

**Plugin Configuration (`after/plugin/`):**
Files here load after plugins, enabling plugin-specific setup:
- `lsp.lua` - LSP server configurations using lspcontainers (Docker-based)
- `telescope.lua` - Fuzzy finder setup
- `treesitter.lua` - Syntax highlighting parsers
- `telekasten.lua` - Zettelkasten note system with personal/work vaults
- `fugitive.lua` - Git integration
- `autocmds.lua` - Autocommands (yank highlight, etc.)
- `solarized.lua` - Color scheme

**Language-Specific (`ftplugin/` and `after/ftplugin/`):**
- Per-language settings (indentation, paths, syntax checkers)
- `java_getset.vim` - Utility for generating Java getters/setters

**Custom Plugins (`plugin/`):**
- `grep-operator.vim` - Custom `<leader>*` grep operator
- `packer_compiled.lua` - Auto-generated, do not edit

## LSP Architecture

Uses `lspcontainers.nvim` to run language servers in Docker/Podman containers:
- TypeScript (`ts_ls`) - Custom volume mounts for node_modules
- Go (`gopls`) - Handles GOPATH, user/group IDs, caching
- Python (`pylsp`), Kotlin, Bash

The `on_attach` function in `after/plugin/lsp.lua` defines shared keymappings across all servers.

## Key Patterns

**Namespace:** All Lua modules use `wizetux` namespace under `lua/wizetux/`

**Leader Keys:**
- Global: `,` (comma)
- Local: `\` (backslash) for filetype-specific mappings

**Note-Taking:**
- Telekasten vaults at `~/zettelkasten/personal` and `~/zettelkasten/work`
- Vimwiki at `~/vimwiki` with `.wiki` extension

## Dependencies

**Required:** Neovim 0.5+, Packer.nvim (bootstraps itself)

**For LSP containers:** Docker or Podman with language server images

**For Telescope grep:** ripgrep or grep installed
