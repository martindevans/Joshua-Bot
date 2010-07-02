Queue = {}

Queue.new = function()
	local t = {}
	
	local last = 0
	local first = 0
	
	t.isEmpty = function()
		return last == first
	end
	
	t.size = function()
		return last - first
	end
	
	t.enqueue = function(value)
		t[last] = value
		last = last + 1
	end
	
	t.dequeue = function()
		local v = t[first]
		first = first + 1
		return v
	end
	
	t.peek = function()
		return t[first]
	end
	
	return t
end