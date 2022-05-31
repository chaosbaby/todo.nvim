local M = {}
local function rg_list(reg, extra)
  if extra == nil then
    extra = ""
  end
  local rg_opts = "--column --line-number --no-heading --smart-case --max-columns=512"
  local cmd = string.format("rg '%s' %s %s", reg, rg_opts, extra)
  local result = vim.fn.systemlist(cmd)
  return result
end

local function rg_rusult_to_table(result)
  local t = {}
  for _, line in ipairs(result) do
    local filename = line:match("^(.-):")
    local lnum = line:match(":(%d+):")
    local col = line:match("%d+:(%d+):")
    local text = line:match("%d+:%d+:(.-)$")
    table.insert(t, {
      filename = filename,
      lnum = lnum,
      col = col,
      text = text,
    })
  end
  return t
end

local function rg_to_qf(reg, extra)
  -- test if ripgrep is installed
  local cmd = "rg --version"
  local rgInfo = vim.fn.systemlist(cmd)
  if rgInfo[1] == nil then
    print("you sould install reigrep first")
    return
  end
  --if Trouble installed use Trouble to show else use locallist
  local result = rg_list(reg, extra)
  local tbl = rg_rusult_to_table(result)
  vim.fn.setqflist(tbl)
  local ok, _ = pcall(require, "trouble")
  if ok then
    vim.cmd("Trouble quickfix")
  else
    vim.cmd("copen")
  end
end

M.rg_to_qf = rg_to_qf
local status_ok, fzfLua = pcall(require, "fzf-lua")
if not status_ok then
  return M
end

local function fzf_grep_reg(reg, extra)
  if extra == nil then
    extra = ""
  end
  if reg == nil then
    reg = " "
  end
  --no-ignore
  local dir = vim.fn.finddir(".git/..")
  local rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 " .. extra
  local cmd = string.format("rg '%s' %s %s", reg, dir, rg_opts)
  fzfLua.grep({
    cmd = cmd,
    search = "",
  })
end

local function fzf_grep_reg_noig(reg)
  fzf_grep_reg(reg, "--no-ignore")
end

local function fzf_grep_todo(reg, extra)
  local act = {
    ["ctrl-y"] = function(selected)
      local lines = ""
      for _, line in ipairs(selected) do
        lines = lines .. line .. "\n"
      end
      vim.cmd("normal! i" .. lines)
    end,
  }
  local dir = vim.fn.finddir(".git/..")
  local rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 " .. extra
  local cmd = string.format("rg '%s' %s %s", reg, dir, rg_opts)
  fzfLua.grep({
    cmd = cmd,
    search = "",
    actions = act,
  })
end

return {
  rg_to_qf = rg_to_qf,
  fzf_grep_todo = fzf_grep_todo,
}
