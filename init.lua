-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  local result = vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath })
  if vim.v.shell_error ~= 0 then
    -- stylua: ignore
    vim.api.nvim_echo(
    { { ("Error cloning lazy.nvim:\n%s\n"):format(result), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
      true, {})
    vim.fn.getchar()
    vim.cmd.quit()
  end
end

vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo(
  { { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
    true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
end

vim.api.nvim_create_user_command("ExportKeybinds", function()
  -- 定义输出文件路径
  local file_path = vim.fn.expand "~/nvim_keybinds.txt"

  -- 打开文件准备写入
  local file = io.open(file_path, "w")
  if not file then
    vim.notify("无法打开文件: " .. file_path, vim.log.levels.ERROR)
    return
  end

  -- 获取各种模式的键位映射
  local modes = {
    { name = "Normal, Visual, Operator", mode = "",  cmd = "map" },
    { name = "Insert, Command-line",     mode = "!", cmd = "map!" },
    { name = "Normal",                   mode = "n", cmd = "nmap" },
    { name = "Visual",                   mode = "v", cmd = "vmap" },
    { name = "Insert",                   mode = "i", cmd = "imap" },
    { name = "Command-line",             mode = "c", cmd = "cmap" },
    { name = "Terminal",                 mode = "t", cmd = "tmap" },
    { name = "Operator-pending",         mode = "o", cmd = "omap" },
  }

  -- 写入文件头部信息
  file:write "Neovim Keybindings Export\n"
  file:write("Generated on: " .. os.date "%Y-%m-%d %H:%M:%S" .. "\n")
  file:write "==========================================\n\n"

  -- 获取并写入每种模式的键位映射
  for _, mode_info in ipairs(modes) do
    file:write("====== " .. mode_info.name .. " Mode ======\n")

    -- 使用 vim.api.nvim_get_keymap 获取映射
    local keymaps = vim.api.nvim_get_keymap(mode_info.mode)

    if #keymaps == 0 then
      file:write "(No mappings)\n\n"
    else
      for _, keymap in ipairs(keymaps) do
        local lhs = keymap.lhs
        local rhs = keymap.rhs or ""
        local desc = keymap.desc or ""
        local noremap = keymap.noremap and "noremap" or "map"

        -- 格式化输出
        file:write(string.format("%-20s -> %-30s %s (%s)\n", lhs, rhs, desc, noremap))
      end
      file:write "\n"
    end
  end

  -- 关闭文件
  file:close()

  -- 通知用户
  vim.notify("Keybindings exported to: " .. file_path, vim.log.levels.INFO)
end, {})

require("user.terminal_caps").apply()
require "lazy_setup"
require "polish"
