-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",

        -- install formatters
        "stylua",

        -- install debuggers
        -- "debugpy",

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
  {
    {
      "mason-org/mason.nvim",
      opts = {
        registries = {
          "github:mason-org/mason-registry",
          "github:zdelv/pyrefly-mason-registry",
        },
      },
    },
  },
  -- { "mason-lspconfig.nvim", opts = { automatic_installation = false } },
  -- { "mason-nvim-dap.nvim", opts = { automatic_installation = false } },
}
