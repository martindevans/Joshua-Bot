Query = {}

local function MakeResultTable(collection)
	local t = {}
	if collection.Queryable then
		Query.MakeQueryable(t)
	end
	return t
end

Query.Where = function(collection, func)
	local result = MakeResultTable(collection)

	for k, v in pairs(collection) do
		if func(k, v) then
			result[k] = v
		end
	end

	return result
end

Query.Select = function(collection, func)
	local result = MakeResultTable(collection)

	for k, v in pairs(collection) do
		k2, v2 = func(k, v)
		result[k2] = v2
	end

	return result
end

Query.SelectMany = function(collection, func)
	local result = MakeResultTable(collection)

	for k, v in pairs(collection) do
		local t = func(k, c)
		for tk, tv in pairs(t) do
			result[tk] = tv
		end
	end

	return result
end

Query.MakeQueryable = function(collection)
	collection.Where = Query.Where
	collection.Select = Query.Select
	collection.SelectMany = Query.SelectMany
	collection.Queryable = true
end

local function WhereTestFunction(k, v)
	return k == "apple"
end

local function TestWhere()
	local t = {
		apple="green",
		orange="orange",
		banana="yellow"
	}
	local result = Query.Where(t, WhereTestFunction)
	return result.apple == 'green' and result.orange == nil
end

local function SelectTestFunction(k, v)
	return k, k * 2
end

local function TestSelect()
	local t = { [1]=1,[2]=2, [3]=3 }
	local result = Query.Select(t, SelectTestFunction)
	for k, v in pairs(result) do
		if k ~= v / 2 then
			return false
		end
	end
	return true
end

local function TestQuery()
	print(TestWhere())
	print(TestSelect())
end

TestQuery()
