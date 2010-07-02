-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

Set = {}

Set.new = function(initialValues)
	local t = {}
	local functions = {}
	local size = 0
	
	functions.Values = function()
		return t
	end
	
	functions.Size = function()
		return size
	end
	
	functions.Add = function(value)
		t[value] = true
		size = size + 1
	end
	
	functions.Contains = function(value)
		return t[value] ~= nil
	end
	
	functions.Remove = function(value)
		local inSet = functions.Contains(value)
		if (inSet) then
			t[value] = nil
			size = size - 1
		end
		return inSet
	end
	
	functions.Union = function(set)
		local newT = Set.new()
		
		for k, _ in pairs(set) do newT.Add(k) end
		for k, _ in pairs(t) do newT.Add(k) end
		
		return newT
	end
	
	functions.Difference = function(set)
		local newT = Set.new()
		
		for k, _ in pairs(t) do
			if (not set.Contains(k)) then
				newT.Add(k)
			end
		end
		
		return newT
	end
	
	functions.Intersection = function(set)
		local newT = Set.new()
		
		for k, _ in pairs(t) do
			if (set.Contains(k)) then
				newT.Add(k)
			end
		end
		
		return newT
	end
	
	local mt = {
		__add = function(a, b)
			return a.Union(b)
		end,
		__sub = function(a, b)
			return a.Difference(b)
		end,
		__pow = function(a, b)
			return a.Intersection(b)
		end
	}
	setmetatable(functions, mt)
	
	if (initialValues ~= nil) then
		for _, v in pairs(initialValues) do
			functions.Add(v)
		end
	end
	
	return functions
end