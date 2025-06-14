-- lua/plugins/lsp.lua (or lspconfig.lua, ensure this file is sourced by your plugin manager)
return {
	-- nvim-lspconfig is the core plugin for Neovim's built-in LSP client
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Required for completion capabilities to be passed correctly to LSP servers
		'hrsh7th/cmp-nvim-lsp',
		-- Mason.nvim for managing LSP servers, linters, formatters
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim', -- Connects mason to lspconfig
		-- You might have other LSP-related dependencies here, e.g., for UI or extra features
		-- 'j-hui/fidget.nvim', -- Optional: A UI for LSP progress
	},
	-- The 'config' function runs after the plugin is loaded
	config = function()
		local lspconfig = require 'lspconfig'
		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		local mason_lspconfig = require 'mason-lspconfig'

		-- This function will be called every time an LSP client attaches to a buffer.
		-- It's a good place to set up buffer-local keymaps for LSP actions.
		local on_attach = function(client, bufnr)
			-- Set keymaps for LSP actions
			local buf_set_keymap = vim.api.nvim_buf_set_keymap

			-- Diagnostics (using buffer-local keymaps)
			buf_set_keymap(bufnr, 'n', '[d', '<cmd>vim.diagnostic.goto_prev()<CR>',
				{ desc = 'Go to previous diagnostic' })
			buf_set_keymap(bufnr, 'n', ']d', '<cmd>vim.diagnostic.goto_next()<CR>',
				{ desc = 'Go to next diagnostic' })
			buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>vim.diagnostic.open_float()<CR>',
				{ desc = 'Show buffer diagnostics (float)' })
			buf_set_keymap(bufnr, 'n', '<leader>d', '<cmd>vim.diagnostic.show_line_diagnostics()<CR>',
				{ desc = 'Show line diagnostics' })

			-- LSP actions (using buffer-local keymaps)
			buf_set_keymap(bufnr, 'n', 'gd', '<cmd>vim.lsp.buf.definition()<CR>',
				{ desc = 'Go to definition' })
			buf_set_keymap(bufnr, 'n', 'gD', '<cmd>vim.lsp.buf.declaration()<CR>',
				{ desc = 'Go to declaration' })
			buf_set_keymap(bufnr, 'n', 'gr', '<cmd>vim.lsp.buf.references()<CR>',
				{ desc = 'Go to references' })
			buf_set_keymap(bufnr, 'n', 'gi', '<cmd>vim.lsp.buf.implementation()<CR>',
				{ desc = 'Go to implementation' })
			buf_set_keymap(bufnr, 'n', 'K', '<cmd>vim.lsp.buf.hover()<CR>',
				{ desc = 'Show hover documentation' })
			buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>vim.lsp.buf.rename()<CR>',
				{ desc = 'Rename symbol' })
			buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>vim.lsp.buf.code_action()<CR>',
				{ desc = 'Code actions' })
			buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>vim.lsp.buf.add_workspace_folder()<CR>',
				{ desc = 'Add workspace folder' })
			buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>vim.lsp.buf.remove_workspace_folder()<CR>',
				{ desc = 'Remove workspace folder' })
			buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>vim.lsp.buf.list_workspace_folders()<CR>',
				{ desc = 'List workspace folders' })

			-- Formatting (Using LSP client's formatting capability)
			vim.keymap.set('n', '<leader>fm', function()
				vim.lsp.buf.format({ async = true })
			end, { buffer = bufnr, desc = 'Format buffer with LSP' })
			vim.keymap.set('v', '<leader>fm', '<cmd>vim.lsp.buf.format({ async = true })<CR>',
				{ buffer = bufnr, desc = 'Format selection with LSP' })

			-- Set up a command for restarting the LSP server
			buf_set_keymap(bufnr, 'n', '<leader>rs', '<cmd>LspRestart<CR>', { desc = 'Restart LSP server' })
		end

		-- Setup mason.nvim first
		require('mason').setup({
			ensure_installed = {
				-- other tools like 'lua-language-server'...
				'prettier', -- Add this to install prettier
			},
		})

		-- Then setup mason-lspconfig to automatically configure installed LSPs
		mason_lspconfig.setup {
			-- A list of servers to ensure are installed by Mason and then configured by lspconfig
			-- IMPORTANT: These MUST be the lspconfig server names (e.g., 'tsserver', not 'typescript-language-server')
			ensure_installed = {
				"intelephense", -- For PHP
				"ts_ls", -- For TypeScript/JavaScript (lspconfig name)
				-- Add any other language servers you want Mason to install and manage here.
			},
			automatic_installation = true, -- Set to true to automatically install servers if missing
			automatic_enable = true, -- Set to true to automatically install servers if missing

			-- This callback runs for every server configured by mason-lspconfig
			handlers = {
				-- Default handler for all servers that don't have a specific override.
				function(server_name)
					lspconfig[server_name].setup {
						on_attach = on_attach,
						capabilities = capabilities,
					}
				end,

				-- Override for intelephense if you have specific settings
				intelephense = function()
					lspconfig.intelephense.setup {
						on_attach = on_attach,
						capabilities = capabilities,
						root_dir = lspconfig.util.root_pattern(
							".git" -- Add your own specific markers if needed
						),
						settings = {
							intelephense = {
								-- licenseKey = "YOUR_LICENSE_KEY",
								-- php = { executable = { path = '/usr/bin/php' }, },
								stubs = {
									'Core', 'curl', 'date', 'dom', 'json', 'libxml', 'mbstring',
									'mysqli', 'pcre', 'pdo', 'Phar', 'Reflection', 'session',
									'SimpleXML', 'SPL', 'standard', 'tokenizer', 'xml', 'xmlreader',
									'xmlwriter', 'zip', 'zlib', 'filter', 'hash', 'iconv',
								},
								format = { enable = false, },
							},
						},
					}
				end,

				-- Override for tsserver (TypeScript Language Server)
				-- IMPORTANT: This key MUST be the lspconfig server name, which is 'tsserver'
				ts_ls = function() -- This is correct, it's the lspconfig name
					lspconfig.ts_ls.setup {
						on_attach = on_attach,
						capabilities = capabilities,
						init_options = {
							disableAutomaticTypeAcquisition = true,
						},
						settings = {
							javascript = {
								format = {
									semicolons = 'insert',
								},
							},
							typescript = {
								format = {
									semicolons = 'insert',
								},
							},
						},
					}
				end,
			}
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
