vim.api.nvim_create_user_command("TodoChange", function(com)
  local keyWord = com.args
  if vim.tbl_get(M.keywords, keyWord) ~= nil then
    NvimTodoChange(keyWord)
  else
    print("No such command")
  end
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(M.keywords)
  end,
})

require("user.fzf")

vim.api.nvim_create_user_command("TodoGrep", function(com)
  local args = com.fargs
  local reg = table.concat(args, "|")
  local pattern = [[@(KEYWORDS)]]
  reg = string.gsub(pattern, "KEYWORDS", reg)
  Rg_to_qf(reg, " -t md")
end, {
  nargs = "+",
  complete = function(_, l, _)
    local completions = vim.tbl_keys(M.keywords)
    local selected = vim.split(l, " ")
    return table.diff(completions, selected)
    -- return completions
  end,
})

vim.api.nvim_create_user_command("TodoGrepPri", function(com)
  local priorities = com.fargs
  local keywords = table.get_elements_with_keys(M.keywords_group, priorities)
  print(vim.inspect(keywords))
  local reg = table.concat(keywords, "|")
  local pattern = [[@(KEYWORDS)]]
  reg = string.gsub(pattern, "KEYWORDS", reg)
  Rg_to_qf(reg, " -t md")
end, {
  nargs = "+",
  complete = function(_, l, _)
    local priorities = table.get_elements(M.keywords, "priority")
    local uni_priorities = table.dedup(priorities)
    table.sort(uni_priorities, function(a, b)
      return tonumber(a) > tonumber(b)
    end)
    local str_priorities = table.map(uni_priorities, tostring)
    local selected = vim.split(l, " ")
    return table.diff(str_priorities, selected)
  end,
})
