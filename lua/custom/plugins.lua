local overrides = require "custom.configs.overrides"
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
---@type NvPluginSpec[]
---
local plugins = {

  -- Override plugin definition options
  {
    "evanleck/vim-svelte",
    ft = { "svelte" },
    dependencies = { "pangloss/vim-javascript", "othree/html5.vim" },
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {}
    end,
  },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup {
        auto_load = true,
        close_on_bdelete = true,
        syntax = false,
        update_on_change = true,
        app = "browser",
        filetype = { "markdown" },
      }
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "michaelb/sniprun",
    build = "sh install.sh",
    lazy = false,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    lazy = false,
    config = function(_, opts)
      local rainbow_delimiters = require "rainbow-delimiters"
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require "elixir"
      local elixirls = require "elixir.elixirls"

      elixir.setup {
        nextls = { enable = false },
        credo = { enable = false },
        elixirls = {
          cmd = "/home/em/.local/share/nvim/mason/bin/elixir-ls",
          enable = true,
          settings = elixirls.settings {
            dialyzerEnabled = true,
            enableTestLenses = true,
            suggestSpecs = false,
          },
        },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "gleam-lang/gleam.vim",
  },
  {
    "ionide/Ionide-vim",
    ft = { "fsharp" },
    config = function()
      require("ionide").setup {}
    end,
  },
  {
    "jmederosalvarado/roslyn.nvim",
    ft = { "csharp", "cs" },
    config = function()
      require("roslyn").setup {
        dotnet_cmd = "dotnet", -- this is the default
        roslyn_version = "4.8.0-3.23475.7",
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end,
  },
  {
    "saecki/crates.nvim",
    tag = "stable",
    config = function()
      require("crates").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "custom.configs.conform"
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = { "rust" },
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    init = function()
      require("core.utils").load_mappings "rustaceanvim"
    end,
    config = function(_, opts)
      local dap = require "dap"
      dap.configurations.rust = {
        {
          type = "lldb",
          request = "launch",
          name = "Rust App",
          program = vim.fn.getcwd() .. "/target/debug/app", -- NOTE: Adapt path to manage.py as needed
        },
      }
      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode-14", -- adjust as needed
        name = "lldb",
      }
    end,
  },
  {
    "b0o/schemastore.nvim",
    ft = { "json", "jsonc", "yaml", "yml" },
  },
  {
    "rcarriga/nvim-dap-ui",
    ft = { "typescript", "typescriptreact", "python", "elixir", "cs", "fs", "rust", "go" },
    dependencies = { "folke/neodev.nvim", "nvim-neotest/nvim-nio", "theHamsta/nvim-dap-virtual-text" },
    config = function()
      require("neodev").setup {
        library = { plugins = { "nvim-dap-ui" }, types = true },
      }
      local dapui = require "dapui"
      dapui.setup()
      local dap = require "dap"
      dap.listeners.before.attach["dapui_config"] = function()
        dapui.open {}
      end
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close {}
      end

      -- require("nvim-dap-virtual-text").setup {
      --   -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
      --   display_callback = function(variable)
      --     local name = string.lower(variable.name)
      --     local value = string.lower(variable.value)
      --     if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
      --       return "*****"
      --     end
      --
      --     if #variable.value > 15 then
      --       return " " .. string.sub(variable.value, 1, 15) .. "... "
      --     end
      --
      --     return " " .. variable.value
      --   end,
      -- }

      local elixir_ls_debugger = "/home/em/.local/share/nvim/mason/bin/elixir-ls-debugger"
      if elixir_ls_debugger ~= "" then
        dap.adapters.mix_task = {
          type = "executable",
          command = elixir_ls_debugger,
        }

        dap.configurations.elixir = {
          {
            type = "mix_task",
            name = "phoenix server",
            task = "phx.run",
            request = "launch",
            projectDir = "${workspaceFolder}",
            debugAutoInterpretAllModules = false,
            debugInterpretModulesPatterns = { "FsWeb.*", "Fs.*", "Ash.*" },
            exitAfterTaskReturns = false,
          },
        }
      end

      vim.keymap.set("n", "<leader>dui", require("dapui").toggle)
      vim.keymap.set("n", "<leader>ic", require("dap").continue)
      vim.keymap.set("n", "<leader>io", require("dap").step_over)
      vim.keymap.set("n", "<leader>ii", require("dap").step_into)
      vim.keymap.set("n", "L", require("dap").step_over)
      vim.keymap.set("n", "J", require("dap").step_into)
      vim.keymap.set("n", "<leader>iO", require("dap").step_out)
      vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint)
      vim.keymap.set("n", "<leader>gb", require("dap").run_to_cursor)
      vim.keymap.set("n", "<leader>B", function()
        require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end)
      require("neodev").setup {
        library = { plugins = { "nvim-dap-ui" }, types = true },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "python" },
    config = function()
      require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
      local dap = require "dap"
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Django",
        program = vim.fn.getcwd() .. "/manage.py", -- NOTE: Adapt path to manage.py as needed
        args = { "runserver" },
      })
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = { "golang" },

    config = function()
      require("dap-go").setup {
        dap_configurations = {
          {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        delve = {
          -- the path to the executable dlv which will be used for debugging.
          -- by default, this is the "dlv" executable on your PATH.
          path = "dlv",
          -- time to wait for delve to initialize the debug session.
          -- default to 20 seconds
          initialize_timeout_sec = 20,
          -- a string that defines the port to start delve debugger.
          -- default to string "${port}" which instructs nvim-dap
          -- to start the process in a random available port
          port = "${port}",
          -- additional args to pass to dlv
          args = {},
          -- the build flags that are passed to delve.
          -- defaults to empty string, but can be used to provide flags
          -- such as "-tags=unit" to make sure the test suite is
          -- compiled during debugging, for example.
          -- passing build flags using args is ineffective, as those are
          -- ignored by delve in dap mode.
          build_flags = "",
        },
      }
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    ft = { "typescript", "typescriptreact" },
    dependencies = { "mfussenegger/nvim-dap" },

    config = function()
      require("dap-vscode-js").setup {
        -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        debugger_path = "/home/em/.local/share/nvim/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
        -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost", "chrome" }, -- which adapters to register in nvim-dap
        -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
        -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
        -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
      }
      local dap_utils = require "dap.utils"

      for _, language in ipairs { "typescript", "javascript", "typescriptreact", "javascriptreact", "" } do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            command = "pnpm turbo devnew",
            name = "NPM Run Dev",
            request = "launch",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach Program (pwa-node, select pid)",
            cwd = vim.fn.getcwd(),
            processId = dap_utils.pick_process,
            skipFiles = { "<node_internals>/**" },
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Start Chrome with Localhost",
            url = "http://localhost:4321",
            webRoot = "${workspaceFolder}/apps/poc",
            userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
          },
        }
      end
    end,
  },
  {
    "microsoft/vscode-js-debug",
    ft = { "typescript", "typescriptreact" },
    opt = true,
    run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  {
    "fatih/vim-go",
    ft = "go",
    config = function() end,
  },
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup {}
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- Uncomment next line if you want to follow only stable versions
    -- tag = "*"
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension "frecency"
    end,
    dependencies = { "kkharji/sqlite.lua" },
  },
  {
    "xiyaowong/telescope-emoji.nvim",
    lazy = false,
    config = function()
      require("telescope").load_extension "emoji"
    end,
  },
  -- {
  --   "barrett-ruth/import-cost.nvim",
  --   build = "sh install.sh npm",
  --   ft = { "typescript", "typescriptreact" },
  --   keys = {
  --     { "<leader>tic", "import-cost" },
  --   },
  --   config = function()
  --     require("import-cost").setup {}
  --   end,
  -- },
  {
    "nvim-pack/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI" },
    dependencies = { "kristijanhusak/vim-dadbod-completion", "tpope/vim-dadbod" },
    config = function()
      local autocmd = vim.api.nvim_create_autocmd
      autocmd("BufEnter", {
        callback = function()
          require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
        end,
      })
    end,
  },
  {
    "lukas-reineke/headlines.nvim",
    event = "BufRead",
    config = function()
      if vim.g.vscode then
      else
        require("headlines").setup()
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
      "marilari88/neotest-vitest",
      "Issafalcon/neotest-dotnet",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-python",
      "jfpedroza/neotest-elixir",
    },
    ft = { "go", "typescriptreact", "javascriptreact" },
    init = function()
      require("core.utils").load_mappings "neotest"
    end,
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup {
        adapters = {
          require "neotest-go",
          require "neotest-vitest",
          require "neotest-dotnet" {
            dap_adapter = "lldb",
          },
          require "neotest-elixir" {
            mix_task = "test",
          },
          require "neotest-rust" {},

          require "neotest-python" {
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = { justMyCode = false, console = "integratedTerminal" },
            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = { "--log-level", "DEBUG" },
            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = "pytest",
            -- Custom python path for the runner.
            -- Can be a string or a list of strings.
            -- Can also be a function to return dynamic value.
            -- If not provided, the path will be inferred by checking for
            -- virtual envs in the local directory and for Pipenev/Poetry configs
            python = "./venv/bin/python",
            -- Returns if a given file path is a test file.
            -- NB: This function is called a lot so don't perform any heavy tasks within it.
            -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
            -- instances for files containing a parametrize mark (default: false)
            pytest_discover_instances = true,
          },
        },
      }
    end,
  },
  { "github/copilot.vim", event = "BufEnter" },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup {
        width = 120, -- Width of the floating window
        height = 25, -- Height of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
        -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
        -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
      }
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup {
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      }
    end,
  },
  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = {
          -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            "class",
            "function",
            "method",
          },
        },
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "svelte", "vue", "astro", "xml", "markdown" },
    config = function()
      require("nvim-ts-autotag").setup {
        autotag = {
          enable = true,
        },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "aserowy/tmux.nvim",
    lazy = false,
    config = function()
      require("tmux").setup()
    end,
  },
  { "dhruvasagar/vim-table-mode" },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
