package.path = package.path .. "../?.lua;"
local busted = require("busted")
local describe = busted.describe
local it = busted.it

--
require("todo")
local todoChange = require("todo.change").todoChange
local clearLine = require("todo.change").clearLine
local fakeDate = "2018-01-01 12:00"
os.date = function(_)
  return fakeDate
end
describe("clearLine", function()
  it("should clear the line", function()
    local todoStr = "- [ ] do something"
    local newLine = clearLine(todoStr)
    assert.are.same("do something", newLine)
  end)
end)

describe("todoChange", function()
  it("should format right", function()
    local todoStr = "do something"
    assert.are.same(string.format("- [ ] do something @init(%s)", fakeDate), todoChange(todoStr, "init"))
  end)
  it("should clear out all extra info", function()
    local todoStr = "- [ ] do something"
    assert.are.same(todoChange(todoStr, "clear"), "do something @clear(2018-01-01 12:00)")
  end)

  it("should not effect with re tag to a changed todo line", function()
    local todoStr = "- [ ] do something @init()"
    assert.are.same(string.format("- [ ] do something @init(%s)", fakeDate), todoChange(todoStr, "init"))
  end)
  it("should ok with text indent ", function()
    local indented = "     - [ ]  do something @init()"
    assert.are.same(string.format("     - [ ]  do something @init(%s)", fakeDate), todoChange(indented, "init"))
  end)
  it("should ok with pre indent ", function()
    local indented = "     - [ ] do something @init()"
    assert.are.same(string.format("     - [ ] do something @init(%s)", fakeDate), todoChange(indented, "init"))
  end)
end)
