return {
  {
    "saghen/blink.cmp",
    -- build = "cargo +nightly build --release",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      keymap = {
        ["<Tab>"] = {
          "snippet_forward",
          function()
            local ok, sk = pcall(require, "sidekick")
            if ok and sk.nes_jump_or_apply then return sk.nes_jump_or_apply() end
            return false -- fallback
          end,
          "fallback",
        },
      },
    },
  },
}
