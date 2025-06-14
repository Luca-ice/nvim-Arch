-- lua/plugins/init.lua (or the file that lazy.nvim imports for your plugins)

return {
	'stevearc/conform.nvim',
	event = 'BufWritePre', -- Load only when you save a buffer
	cmd = 'Conform',
	config = function()
		require('conform').setup {
			-- By removing the 'format_on_save' table, we disable automatic formatting.
			formatters_by_ft = {
				typescript = { 'prettier' },
				javascript = { 'prettier' },
				typescriptreact = { 'prettier' },
				javascriptreact = { 'prettier' },
				json = { 'prettier' },
				jsonc = { 'prettier' },
				yaml = { 'prettier' },
				markdown = { 'prettier' },
				php = { "none" }, -- Keep this from our last conversation to prevent LSP formatting
			},
		}

		-- Keymap to format the entire buffer in NORMAL mode
		vim.keymap.set({ 'n' }, '<leader>fm', function()
			require('conform').format { async = true, lsp_fallback = true }
		end, { desc = 'Format buffer' })

		-- Keymap to format a visual selection in VISUAL mode
		vim.keymap.set({ 'v' }, '<leader>fv', function()
			require('conform').format { async = true, lsp_fallback = true }
		end, { desc = 'Format selected text' })
	end,
}
