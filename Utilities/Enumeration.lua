Enumeration = {}

Enumeration.CreateFromGenerator = function(generator)
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	
	local wrappedGenerator = coroutine.wrap(generator, coroutine.yield)
	local iterate = function()
		return wrappedGenerator(coroutine.yield)
	end

	local started = false
	local current = nil
	
	t.Current = function()
		if not started then
			error("Cannot get value of an enumeration before it begins")
		else
			return current
		end
	end
	
	t.MoveNext = function()
		started = true
		current = iterate()
		return current ~= nil
	end
	
	mt.__call = function()
		if t.MoveNext() then
			return t.Current()
		else
			return nil
		end
	end
	
	t.Where = function(predicate)
		return Enumeration.CreateFromGenerator(function(yield)
			while t.MoveNext() do
				local n = t.Current()
				if n == nil then
					break
				end
				if (predicate(n)) then
					yield(n)
				end
			end
		end)
	end
	
	t.Select = function(mutation)
		return Enumeration.CreateFromGenerator(function(yield)
			while t.MoveNext() do
				yield(mutation(t.Current()))
			end
		end)
	end
	
	return t
end

Enumeration.CreateFromTable = function(tableT)
	return Enumeration.CreateFromGenerator(function(yield)
		for k, v in ipairs(tableT) do
			yield({Key = k, Value = v})
		end
	end)
end

local function TestQuery()
	local isEven = function(a)
		return math.mod(a, 2) == 0
	end
	
	local enumerator = Enumeration.CreateFromGenerator(function(yield)
		yield(1)
		yield(2)
		yield(3)
		yield(4)
	end)
	
	local increment = function(a)
		return a + 1
	end
	
	local i = 2
	for k in enumerator.Select(increment) do
		if i ~= k then
			error("Failed to mutate")
		end
		i = i + 1
	end
	
	local evenFilter = function(a)
		return isEven(a)
	end
	
	local enumerator = Enumeration.CreateFromGenerator(function(yield)
		yield(1)
		yield(2)
		yield(3)
		yield(4)
	end)
	
	for k in enumerator.Where(evenFilter) do
		if not isEven(k) then
			error("Filter failed")
		end
	end
end

local function TestCreate()
	local enumerator = Enumeration.CreateFromTable({1, 2})
	
	if not enumerator.MoveNext() then
		error("Failed to move next")
	end
	if enumerator.Current().Value ~= 1 then
		error("Incorrect value " .. enumerator.Current())
	end
	if not enumerator.MoveNext() then
		error("Failed to move next")
	end
	if enumerator.Current().Value ~= 2 then
		error("Incorrect value " .. enumerator.Current())
	end
	if enumerator.MoveNext() then
		error("Failed to end enumeration")
	end
	
	local enumerator = Enumeration.CreateFromGenerator(function(yield)
		yield(1)
		yield(2)
		yield(3)
	end)
	
	local i = 1
	for k in enumerator do
		if i ~= k then
			error("Failed to iterate with a loop i = " .. k)
		end
		i = i + 1
	end
end

local function TestEnumeration()
	print(TestCreate())
	print(TestQuery())
end

TestEnumeration()