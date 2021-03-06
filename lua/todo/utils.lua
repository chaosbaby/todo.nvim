local M = {}
--group table by key
function table.group(tbl, key)
  local ret = {}
  for k, v in pairs(tbl) do
    local group = v[key]
    if ret[group] == nil then
      ret[group] = {}
    end
    table.insert(ret[group], k)
  end
  return ret
end

function table.contains(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

-- two list table difference
function table.diff(t1, t2)
  local ret = {}
  for _, v in ipairs(t1) do
    if table.contains(t2, v) == false then
      table.insert(ret, v)
    end
  end
  return ret
end

-- get elements with key from table
function table.get_elements(tbl, key)
  local ret = {}
  for _, v in pairs(tbl) do
    table.insert(ret, v[key])
  end
  return ret
end

--get elements with keys
function table.get_elements_with_keys(tbl, keys)
  local ret = {}
  for _, key in ipairs(keys) do
    table.insert(ret, tbl[key])
  end
  local r = vim.tbl_flatten(ret)
  return r
end

--list dedup
function table.dedup(tbl)
  local hush = {}
  local ret = {}
  for _, v in ipairs(tbl) do
    hush[v] = true
  end
  for k, _ in pairs(hush) do
    table.insert(ret, k)
  end
  return ret
end

--map list with function
function table.map(tbl, func)
  local ret = {}
  for _, v in ipairs(tbl) do
    table.insert(ret, func(v))
  end
  return ret
end

-- lua table to string
function table.to_string(tbl)
  local result = ""
  for k, v in pairs(tbl) do
    result = result .. k .. "=" .. tostring(v) .. " "
  end
  return result
end

-- create toggle function with two functions

function M.createToggle(func1, func2)
  local status = true
  local toggle_fun = function(enabled)
    if enabled == true or enabled == false then
      status = enabled
    end
    local exefun
    if status then
      exefun = func1
    else
      exefun = func2
    end
    status = not status
    return exefun()
  end
  return toggle_fun
end

return M
