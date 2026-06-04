return {
  {
    "linux-cultist/venv-selector.nvim",
    -- dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
      -- Your options go here
      -- name = "venv",
      -- auto_refresh = false
    },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "VenvSelect" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "VenvSelectCached" },
    },
  },
  {
    "cordx56/rustowl",
    dependencies = { "neovim/nvim-lspconfig" },
  },
}
