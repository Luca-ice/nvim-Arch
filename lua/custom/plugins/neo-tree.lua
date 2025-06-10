return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x', -- Make sure to use the correct branch (v3.x for latest)
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- Required for file icons
    'MunifTanjim/nui.nvim', -- Required for UI components
    -- Optional: If you want git signs in your neo-tree
    -- 'sindrets/diffview.nvim',
    -- 'nvim-lua/plenary.nvim',
  },
  config = function()
    require('neo-tree').setup {
      -- Customize your neo-tree settings here
      window = {
        position = 'left', -- or 'right', 'float'
        width = 30, -- Adjust width as desired
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
      filesystem = {
        filtered_items = {
          visible = true, -- Show hidden files (dotfiles) by default
          hide_dotfiles = false, -- Set to false to always show dotfiles
          hide_git_ignored = true,
          hide_hidden = true, -- Applies to OS hidden files, not necessarily dotfiles
        },
        -- Further filesystem options
      },
      default_component_configs = {
        -- Set custom icons or disable components
        container = {
          enable_character_border = false, -- LazyVim doesn't use these borders
        },
        git_status = {
          symbols = {
            -- Customize git status symbols
            added = '●', -- or "A"
            modified = '●', -- or "M"
            deleted = '✖', -- or "D"
            renamed = '➜', -- or "R"
            untracked = '', -- or "U"
            ignored = '◌', -- or "I"
            unstaged = '!', -- or "U"
            staged = '✓', -- or "✓"
            staged_deleted = '⌫', -- or "⌫"
          },
        },
        -- Add other component configurations as needed (e.g., for icons, diagnostics)
      },
      -- You can add custom commands or integrations here
      -- For example, custom commands to open specific files, etc.
    }

    -- Set up keybindings
    -- These are common keybinds similar to LazyVim
    vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree File Explorer' })
    vim.keymap.set('n', '<leader>E', ':Neotree focus<CR>', { desc = 'Focus Neo-tree' })
    -- Add more keybinds if you want:
    -- vim.keymap.set('n', '<leader>gc', ':Neotree float git_status<CR>', { desc = 'Toggle Git Status' })
  end,
}
