local M = {}
local config = require("todo.config")
M.steup = config.setup
require("todo.command")
local highlight = require("todo.highlight")
M.toggleHighlight = highlight.toggleHighlight
return M
