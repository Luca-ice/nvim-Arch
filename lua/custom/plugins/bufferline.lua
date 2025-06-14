-- lua/custom/plugins/bufferline.lua
return {
	'akinsho/bufferline.nvim',
	dependencies = 'nvim-tree/nvim-web-devicons', -- Required for file icons
	version = '*',                         -- Use newest stable version
	config = function()
		require('bufferline').setup {
			options = {
				mode = 'buffers',
				separator_style = 'slant',
				always_show_bufferline = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				diagnostics = 'nvim_lsp', -- Show LSP diagnostics (errors/warnings)

				offsets = {
					{
						filetype = 'neo-tree',
						text = 'File Explorer',
						text_align = 'left',
						separator = true,
					},
				},
				sort_by = 'insert_after_current',
			},
			highlights = {
				buffer_selected = {
					fg = { attribute = 'fg', highlight = 'Normal' },
					bg = { attribute = 'bg', highlight = 'Normal' },
					bold = true,
				},
			},
		}

		-- Set up keybindings for bufferline
		vim.keymap.set('n', '<leader>bh', ':BufferLineCyclePrev<CR>', { desc = 'Cycle to previous buffer' })
		vim.keymap.set('n', '<leader>bl', ':BufferLineCycleNext<CR>', { desc = 'Cycle to next buffer' })
		vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { desc = 'Pick buffer from list' })
		vim.keymap.set('n', '<leader>bc', '<cmd>bd<CR>', { desc = 'Close current buffer' })
		vim.keymap.set('n', '<leader>bO', ':BufferLineCloseOthers<CR>', { desc = 'Close all other buffers' })
		vim.keymap.set('n', '<leader>bL', ':BufferLineCloseLeft<CR>', { desc = 'Close buffers to the left' })
		vim.keymap.set('n', '<leader>bR', ':BufferLineCloseRight<CR>', { desc = 'Close buffers to the right' })
		vim.keymap.set('n', '<C-1>', ':BufferLineGoToBuffer 1<CR>', { desc = 'Go to Buffer 1' })
		vim.keymap.set('n', '<C-2>', ':BufferLineGoToBuffer 2<CR>', { desc = 'Go to Buffer 2' })
		vim.keymap.set('n', '<C-3>', ':BufferLineGoToBuffer 3<CR>', { desc = 'Go to Buffer 3' })
		vim.keymap.set('n', '<C-4>', ':BufferLineGoToBuffer 4<CR>', { desc = 'Go to Buffer 4' })
		vim.keymap.set('n', '<C-5>', ':BufferLineGoToBuffer 5<CR>', { desc = 'Go to Buffer 5' })
		vim.keymap.set('n', '<C-6>', ':BufferLineGoToBuffer 6<CR>', { desc = 'Go to Buffer 6' })
		vim.keymap.set('n', '<C-7>', ':BufferLineGoToBuffer 7<CR>', { desc = 'Go to Buffer 7' })
		vim.keymap.set('n', '<C-8>', ':BufferLineGoToBuffer 8<CR>', { desc = 'Go to Buffer 8' })
		vim.keymap.set('n', '<C-9>', ':BufferLineGoToBuffer 9<CR>', { desc = 'Go to Buffer 9' })
	end,
}
