local M = {}
M.keywords = {}
local function addTimeTag(mode)
  return string.format(" @%s(%s)", mode, os.date("%Y-%m-%d %H:%M"))
end

local function clearLine(line)
  local pats = {}
  table.insert(pats, "[*-] %[[a-zA-Z ]%] ")
  table.insert(pats, " @%w+%(.*%)")
  local cline = line
  for _, pat in pairs(pats) do
    cline = string.gsub(cline, pat, "")
  end
  return cline
end

M.clearLine = clearLine

local function startTime(line)
  local pattag = " @start%((%d%d%d%d%-%d%d%-%d%d %d%d:%d%d)%)"
  local _, _, timeStr = string.find(line, pattag)
  return timeStr
end

local function findTimeUsed(line)
  local pattag = "@used%((%d+)m%)"
  local _, _, timeStr = string.find(line, pattag)
  if timeStr then
    return tonumber(timeStr)
  else
    return 0
  end
end

local function timeDiff(line)
  local dateStr = startTime(line)
  if dateStr then
    local _, _, y, m, d, _hour, _min, _sec = string.find(dateStr, "(%d+)%-(%d+)%-(%d+)%s*(%d+):(%d+)")
    local timestamp = os.time({
      year = y,
      month = m,
      day = d,
      hour = _hour,
      min = _min,
      sec = _sec,
    })
    local difTime = os.difftime(os.time(), timestamp) / 60
    return difTime
  else
    return 0
  end
end

local function newTimeTag(line)
  local newUsed = findTimeUsed(line) + timeDiff(line)
  local timeTag = ""
  if newUsed ~= 0 then
    timeTag = string.format(" @used(%dm)", newUsed)
  end
  return timeTag
end

local function todoChange(line, keyWord, _todo_tbl)
  if _todo_tbl == nil then
    _todo_tbl = M.keywords
  end
  local _, eIndex, spaceHeader = string.find(line, "^(%s*%d*%.? ?)")
  local clearedLine = clearLine(line)
  spaceHeader = spaceHeader or ""
  local header = _todo_tbl[keyWord].stateBox
  local subStr = string.sub(clearedLine, eIndex + 1)

  if header == "" then
    return string.format("%s%s", spaceHeader, subStr)
  else
    return spaceHeader .. header .. subStr .. addTimeTag(keyWord) .. newTimeTag(line)
  end
end

M.todoChange = todoChange
return M
