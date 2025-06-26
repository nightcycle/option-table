--!strict
print("get.lune.luau started")
-- Packages
local optionTable = require("../src")
local option = require("@pkg/@nightcycle/option")

local array = optionTable.from({ 1, 2, 3, 4 })

local first = array[1]
assert(first:isSome(), "Expected first to be Some, but got: " .. tostring(first))

local second = array[9]
assert(second:isNone(), "Expected second to be None, but got: " .. tostring(second))

table.insert(array, option.some(5))

for i, v in array do
	assert(option.isOption(v), "Expected value to be a option, but got: " .. tostring(v))
	print("index: " .. tostring(i) .. ", value: " .. tostring(v))
end

first:inspect(function(value)
	print("first value is " .. tostring(value))
end)

print(tostring(array))
