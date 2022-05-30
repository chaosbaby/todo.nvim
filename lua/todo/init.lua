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
  keywords = {
    start = {
      icon = "🆕",
      stateBox = "- [ ] ",
      color = { cterm = "reverse", gui = "reverse", guifg = "#ff5181", guibg = "#282828" },
      alt = { "start" },
      priority = "10",
    },
    init = {
      icon = "🆕",
      stateBox = "- [ ] ",
      color = { cterm = "reverse", gui = "reverse", guifg = "#b8bb26", guibg = "#282828" },
      alt = { "init" },
      priority = "2",
    },
    finish = {
      icon = "🆕",
      stateBox = "- [X] ",
      -- color = { cterm = "reverse", gui = "bold" },
      -- color = { cterm = "reverse", gui = "bold", guifg = "#282828", guibg = "#282828" },
      alt = { "finish" },
      priority = "0",
    },
    stop = {
      icon = "🆕",
      stateBox = "- [S] ",
      color = { cterm = "reverse", gui = "reverse", guifg = "#fb4934", guibg = "#282828" },
      alt = { "stop" },
      priority = "4",
    },
    cancel = {
      icon = "🆕",
      stateBox = "- [C] ",
      -- color = { cterm = "reverse", gui = "bold" },
      -- color = { cterm = "reverse", gui = "reverse", guifg = "#fabd2f", guibg = "#282828" },
      alt = { "cancel" },
      priority = "0",
    },
    tinit = {
      icon = "🆕",
      stateBox = "* [ ] ",
      color = { cterm = "reverse", gui = "reverse", guifg = "#ff9d81", guibg = "#282828" },
      alt = { "tinit" },
      priority = "2",
    },
    clean = {
      icon = "🆕",
      stateBox = "",
      -- color = { cterm = "reverse", gui = "bold", guifg = "#ff5181", guibg = "#282828" },
      alt = { "clean" },
      priority = "1",
    },
  },
}
M.setup(default_options)
local change = require("todo.change")
change.keywords = M.keywords
M.todoChange = change.todoChange
local todoChange = M.todoChange
M.clearLine = change.clearLine
require("todo.highlight")

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

-- vim.cmd([[
-- autocmd BufNewFile,BufRead *.md
-- nnoremap <silent> <Leader>ms :lua NvimTodoChange("start")<CR>
-- vnoremap <silent> <Leader>ms :lua NvimTodoChange("start")<CR>
-- nnoremap <silent> <Leader>mS :lua NvimTodoChange("stop")<CR>
-- vnoremap <silent> <Leader>mS :lua NvimTodoChange("stop")<CR>
-- nnoremap <silent> <Leader>mx :lua NvimTodoChange("cancel")<CR>
-- vnoremap <silent> <Leader>mx :lua NvimTodoChange("cancel")<CR>
-- nnoremap <silent> <Leader>mc :lua NvimTodoChange("clear")<CR>
-- vnoremap <silent> <Leader>mc :lua NvimTodoChange("clear")<CR>
-- nnoremap <silent> <Leader>mf :lua NvimTodoChange("finish")<CR>
-- vnoremap <silent> <Leader>mf :lua NvimTodoChange("finish")<CR>
-- nnoremap <silent> <Leader>mi :lua NvimTodoChange("init")<CR>
-- vnoremap <silent> <Leader>mi :lua NvimTodoChange("init")<CR>
-- nnoremap <silent> <Leader>mt :lua NvimTodoChange("tinit")<CR>
-- vnoremap <silent> <Leader>mt :lua NvimTodoChange("tinit")<CR>
-- ]])

return M
