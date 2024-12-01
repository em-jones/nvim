local autocmd = vim.api.nvim_create_autocmd
-- autocmd("BufEnter", {
--   filetypes = { "sql", "mysql", "plsql" },
--   command = require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } },
-- })

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
vim.opt.relativenumber = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 5
vim.diagnostic.config { virtual_text = false }

-- vim.api.nvim_create_autocmd({ "LspAttach", "CursorHold" }, {
--   callback = function()
--     vim.diagnostic.open_float()
--   end,
-- })
vim.cmd [[imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")]]
vim.g.copilot_no_tab_map = true
