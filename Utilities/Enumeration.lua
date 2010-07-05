Enumeration = {}

Enumeration.Create = function(generator)
	local iter = coroutine.wrap(generator, coroutine.yield)
	return function()
		return iter(coroutine.yield)
	end
end

function f(yield)
	yield()
end

local a = Enumeration.Create(f)
