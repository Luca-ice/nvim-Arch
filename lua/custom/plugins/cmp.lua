-- lua/plugins/cmp.lua

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter', -- Load cmp when entering insert mode
  dependencies = {
    -- Required: nvim-cmp sources
    'hrsh7th/cmp-nvim-lsp', -- LSP source
    'hrsh7th/cmp-buffer',   -- Buffer completions
    'hrsh7th/cmp-path',     -- File system path completions
    'saadparwaiz1/cmp_luasnip', -- Snippet completions (if you use luasnip)

    -- Required: Snippet engine (if you use luasnip)
    'L3MON4D3/LuaSnip',
    -- If you use friendly-snippets (highly recommended with luasnip)
    'rafamadriz/friendly-snippets',

    -- Optional: Icons for completion items (if you have nvim-web-devicons)
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local kind_icons = require('nvim-web-devicons').get_icons() or {} -- For icons in completion menu

    -- Setup friendly-snippets (if you use it)
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup {
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        -- If you want to use Tab and Shift-Tab for navigation:
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' }, -- LSP source
        { name = 'luasnip' },  -- Snippets
        { name = 'buffer' },   -- Current buffer words
        { name = 'path' },     -- File system paths
      }),
      -- Customizing the completion item kind icons
      formatting = {
        format = function(entry, vim_item)
          -- Kind icons (optional)
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or '', vim_item.kind) -- This adds the icon

          -- Set max width for items in the completion menu (optional)
          -- vim_item.menu = (entry.source.name == 'nvim_lsp') and '[LSP]' or '[Other]'
          -- vim_item.menu = string.format('[%s]', entry.source.name)

          return vim_item
        end,
      },
    }

    -- Set up completion for command line
    cmp.setup.cmdline('/', {
      sources = cmp.config.sources({
        { name = 'buffer' }
      })
    })

    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' }
      })
    })
  end,
}
