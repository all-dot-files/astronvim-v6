return {
  {
    "stevearc/aerial.nvim",
    config = function(_, opts)
      local ok, helpers = pcall(require, "aerial.backends.treesitter.helpers")
      if ok then
        -- 兼容 Neovim 0.12：旧版 aerial 仍调用 TSNode:start()/end_()
        helpers.range_from_nodes = function(start_node, end_node)
          local row, col, _, _ = start_node:range()
          local _, _, end_row, end_col = end_node:range()
          return {
            lnum = row + 1,
            end_lnum = end_row + 1,
            col = col,
            end_col = end_col,
          }
        end
      end

      require("aerial").setup(opts)
    end,
    opts = function(_, opts)
      -- 当前锁定的 aerial 版本与 Neovim 0.12 的 Tree-sitter 节点 API 不兼容
      -- 默认禁用 treesitter backend，避免启动时报错；LSP/markdown/man 仍可正常工作
      opts.backends = { "lsp", "markdown", "man" }
      return opts
    end,
  },
  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = "BufEnter",
    config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
    keys = {
      { "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Preview definition" },
      { "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", desc = "Preview type definition" },
      { "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", desc = "Preview implementation" },
      { "gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", desc = "Preview declaration" },
      { "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "Close all preview windows" },
      { "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", desc = "Preview references" },
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"
      local get_hl = require("astroui").get_hlgroup
      local terminal_caps = require "user.terminal_caps"

      ---@diagnostic disable-next-line: inject-field
      status.component.line_end = function()
        return status.component.builder {
          {
            provider = function()
              local map = {
                ["unix"] = "LF",
                ["mac"] = "CR",
                ["dos"] = "CRLF",
              }
              return map[vim.bo.fileformat]
            end,
          },
          surround = {
            separator = "right",
          },
        }
      end

      ---@diagnostic disable-next-line: inject-field
      status.component.terminal_context = function()
        return status.component.builder {
          {
            provider = function()
              local ctx = terminal_caps.context { cwd_max_width = 28 }
              local segments = {}

              if ctx.cwd_text then table.insert(segments, "󰉋 " .. ctx.cwd_text) end
              if ctx.location then table.insert(segments, "󰒋 " .. ctx.location) end
              if ctx.is_tmux then table.insert(segments, " tmux") end
              if ctx.is_ssh then table.insert(segments, "󰣀 ssh") end
              if ctx.is_wezterm then table.insert(segments, " wezterm") end

              return #segments > 0 and table.concat(segments, " ") or ""
            end,
          },
          condition = function()
            local ctx = terminal_caps.context()
            return ctx.cwd_text or ctx.location or ctx.is_wezterm or ctx.is_ssh or ctx.is_tmux
          end,
          hl = function()
            local ctx = terminal_caps.context()
            if ctx.is_ssh then return { fg = get_hl("DiagnosticWarn").fg } end
            if ctx.is_tmux then return { fg = get_hl("Special").fg } end
            return { fg = get_hl("Function").fg }
          end,
          surround = {
            separator = "right",
          },
        }
      end

      opts.statusline = {
        hl = {
          fg = "fg",
          bg = "bg",
        },
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
        status.component.terminal_context(),
        status.component.line_end(),
        status.component.nav(),
      }
    end,
  },
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
  },
}
