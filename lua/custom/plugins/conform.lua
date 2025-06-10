-- lua/plugins/init.lua (or the file that lazy.nvim imports for your plugins)

return {
    -- ... other plugins you have ...

    -- This is the crucial part for conform.nvim
    {
        'stevearc/conform.nvim',
        -- This 'lazy = false' ensures it loads on startup for easier debugging.
        -- For production, you might want to use 'event = { "BufWritePre" }'
        -- or 'cmd = { "ConformInfo", "ConformFormat" }'
        lazy = false,
        -- The 'config' function is where your provided setup code goes.
        config = function()
            local conform = require 'conform'

            conform.setup {
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
                formatters_by_ft = {
                    typescript = { 'prettier' },
                    javascript = { 'prettier' },
                    typescriptreact = { 'prettier' },
                    javascriptreact = { 'prettier' },
                    json = { 'prettier' },
                    jsonc = { 'prettier' },
                    yaml = { 'prettier' },
                    markdown = { 'prettier' },
                    -- Add PHP if you installed a PHP formatter like php-cs-fixer and want to use it with conform
                    -- php = { "php_cs_fixer" },
                },
            }

            -- Your manual format keymap also goes here
            vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
                conform.format {
                    lsp_fallback = true,
                    async = true,
                    timeout_ms = 1000,
                }
            end, { desc = 'Format buffer with Conform' })
        end,
    },

    -- ... potentially more plugins ...
}
