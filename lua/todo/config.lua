package.path = package.path .. "./?.lua;" .. "./?/init.lua"
require("todo.utils")

local M = {}
M.setup = function(opt)
  for k, v in pairs(opt) do
    M[k] = v
  end
  M.keywords_group = table.group(M.keywords, "priority")
end

local default_options = {
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
      color = { cterm = "reverse", gui = "reverse", guifg = "#ff9d81", guibg = "#282828" },
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
M.setup(default_options)
local change = require("todo.change")
change.keywords = M.keywords
M.todoChange = change.todoChange
local todoChange = M.todoChange
M.clearLine = change.clearLine

local function visual_selection_range(mode)
  local csrow, cscol, cerow, cecol
  if mode == "v" then
    _, csrow, cscol, _ = unpack(vim.fn.getpos("v"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("."))
  else
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

function NvimTodoChange(keyWord, mode)
  if mode == nil then
    mode = "n"
  end
  if mode == "n" then
    local curLine = vim.api.nvim_get_current_line()
    vim.api.nvim_set_current_line(todoChange(curLine, keyWord))
  else
    local startIndex, _, endIndex, _ = visual_selection_range(mode)
    if endIndex - startIndex > 0 then
      local optedLines = {}
      local lines = vim.api.nvim_buf_get_lines(0, startIndex, endIndex + 1, false)
      for _, line in ipairs(lines) do
        table.insert(optedLines, todoChange(line, keyWord))
      end
      vim.api.nvim_buf_set_lines(0, startIndex, endIndex + 1, false, optedLines)
    end
  end
end

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
keymap("n", "<Leader>ms", "<cmd>lua NvimTodoChange('start','n')<CR>", opts)
keymap("x", "<Leader>ms", "<cmd>lua NvimTodoChange('start','v')<CR>", opts)
keymap("n", "<Leader>mi", "<cmd>lua NvimTodoChange('init','n')<CR>", opts)
keymap("x", "<Leader>mi", "<cmd>lua NvimTodoChange('init','v')<CR>", opts)
keymap("n", "<Leader>mf", "<cmd>lua NvimTodoChange('finish','n')<CR>", opts)
keymap("x", "<Leader>mf", "<cmd>lua NvimTodoChange('finish','v')<CR>", opts)
keymap("n", "<Leader>mt", "<cmd>lua NvimTodoChange('stop','n')<CR>", opts)
keymap("x", "<Leader>mt", "<cmd>lua NvimTodoChange('stop','v')<CR>", opts)
keymap("n", "<Leader>mc", "<cmd>lua NvimTodoChange('cancel','n')<CR>", opts)
keymap("x", "<Leader>mc", "<cmd>lua NvimTodoChange('cancel','v')<CR>", opts)
keymap("n", "<Leader>mk", "<cmd>lua NvimTodoChange('tinit','n')<CR>", opts)
keymap("x", "<Leader>mk", "<cmd>lua NvimTodoChange('tinit','v')<CR>", opts)
keymap("n", "<Leader>ml", "<cmd>lua NvimTodoChange('clean','n')<CR>", opts)
keymap("x", "<Leader>ml", "<cmd>lua NvimTodoChange('clean','v')<CR>", opts)

return M
