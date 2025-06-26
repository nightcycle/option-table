--!strict
local Option = require("@pkg/@nightcycle/option")
-- Services
-- Packages
-- Modules
-- Types
type Option<V> = Option.Option<V>

export type OptionTable<K, V> = { [K]: Option<V> }

local OptionTable = {}

function OptionTable:__tostring(): string
	local out = {}
	local isArray = true
	for key, _ in self :: any do
		if type(key) ~= "number" then
			isArray = false
			break
		end
	end
	for key, value in self :: any do
		if isArray then
			value:inspect(function(v: any)
				table.insert(out, tostring(v))
			end)
		else
			value:inspect(function(v: any)
				table.insert(out, tostring(key) .. ": " .. tostring(v))
			end)
		end
	end
	return "{" .. table.concat(out, ", ") .. "}"
end

function OptionTable:__index(key: any): Option<any>
	local value = rawget(self :: any, key)
	if value == nil then
		return Option.none()
	else
		return value
	end
end

function OptionTable:__newindex(key: any, value: any?): ()
	if value == nil then
		value = Option.none()
	end
	assert(value and Option.isOption(value), "value must be an Option, received:" .. tostring(value))
	if value:isNone() then
		rawset(self :: any, key, nil)
	else
		rawset(self :: any, key, value)
	end
end

return {
	empty = function<K, V>(): OptionTable<K, V>
		return setmetatable({}, OptionTable) :: any
	end,
	from = function<K, V>(t: { [K]: V }): OptionTable<K, V>
		local optionTable: OptionTable<K, V> = setmetatable({}, OptionTable) :: any
		for key, value in t do
			optionTable[key] = Option.from(value)
		end
		if table.isfrozen(t) then
			table.freeze(optionTable)
		end
		return optionTable :: any
	end,
}
