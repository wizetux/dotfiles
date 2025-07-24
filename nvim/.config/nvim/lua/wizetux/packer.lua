-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

vim.g.vimwiki_list = {
            {
            path = '~/vimwiki',
            syntax = 'default',
            ext = '.wiki',
            },
        }
vim.g.vimwiki_global_ext = 0

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.2',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- use 'altercation/vim-colors-solarized'
  use 'craftzdog/solarized-osaka.nvim'

  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = ':TSUpdate'
  }

  use 'mbbill/undotree'
  use 'vimwiki/vimwiki'
  use 'tpope/vim-fugitive'
  use 'neovim/nvim-lspconfig'
  use 'lspcontainers/lspcontainers.nvim'
  use 'nvim-telekasten/calendar-vim'

  use {
    'nvim-telekasten/telekasten.nvim',
    requires = {'nvim-telescope/telescope.nvim'}
  }
end)
