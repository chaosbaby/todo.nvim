-- a list of colors for priority levels
-- important and unurgent
-- important and urgent
-- unimportant and urgent
-- unimportant and unurgent

local config = require("todo.config")
local utils = require("todo.utils")

--[[ function Toggle_augroup(name, cb)
  local toggle_fun = function(enabled)
    local augroup = vim.api.nvim_create_augroup(name, { clear = true })
    if enabled == true or enabled == false then
      vim.g[name] = enabled
    end
    if vim.g[name] == nil then
      vim.g[name] = true
    end
    if vim.g[name] then
      cb(augroup)
    else
      vim.api.nvim_del_augroup_by_name(name)
    end
    vim.g[name] = not vim.g[name]
  end
  return toggle_fun
end ]]

local function hiTodo()
  for key, tbl in pairs(config.keywords) do
    if type(tbl.color) == "table" then
      local cmd = string.format("hi %s %s", key, table.to_string(tbl.color))
      vim.cmd(cmd)
    end
  end
end

local function match_todo()
  local pattern = [[@KEYWORDS]]
  for key, tbl in pairs(config.keywords) do
    if type(tbl.color) == "table" then
      local hi_pat = string.gsub(pattern, "KEYWORDS", key)
      config.keywords[key].hi_key = vim.fn.matchadd(key, hi_pat)
    end
  end
end

-- local function sign_todo()
--   for key, tbl in pairs(config.keywords) do
--     config.keywords[key].hi_key = vim.fn.sign_define(key, { text = tbl.icon, texthl = key })
--   end
-- end

local function match_none()
  for key, _ in pairs(config.keywords) do
    if config.keywords[key].hi_key ~= nil then
      vim.fn.matchdelete(config.keywords[key].hi_key)
    end
  end
end

hiTodo()
--sign_todo()
--match_todo()

local toggleHighlight = utils.createToggle(match_todo, match_none)
return {
  highlight = match_todo,
  toggleHighlight = toggleHighlight,
}
