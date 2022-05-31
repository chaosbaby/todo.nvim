local busted = require("busted")
local describe = busted.describe
local it = busted.it
local util = require("todo.utils")

local fun1 = function()
  return true
end
local fun2 = function()
  return false
end
describe("createToggle", function()
  it("should work", function()
    local toggle = util.createToggle(fun1, fun2)
    assert.are.same(toggle(), true)
    assert.are.same(toggle(), false)
  end)
  it("should work with status args", function()
    local toggle = util.createToggle(fun1, fun2)
    assert.are.same(toggle(true), true)
    assert.are.same(toggle(true), true)
    assert.are.same(toggle(false), false)
    assert.are.same(toggle(false), false)
  end)
end)
