-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

Stack = {}

Stack.new = function()
	local t = {}
	
	local last = 0
	
	t.isEmpty = function()
		return last == 0
	end
	
	t.size = function()
		return last
	end
	
	t.push = function(value)
		t[last] = value
		last = last + 1
	end
	
	t.pop = function()
		local v = t[last - 1]
		last = last - 1
		return v
	end
	
	t.peek = function()
		return t[last - 1]
	end
	
	return t
end

function TestStack()
	local stack = Stack.new()
	
	stack.push("1")
	if (stack.peek() ~= "1") then
		error("Incorrect stack top " .. stack.peek())
	end
	stack.push("2")
	stack.push("3")
	stack.push("4")
	if (stack.pop() ~= "4") then
		error("Incorrect stack top " .. stack.peek())
	end
	if (stack.pop() ~= "3") then
		error("Incorrect stack top " .. stack.peek())
	end
	if (stack.pop() ~= "2") then
		error("Incorrect stack top " .. stack.peek())
	end
	if (stack.pop() ~= "1") then
		error("Incorrect stack top " .. stack.peek())
	end
	if (stack.size() ~= 0) then
		error("Incorrect stack top " .. stack.peek())
	end
	
	print "Stack works"
end