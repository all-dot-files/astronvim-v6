return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = (function()
          local n = {
            ["gh"] = { "^", desc = "move line head" },
            ["gL"] = { "$", desc = "move line end" },
          }
          local ok, nav = pcall(require, "utils.navigation")
          if ok and nav.window then
            for k, v in pairs(nav.window()) do
              n[k] = v
            end
          end
          return n
        end)(),
        i = {
          ["<C-h>"] = { "<Left>", desc = "move left when i" },
          ["<C-l>"] = { "<Right>", desc = "move right when i" },
          ["<C-j>"] = { "<Down>", desc = "move Down when i" },
          ["<C-k>"] = { "<Up>", desc = "move Up when i" },
        },
        t = {
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
          ["<A-i>"] = { '<Cmd>execute v:count . "ToggleTerm"<CR>', desc = "Toggle terminal" },
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
          gD = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
          ["<Leader>uY"] = {
            function() require("astrolsp.toggles").buffer_semantic_tokens() end,
            desc = "Toggle LSP semantic highlight (buffer)",
            cond = function(client)
              return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
            end,
          },
        },
      },
    },
  },
}
