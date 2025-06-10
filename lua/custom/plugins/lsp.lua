-- lua/plugins/lspconfig.lua (or lsp.lua)
return {
  -- nvim-lspconfig is the core plugin for Neovim's built-in LSP client
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Required for completion capabilities to be passed correctly to LSP servers
    'hrsh7th/cmp-nvim-lsp',
    -- You might have other LSP-related dependencies here, e.g., mason.nvim, lsp-zero, etc.
    -- If you use mason.nvim for managing LSP servers, ensure it's also loaded:
    -- 'williamboman/mason.nvim',
    -- 'williamboman/mason-lspconfig.nvim',
  },
  -- The 'config' function runs after the plugin is loaded
  config = function()
    local lspconfig = require 'lspconfig'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- This function will be called every time an LSP client attaches to a buffer.
    -- It's a good place to set up buffer-local keymaps for LSP actions.
    local on_attach = function(client, bufnr)
      -- Set keymaps for LSP actions
      local buf_set_keymap = vim.api.nvim_buf_set_keymap
      local opts = { noremap = true, silent = true }

      -- Diagnostics
      buf_set_keymap(bufnr, 'n', '[g', '<cmd>vim.diagnostic.goto_prev()<CR>', { desc = 'Go to previous diagnostic' })
      buf_set_keymap(bufnr, 'n', ']g', '<cmd>vim.diagnostic.goto_next()<CR>', { desc = 'Go to next diagnostic' })
      buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>vim.diagnostic.open_float()<CR>', { desc = 'Show buffer diagnostics' })
      buf_set_keymap(bufnr, 'n', '<leader>d', '<cmd>vim.diagnostic.show_line_diagnostics()<CR>', { desc = 'Show line diagnostics' })

      -- LSP actions
      buf_set_keymap(bufnr, 'n', 'gd', '<cmd>vim.lsp.buf.definition()<CR>', { desc = 'Go to definition' })
      buf_set_keymap(bufnr, 'n', 'gD', '<cmd>vim.lsp.buf.declaration()<CR>', { desc = 'Go to declaration' })
      buf_set_keymap(bufnr, 'n', 'gr', '<cmd>vim.lsp.buf.references()<CR>', { desc = 'Go to references' })
      buf_set_keymap(bufnr, 'n', 'gi', '<cmd>vim.lsp.buf.implementation()<CR>', { desc = 'Go to implementation' })
      buf_set_keymap(bufnr, 'n', 'K', '<cmd>vim.lsp.buf.hover()<CR>', { desc = 'Show hover documentation' })
      buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>vim.lsp.buf.rename()<CR>', { desc = 'Rename symbol' })
      buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>vim.lsp.buf.code_action()<CR>', { desc = 'Code actions' })

      -- Formatting (Using LSP client's formatting capability)
      -- Note: If you're using 'conform.nvim' for formatting, you might remove these LSP format keymaps
      -- as conform will handle it (especially with format_on_save).
      -- If you still want LSP-driven formatting, keep these.
 vim.keymap.set('n', '<leader>fm', function()
        vim.lsp.buf.format({ async = true })
      end, { buffer = bufnr, desc = 'Format buffer with LSP' })
	buf_set_keymap(bufnr, 'v', '<leader>fm', '<cmd>vim.lsp.buf.format({ async = true })<CR>', { desc = 'Format selection with LSP' })

      -- Autoformat on save (optional, but convenient)
      -- If you use conform.nvim's format_on_save, you likely won't need this.
      -- vim.cmd [[ autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true }) ]]
    end

    -- TypeScript Language Server (ts_ls)
    lspconfig.ts_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      -- init_options should be directly here, NOT inside 'settings'
      init_options = {
        disableAutomaticTypeAcquisition = true,
        -- You might also want to explicitly disable its built-in formatter if conform.nvim handles it
        -- plugins = {
        --     {
        --         name = "@typescript/tslint-plugin",
        --         enable = false,
        --     },
        -- },
      },
      settings = { -- This 'settings' table is for the language server's own config.
        typescript = {
          format = {
            semicolons = 'insert',
          },
        },
        javascript = {
          format = {
            semicolons = 'insert',
          },
        },
      },
    }

    -- PHP Language Server (intelephense)
    lspconfig.intelephense.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        intelephense = {
          -- If you purchased a license for Intelephense, uncomment and add it here:
          -- licenseKey = "YOUR_LICENSE_KEY",
          stubs = {
            'Core', 'curl', 'date', 'dom', 'json', 'libxml', 'mbstring',
            'mysqli', 'pcre', 'pdo', 'Phar', 'Reflection', 'session',
            'SimpleXML', 'SPL', 'standard', 'tokenizer', 'xml', 'xmlreader',
            'xmlwriter', 'zip', 'zlib', 'filter', 'hash', 'iconv',
            -- Add more as needed, e.g., "wordpress", "laravel", etc.
          },
          -- This setting tells Intelephense to defer formatting to the client (Neovim/Prettier)
          format = {
            enable = false, -- Disable Intelephense's built-in formatter if you use Prettier
          },
        },
      },
    }

    -- General diagnostic configuration
    vim.diagnostic.config {
      virtual_text = {
        enabled = true,
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = 'rounded',
        header = '',
        prefix = '',
      },
    }
  end,
}
