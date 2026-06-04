---@type LazySpec
return {
  -- Sidekick AI assistant
  {
    "folke/sidekick.nvim",
    -- Lazy-load: load when any of these keys are pressed or the Sidekick command is run
    cmd = { "Sidekick" },
    -- keys = {
    --   { "<Leader>aa", mode = "n" },
    --   { "<Leader>as", mode = "n" },
    --   { "<Leader>ad", mode = "n" },
    --   { "<Leader>at", mode = { "n", "x" } },
    --   { "<Leader>af", mode = "n" },
    --   { "<Leader>ap", mode = { "n", "x" } },
    --   { "<C-n>", mode = { "n", "i", "x", "t" } },
    -- },
    ---@type sidekick.Config
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<tab>"] = {
                function()
                  if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end
                end,
                desc = "Sidekick Next Edit or Apply",
                expr = true,
              },
              ["<C-n>"] = { function() require("sidekick.cli").focus() end, desc = "Sidekick Switch Focus" },
              ["<Leader>a"] = { desc = "SSidekick" },
              ["<Leader>aa"] = {
                function() require("sidekick.cli").toggle { focus = true } end,
                desc = "Sidekick Toggle CLI",
              },
              ["<Leader>as"] = { function() require("sidekick.cli").select() end, desc = "Select CLI" },
              ["<Leader>ad"] = { function() require("sidekick.cli").close() end, desc = "Detach a CLI Session" },
              ["<Leader>at"] = { function() require("sidekick.cli").send { msg = "{this}" } end, desc = "Send This" },
              ["<Leader>af"] = { function() require("sidekick.cli").send { msg = "{file}" } end, desc = "Send File" },
              ["<Leader>ap"] = { function() require("sidekick.cli").prompt() end, desc = "Sidekick Select Prompt" },
            },
            i = {
              ["<C-n>"] = { function() require("sidekick.cli").focus() end, desc = "Sidekick Switch Focus" },
            },
            x = {
              ["<C-n>"] = { function() require("sidekick.cli").focus() end, desc = "Sidekick Switch Focus" },
              ["<Leader>at"] = { function() require("sidekick.cli").send { msg = "{this}" } end, desc = "Send This" },
              ["<Leader>av"] = {
                function() require("sidekick.cli").send { msg = "{selection}" } end,
                desc = "Send Visual Selection",
              },
              ["<Leader>ap"] = { function() require("sidekick.cli").prompt() end, desc = "Sidekick Select Prompt" },
            },
            t = {
              ["<C-n>"] = { function() require("sidekick.cli").focus() end, desc = "Sidekick Switch Focus" },
            },
          },
        },
      },
      {
        "rebelot/heirline.nvim",
        opts = function(_, opts)
          local cfg_ok, user_cfg = pcall(require, "user.config")
          -- Added type check to avoid indexing a non-table (e.g. boolean true when module returns nil)
          if cfg_ok and type(user_cfg) == "table" and user_cfg.enable_sidekick_statusline == false then
            return opts -- module switch off, keep existing statusline
          end

          local status = require "astroui.status"
          local sidekick_component = status.component.builder {
            { provider = function() return " " end },
            condition = function()
              local ok, sk = pcall(require, "sidekick.status")
              return ok and sk.get() ~= nil
            end,
            hl = function()
              local get_hl = require("astroui").get_hlgroup
              local sk = require("sidekick.status").get()
              local grp = "Special"
              if sk then
                if sk.kind == "Error" then
                  grp = "DiagnosticError"
                elseif sk.busy then
                  grp = "DiagnosticWarn"
                end
              end
              return { fg = get_hl(grp).fg }
            end,
            surround = { separator = "right" },
          }
          opts.statusline = {
            hl = { fg = "fg", bg = "bg" },
            status.component.mode(),
            status.component.git_branch(),
            status.component.file_info(),
            status.component.git_diff(),
            status.component.diagnostics(),
            status.component.fill(),
            status.component.cmd_info(),
            status.component.fill(),
            status.component.lsp(),
            status.component.virtual_env(),
            status.component.treesitter(),
            sidekick_component,
            status.component.nav(),
            status.component.mode { surround = { separator = "right" } },
          }
        end,
      },
    },
  },
}
