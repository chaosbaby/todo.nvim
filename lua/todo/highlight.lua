-- a list of colors for priority levels
-- important and unurgent
-- important and urgent
-- unimportant and urgent
-- unimportant and unurgent

local M = {
  tags = {
    iu = 15,
    i = 10,
    u = 5,
    n = 0,
  },
  colorPrioritiesRank = {
    "#ff0000",
    "#ff3333",
    "#ff6666",
    "#ff9999",

    "#ffa500",
    "#ffb733",
    "#ffc966",
    "#ffdb99",

    "#ffff00",
    "#ffff33",
    "#ffff66",
    "#ffff99",

    "#1aff1a",
    "#00b300",
    "#008000",
    "#004d00",

    "#000033",
    "#000099",
    "#0000ff",
    "#6666ff",

    -- "#A52A2A",
    -- "#800000",
    -- "#FF4500",
    -- "#FF8C00",
    -- "#FFA500",
    -- "#FFD700",
    -- "#FFFF00",
    -- "#9ACD32",
    -- "#006400",
    -- "#008000",
    -- "#00ff00",
    -- "#0000ff",
  },
  keywords = {
    start = {
      icon = "🆕",
      stateBox = "- [ ] ",
      color = { cterm = "reverse", gui = "reverse", guifg = "#ff5181", guibg = "#282828" },
      alt = { "start" },
      priority = 10,
    },
    init = {
      icon = "🆕",
      stateBox = "- [ ] ",
      color = { cterm = "reverse", gui = "reverse", guifg = "#b8bb26", guibg = "#282828" },
      alt = { "init" },
      priority = 2,
    },
    finish = {
      icon = "🆕",
      stateBox = "- [X] ",
      alt = { "finish" },
      priority = 0,
    },
    stop = {
      icon = "🆕",
      stateBox = "- [S] ",
      color = { cterm = "reverse", gui = "reverse", guifg = "#fb4934", guibg = "#282828" },
      alt = { "stop" },
      priority = 4,
    },
    cancel = {
      icon = "🆕",
      stateBox = "- [C] ",
      alt = { "cancel" },
      priority = 0,
    },
    tinit = {
      icon = "🆕",
      stateBox = "* [ ] ",
      color = { cterm = "reverse", gui = "reverse", guifg = "#fabd2f", guibg = "#282828" },
      alt = { "tinit" },
      priority = 2,
    },
    clean = {
      icon = "🆕",
      stateBox = "",
      alt = { "clean" },
      priority = 1,
    },
  },
}
-- lua table to string
local function tbl_to_string(tbl)
  local result = ""
  for k, v in pairs(tbl) do
    result = result .. k .. "=" .. tostring(v) .. " "
  end
  return result
end

function Toggle_augroup(name, cb)
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
end

local function hiTodo()
  for key, tbl in pairs(M.keywords) do
    if type(tbl.color) == "table" then
      local cmd = string.format("hi %s %s", key, tbl_to_string(tbl.color))
      vim.cmd(cmd)
    end
  end
end

local function match_todo()
  local pattern = [[@KEYWORDS]]
  for key, tbl in pairs(M.keywords) do
    if type(tbl.color) == "table" then
      local hi_pat = string.gsub(pattern, "KEYWORDS", key)
      M.keywords[key].hi_key = vim.fn.matchadd(key, hi_pat)
    end
  end
end

function Sign_todo()
  for key, tbl in pairs(M.keywords) do
    M.keywords[key].hi_key = vim.fn.sign_define(key, { text = tbl.icon, texthl = key })
  end
end

function Match_none()
  for key, _ in pairs(M.keywords) do
    vim.fn.matchdelete(M.keywords[key].hi_key)
  end
end

hiTodo()
Sign_todo()
match_todo()

Match_todo = match_todo
