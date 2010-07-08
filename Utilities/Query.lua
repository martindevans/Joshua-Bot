Enumeration = {}

Enumeration.Create = function(generator)
	local iter = coroutine.wrap(generator, coroutine.yield)
	return function()
		return iter(coroutine.yield)
	end
end


Query = {}

--Returns an enumerator which returns all items which pass a filter
--collection, a collection to enumerate
--func, a function which takes 2 arguments (key and value) and returns a boolean
--returns, an enumerator function which yields 2 values (key and value)
Query.Where = function(collection, func)
	return Enumeration.Create(function(yield)
		for k, v in pairs(collections) do
			if (func(k, v)) then
				yield(k, v)
			end
		end
	end)
end

--Returns an enumerator which returns all the items after they've been modified
--collection, a collection to enumerate
--func, a function which takes 2 arguments (key and value) and returns 2 values (key and value)
--returns, an enumerator function which yields 2 values (key and value)
Query.Select = function(collection, func)
	return Enumeration.Create(function(yield)
		for k, v in pairs(collection) do
			yield(func(k, v))
		end
	end)
end

Query.SelectMany = function(collection, func)
	return Enumeration.Create(function(yield)
		for k, v in pairs(collection) do
			while true do
				local key, value = iter()
				if (key == nil) then
					break
				end
				yield(key, val)
			end
		end
	end)
end

Query.MakeQueryable = function(collection)
	collection.Where = function(func)
		return Query.Where(collection, func)
	end
	collection.Select = function(func)
		return Query.Select(collection, func)
	end
	collection.SelectMany = function(func)
		return Query.SelectMany(func)
	end
end
