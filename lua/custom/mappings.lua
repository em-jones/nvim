---@type MappingsTable
local M = {}

local tmux_move = function(direction)
  return "<cmd> lua require('tmux').move_" .. direction .. "()<CR>"
end

local ntest_run = "<cmd>lua require('neotest').run.run"
M.general = {
  plugin = false,
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<C-+>"] = { ": lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>" },
    ["<C-_>"] = { ": lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>" },
    ["<C-0>"] = { ": lua vim.g.neovide_scale_factor = 1<CR>" },
    ["<C-->"] = { "<C-w>s", opts = { nowait = true } },
    ["<ctrl-->"] = { "<C-w>s", opts = { nowait = true } },
    ["<C-\\>"] = { "<C-w>v", opts = { nowait = true } },
    ["<C-h>"] = { tmux_move "left", "Window left" },
    ["<C-l>"] = { tmux_move "right", "Window right" },
    ["<C-j>"] = { tmux_move "bottom", "Window down" },
    ["<C-k>"] = { tmux_move "top", "Window up" },
    ["S-A-K"] = { ":vertical resize+1 <CR>" },
  },
}
M.neotest = {
  plugin = true,
  n = {
    ["<leader>rt"] = { ntest_run .. "()<CR>", "Test nearest" },
    ["<leader>rT"] = { ntest_run .. "({strategy='dap'})<CR>", "Debug nearest" },
    ["<leader>Rt"] = { ntest_run .. "({vim.fn.expand('%')})<CR>", "Test file" },
    ["<leader>RT"] = { ntest_run .. "({vim.fn.expand('%'),strategy = 'dap'})<CR>", "Debug file" },
    ["<leader>rr"] = { ntest_run .. "_last()<CR>", "Run last" },
    ["<leader>RR"] = { ntest_run .. "({strategy='dap'})<CR>", "Debug last" },
    ["<leader>rw"] = { "<cmd>lua require('neotest').watch.toggle()<CR>", "Debug last" },
  },
}

M.rest = {
  n = {
    ["<leader>rq"] = {
      "<Plug>RestNvim",
      "Run the request under the cursor",
    },
    ["<leader>rp"] = {
      "<Plug>RestNvimPreview",
      "Preview the request under the cursor",
    },
    ["<leader>rl"] = {
      "<Plug>RestNvimLast",
      "Re-run the last request",
    },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- lsp
    ["<leader>gd"] = { "<cmd>Telescope lsp_definitions<cr>", "goto def" },
    ["<leader>tt"] = { "<cmd>Telescope diagnostics<cr>", "goto def" },
    ["<leader>tr"] = { "<cmd>Telescope lsp_references<cr>", "goto def" },
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
    ["<leader>fs"] = { "<cmd> w <CR>", "Save file" },
    ["<leader>fg"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
    ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "Git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

    ["<leader>ma"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
  },
}

M.rustaceanvim = {
  plugin = true,
  n = {
    -- ["<S-k>"] = { "<cmd>RustLsp hover actions<CR> <cmd>RustLsp hover actions<CR>" }
  },
}

return M
