local M = {}

-- Window management mappings for normal mode
function M.window()
  return {
    -- Move windows
    ["mh"] = { "<cmd>wincmd H<CR>", desc = "Move window to left" },
    ["ml"] = { "<cmd>wincmd L<CR>", desc = "Move window to right" },
    ["mk"] = { "<cmd>wincmd K<CR>", desc = "Move window up" },
    ["mj"] = { "<cmd>wincmd J<CR>", desc = "Move window down" },
    ["m="] = { "<cmd>wincmd =<CR>", desc = "Balance window sizes" },
    ["mS"] = { "<cmd>wincmd S<CR>", desc = "Move window to left" },
    ["mV"] = { "<cmd>wincmd V<CR>", desc = "Move window to right" },
    ["mW"] = { "<cmd>wincmd W<CR>", desc = "Move window to up" },
    ["mX"] = { "<cmd>wincmd X<CR>", desc = "Move window to down" },

    -- Resize windows
    ["m<"] = { "<cmd>wincmd <resizedelta><CR>", desc = "Resize window to left" },
    ["m>"] = { "<cmd>wincmd >resizedelta><CR>", desc = "Resize window to right" },
    ["m-"] = { "<cmd>wincmd -resizedelta><CR>", desc = "Resize window to up" },
    ["m+"] = { "<cmd>wincmd +resizedelta><CR>", desc = "Resize window to down" },
  }
end

return M
