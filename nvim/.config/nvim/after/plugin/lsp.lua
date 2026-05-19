vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format() end, opts)
  end,
})

vim.lsp.config('bashls', {
  cmd = require'lspcontainers'.command('bashls'),
  filetypes = { 'sh' },
  root_markers = { '.git' },
  before_init = function(params)
    params.processId = vim.NIL
  end,
})

vim.lsp.config('ts_ls', {
  cmd = require'lspcontainers'.command(
    'tsserver',
    {
      cmd_builder = function(runtime, workdir, image, network)
        local dir_basename = string.gsub(vim.fn.system("basename " .. workdir), '\n', '')
        local node_modules_volume = string.gsub(vim.fn.system("docker volume ls | grep '" .. dir_basename .. "_node_modules' | awk '{print $2}'"), '\n', '')

        local cmd = {
          runtime,
          "container",
          "run",
          "--interactive",
          "--rm",
          "--network=" .. network,
          "--workdir=" .. workdir
        }

        if node_modules_volume ~= '' then
          table.insert(cmd, "--volume=" .. node_modules_volume .. ":" .. workdir .. "/node_modules:ro")
        end

        table.insert(cmd, "--volume=" .. workdir .. ":" .. workdir .. ":ro")
        table.insert(cmd, image)

        return cmd
      end,
    }
  ),
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'tsconfig.json', 'package.json', '.git' },
  before_init = function(params)
    params.processId = vim.NIL
  end,
})

vim.lsp.config('kotlin_language_server', {
  cmd = require'lspcontainers'.command('tsserver', {
    image = "kotlin-language-server:latest",
    cmd = function(runtime, volume, image)
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
  filetypes = { 'kotlin' },
  root_markers = { 'settings.gradle', 'settings.gradle.kts', 'build.gradle', 'build.gradle.kts', '.git' },
})

vim.lsp.config('pylsp', {
  cmd = require'lspcontainers'.command('pylsp'),
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
})

vim.lsp.config('gopls', {
  cmd = require'lspcontainers'.command(
    'gopls',
    {
      cmd_builder = function(runtime, workdir, image, network)
        local go_cache_volume_name = string.gsub(vim.fn.system("basename " .. workdir), '\n', '')
        local go_cache_volume = string.gsub(vim.fn.system("docker volume ls | grep '" .. go_cache_volume_name .. "_go_cache' | awk '{print $2}'"), '\n', '')

        local volume = workdir .. ":" .. workdir .. ":z"
        local env = vim.api.nvim_eval('environ()')
        local gopath = env.GOPATH or env.HOME .. "/go"
        local gopath_volume = gopath .. ":" .. gopath .. ":z"

        local group_handle = io.popen("id -g")
        local user_handle = io.popen("id -u")

        local group_id = string.gsub(group_handle:read("*a"), "%s+", "")
        local user_id = string.gsub(user_handle:read("*a"), "%s+", "")

        group_handle:close()
        user_handle:close()

        local user = user_id .. ":" .. group_id

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
          "GOPATH=" .. gopath,
          "--interactive",
          "--network=" .. network,
          "--rm",
          "--workdir=" .. workdir,
          "--volume=" .. volume,
          "--user=" .. user,
        }

        if go_cache_volume ~= '' then
          table.insert(cmd, "--volume=" .. go_cache_volume .. ":" .. gopath .. "/pkg/mod/cache:ro")
        end

        table.insert(cmd, image)
        return cmd
      end,
    }
  ),
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})

vim.lsp.enable({
  'bashls',
  'ts_ls',
  'kotlin_language_server',
  'pylsp',
  'gopls',
})
