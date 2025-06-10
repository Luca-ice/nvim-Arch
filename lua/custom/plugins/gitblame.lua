return {
  -- f-person/git-blame.nvim for inline blame virtual text
  {
    'f-person/git-blame.nvim',
    event = 'BufReadPost', -- Load only when a buffer is read
    opts = {
      enabled = true, -- Enable by default
      message_template = " <author> • <date> • <summary>", -- Customize the blame message format
      date_format = "%r", -- Relative date (e.g., "3 days ago")
      highlight_group = "Comment", -- Use a default highlight group, we'll fade it
      virtual_text_column = 120, -- Start virtual text at this column. Adjust as needed.
                                 -- If line is longer, it will appear at EOL.
      -- To make it "fade", you primarily target its highlight group.
      -- The plugin itself doesn't have a 'blend' option, so you rely on Neovim's HL.
    },
    keys = {
      { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
    },
  },
}
