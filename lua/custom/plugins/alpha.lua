return {
  'goolord/alpha-nvim',
  -- Loads the plugin when Neovim finishes its initial startup.
  -- This ensures the dashboard is shown immediately upon opening Neovim without a file.
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Customize the ASCII art header
    -- You can generate your own ASCII art (e.g., using patorjk.com/software/taag/)
    -- Adjust the width to fit your terminal comfortably.
    dashboard.section.header.val = {
      ' ██░ ██ ▓█████  ██▓     ██▓     ▒█████      ██▓ ▄████▄  ▓█████ ',
      '▓██░ ██▒▓█   ▀ ▓██▒    ▓██▒    ▒██▒  ██▒   ▓██▒▒██▀ ▀█  ▓█   ▀ ',
      '▒██▀▀██░▒███   ▒██░    ▒██░    ▒██░  ██▒   ▒██▒▒▓█    ▄ ▒███   ',
      '░▓█ ░██ ▒▓█  ▄ ▒██░    ▒██░    ▒██   ██░   ░██░▒▓▓▄ ▄██▒▒▓█  ▄ ',
      '░▓█▒░██▓░▒████▒░██████▒░██████▒░ ████▓▒░   ░██░▒ ▓███▀ ░░▒████▒',
      ' ▒ ░░▒░▒░░ ▒░ ░░ ▒░▓  ░░ ▒░▓  ░░ ▒░▒░▒░    ░▓  ░ ░▒ ▒  ░░░ ▒░ ░',
      ' ▒ ░▒░ ░ ░ ░  ░░ ░ ▒  ░░ ░ ▒  ░  ░ ▒ ▒░     ▒ ░  ░  ▒    ░ ░  ░',
      ' ░  ░░ ░   ░     ░ ░     ░ ░   ░ ░ ░ ▒      ▒ ░░           ░   ',
      ' ░  ░  ░   ░  ░    ░  ░    ░  ░    ░ ░      ░  ░ ░         ░  ░',
      '                                               ░               ',
    }

    -- Define your custom buttons for quick actions
    -- The icons (e.g., 󰈞, ) require a Nerd Font in your terminal.
    dashboard.section.buttons.val = {
      dashboard.button('f', '󰈞  Find File', ':Telescope find_files <CR>'),
      dashboard.button('n', '  New File', ':enew <CR>'),
      dashboard.button('r', '󰋶  Recent Files', ':Telescope oldfiles <CR>'),
      dashboard.button('g', '  Live Grep', ':Telescope live_grep <CR>'),
      -- Assuming your Neovim config is at ~/.config/nvim/init.lua
      dashboard.button('c', '  Config', ':e ~/.config/nvim/ <CR>'),
      dashboard.button('q', '󰐑  Quit', ':qa<CR>'),
    }

    -- Example of adding a custom section (e.g., for recent projects if you use a plugin like 'nvim-project')
    -- You would uncomment and modify this if you have such a plugin
    --[[
      dashboard.section.recent_projects = {
         type = "group",
         val = {
           alpha.button("p", "󰉓  Projects", ":Telescope projects <CR>"), -- Requires a project management plugin like 'nvim-project'
         },
         position = "center",
      }
      ]]
    --

    -- Set any options for the dashboard theme
    dashboard.opts.opts = {
      -- Example: Make the background transparent if your terminal supports it
      -- You might need to set vim.opt.winblend = 0 before alpha.setup if this causes issues
      -- Or just remove this line if you prefer a solid background
      -- backdrop = 0,
    }

    -- Initialize alpha-nvim with the dashboard theme's options
    alpha.setup(dashboard.opts)

    -- Auto-close alpha buffer if a file is opened (e.g., by drag-and-drop or another command)
    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('AlphaClose', { clear = true }),
      callback = function()
        if vim.fn.argc() > 0 then
          vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
            group = 'AlphaClose',
            pattern = '*',
            callback = function()
              -- Check if the buffer is the alpha dashboard
              local bufnr = vim.api.nvim_get_current_buf()
              if vim.bo[bufnr].filetype == 'alpha' then
                -- Safely delete the alpha buffer instead of quitting
                vim.cmd.bdelete(bufnr)
              end
            end,
          })
        end
      end,
    })
  end,
}
