local M = {}

local applied = false

local function normalize_text(text)
  if type(text) ~= "string" or text == "" then return nil end
  local normalized = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  if normalized == "" then return nil end
  return normalized
end

local function short_host(host)
  local normalized = normalize_text(host)
  if not normalized then return nil end
  local dot = normalized:find "%."
  if dot then return normalized:sub(1, dot - 1) end
  return normalized
end

local function abbreviate_home(path)
  local normalized = normalize_text(path)
  local home = vim.env.HOME
  if not normalized then return nil end
  if type(home) == "string" and home ~= "" and normalized:sub(1, #home) == home then
    return "~" .. normalized:sub(#home + 1)
  end
  return normalized
end

local function truncate_left(text, max_width)
  local normalized = normalize_text(text)
  if not normalized or #normalized <= max_width then return normalized end
  if max_width <= 1 then return normalized:sub(#normalized - max_width + 1) end
  return "…" .. normalized:sub(#normalized - max_width + 2)
end

function M.detect()
  local term = vim.env.TERM or ""
  local term_program = (vim.env.TERM_PROGRAM or ""):lower()
  local term_program_version = vim.env.TERM_PROGRAM_VERSION or ""
  local is_wezterm = term == "wezterm" or term_program == "wezterm"
  local is_tmux = (vim.env.TMUX or "") ~= ""
  local is_ssh = (vim.env.SSH_CONNECTION or "") ~= ""
    or (vim.env.SSH_CLIENT or "") ~= ""
    or (vim.env.SSH_TTY or "") ~= ""

  return {
    term = term,
    term_program = term_program,
    term_program_version = term_program_version,
    is_wezterm = is_wezterm,
    is_tmux = is_tmux,
    is_ssh = is_ssh,
    supports_true_color = is_wezterm,
    supports_undercurl = is_wezterm,
    supports_osc52 = is_wezterm,
    supports_kitty_keyboard = is_wezterm,
  }
end

function M.context(opts)
  opts = opts or {}
  local max_width = opts.cwd_max_width or 32
  local caps = vim.g.terminal_capabilities
  if type(caps) ~= "table" then caps = M.detect() end

  local cwd = abbreviate_home(vim.fn.getcwd(-1, -1))
  local user = normalize_text(vim.env.USER or vim.env.LOGNAME)
  local host = short_host(vim.env.WEZTERM_HOSTNAME or vim.env.HOSTNAME)

  if not host and vim.uv and vim.uv.os_gethostname then host = short_host(vim.uv.os_gethostname()) end

  local location = nil
  if user and host then
    location = string.format("%s@%s", user, host)
  else
    location = user or host
  end

  return {
    cwd = cwd,
    cwd_text = truncate_left(cwd, max_width),
    location = location,
    is_wezterm = caps.is_wezterm == true,
    is_ssh = caps.is_ssh == true,
    is_tmux = caps.is_tmux == true,
  }
end

function M.apply()
  local caps = M.detect()
  vim.g.terminal_capabilities = caps

  if applied then return caps end
  applied = true

  if caps.supports_true_color then vim.opt.termguicolors = true end

  if caps.supports_osc52 and caps.is_ssh and not caps.is_tmux and vim.fn.has "nvim-0.10" == 1 then
    vim.g.clipboard = "osc52"
  end

  if vim.fn.exists ":TerminalCaps" == 0 then
    vim.api.nvim_create_user_command("TerminalCaps", function()
      vim.notify(vim.inspect(vim.g.terminal_capabilities), vim.log.levels.INFO, {
        title = "TerminalCaps",
      })
    end, { desc = "显示当前终端能力" })
  end

  return caps
end

return M
