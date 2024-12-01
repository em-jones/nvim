vim.filetype.add { extension = { templ = "templ" } }

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "clangd", "prismals", "terraformls", "astro", "templ" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- lspconfig.elixirls.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = { "elixir", "heex", "eex", "exs" },
--   cmd = { "/home/em/.local/share/nvim/mason/bin/elixir-ls" },
-- }
-- lspconfig.gleam.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = { "gleam" },
-- }

lspconfig.tsserver.setup {
  filetypes = { "typescriptreact", "typescript" },
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    userLanguages = {
      elixir = "html-eex",
      eelixir = "html-eex",
      heex = "html-eex",
    },
  },
  filetypes = {
    "html",
    "astro",
    "typescriptreact",
    "svelte",
    "vue",
    "css",
    "templ",
    "heex",
    "eex",
    "gleam",
    "elixir",
    "eelixir",
  },
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" }, -- class-variance-authority settings
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          { 'class[:]\\s*"([^"]*)"' },
        },
      },
    },
  },
}

lspconfig.htmx.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "astro", "templ", "heex", "eex", "gleam", "elixir" },
}

lspconfig.astro.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "astro" },
  init_options = {
    typescript = {
      tsdk = "/home/em/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib",
    },
  },
}

lspconfig.svelte.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "svelte" },
}

lspconfig.terraformls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  ft = { "terraform", "terraform-vars" },
  cmd = { "terraform-ls", "serve" },
}

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  ft = { "go", "templ" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

-- lspconfig.omnisharp.setup {
--   cmd = { "/home/em/.local/share/nvim/mason/bin/omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
--   enable_editorconfig_support = true,
--   enable_roslyn_analyzers = true,
--   organize_imports_on_format = true,
--   enable_import_completion = true,
-- }

lspconfig.jsonls.setup {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas {
        extra = {
          {
            description = "vimspector - full config",
            fileMatch = { ".vimspector.json" },
            name = "package.json",
            url = "https://puremourning.github.io/vimspector/schema/vimspector.schema.json",
          },
          {
            description = "vimspector - gadgets",
            fileMatch = { ".gadgets.json" },
            name = "gadgets.json",
            url = "https://puremourning.github.io/vimspector/schema/gadgets.schema.json",
          },
        },
      },
      validate = { enable = true },
    },
  },
}
lspconfig.ruff_lsp.setup {}
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.emmet_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "css", "svelte", "vue", "astro", "heex", "eex", "templ", "typescriptreact", "svelte" },
}
--
-- lspconfig.pyright.setup { blabla}
