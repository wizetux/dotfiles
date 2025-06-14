util = require 'lspconfig/util'

local opts = { noremap=true, silent=true }
 -- Use an on_attach function to only map the following keys
 -- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
   -- Enable completion triggered by <c-x><c-o>
   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
 
   -- Mappings.
   -- See `:help vim.lsp.*` for documentation on any of the below functions
   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- require'lspconfig'.lua_ls.setup {
--   cmd = require'lspcontainers'.command('sumneko_lua'),
--   }

require'lspconfig'.bashls.setup {
  before_init = function(params)
    params.processId = vim.NIL
  end,
  cmd = require'lspcontainers'.command('bashls'),
  root_dir = util.root_pattern(".git", vim.fn.getcwd())
}

require('telescope').setup { 
  defaults = { 
    file_ignore_patterns = {"%.class"}
  }
}

require'lspconfig'.ts_ls.setup {
  before_init = function(params)
    params.processId = vim.NIL
  end,
  on_attach = on_attach,
  cmd = require'lspcontainers'.command(
    'tsserver',
    {
        cmd_builder = function (runtime, workdir, image, network)
          local dir_basename = string.gsub(vim.fn.system("basename "..workdir), '\n', '')
          local node_modules_volume = string.gsub(vim.fn.system("docker volume ls | grep '"..dir_basename.."_node_modules' | awk '{print $2}'"), '\n', '')

          local cmd = {
            runtime,
            "container",
            "run",
            "--interactive",
            "--rm",
            "--network="..network,
            "--workdir="..workdir
            }

          if node_modules_volume ~= '' then
            table.insert(cmd, "--volume="..node_modules_volume..":"..workdir.."/node_modules:ro")
          end

          table.insert(cmd, "--volume="..workdir..":"..workdir..":ro")
          table.insert(cmd, image)

          return cmd
        end,
    }
  ),
  root_dir = util.root_pattern(".git", vim.fn.getcwd()),
}

require'lspconfig'.kotlin_language_server.setup {
  on_attach = on_attach,
  cmd = require'lspcontainers'.command('tsserver', {
    image = "kotlin-language-server:latest",
    cmd = function (runtime, volume, image)
      return {
        runtime,
        "container",
        "run",
        "--name",
        "kotlin_language_server",
        "--interactive",
        "--rm",
        "--volume",
        volume .. ":" .. volume .. ":ro",
        image
      }
    end,
  }),
}

require'lspconfig'.pylsp.setup {
  cmd = require'lspcontainers'.command('pylsp')
}

require'lspconfig'.gopls.setup {
  on_attach = on_attach,
  cmd = require'lspcontainers'.command(
    'gopls',
    {
        cmd_builder = function (runtime, workdir, image, network)
          local go_cache_volume_name = string.gsub(vim.fn.system("basename "..workdir), '\n', '')
 
          local go_cache_volume = string.gsub(vim.fn.system("docker volume ls | grep '"..go_cache_volume_name.."_go_cache' | awk '{print $2}'"), '\n', '')

          local volume = workdir..":"..workdir..":z"
          local env = vim.api.nvim_eval('environ()')
          local gopath = env.GOPATH or env.HOME.."/go"
          local gopath_volume = gopath..":"..gopath..":z"

          local group_handle = io.popen("id -g")
          local user_handle = io.popen("id -u")

          local group_id = string.gsub(group_handle:read("*a"), "%s+", "")
          local user_id = string.gsub(user_handle:read("*a"), "%s+", "")

          group_handle:close()
          user_handle:close()

          local user = user_id..":"..group_id

          if runtime == "docker" then
            network = "bridge"
          elseif runtime == "podman" then
        network = "slirp4netns"
          end

          local cmd = {
            runtime,
            "container",
            "run",
            "--env",
            "GOPATH="..gopath,
            "--interactive",
            "--network="..network,
            "--rm",
            "--workdir="..workdir,
            "--volume="..volume,
            "--user="..user,
          }

          if go_cache_volume ~= '' then
            table.insert(cmd, "--volume="..go_cache_volume..":" ..gopath.."/pkg/mod/cache:ro")
          end

          table.insert(cmd, image)
          return cmd
        end,
    }
  ),
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
}
