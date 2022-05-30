local busted = require("busted")
local describe = busted.describe
local it = busted.it
require("utils")

describe("get_elements_with_keys", function()
  it("should work simple", function()
    local t = {
      a = { 1, 2 },
      b = { 3 },
      c = { 4, 5 },
    }
    local result = table.get_elements_with_keys(t, { "a", "b" })
    assert.are.same({ a = 1, b = 2 }, result)
  end)
end)
