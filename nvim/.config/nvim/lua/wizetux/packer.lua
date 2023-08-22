-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.2',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
	  'altercation/vim-colors-solarized',
	  as = 'solarized',
	  config = function()
		  vim.cmd.colorscheme('solarized')
	  end
  }

  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = ':TSUpdate'
  }

  use 'mbbill/undotree'
  use 'vimwiki/vimwiki'
  use 'tpope/vim-fugitive'
  use 'tomtom/tcomment_vim'
  use 'neovim/nvim-lspconfig'
  use 'lspcontainers/lspcontainers.nvim'
end)
