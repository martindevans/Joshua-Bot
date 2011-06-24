-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

---------------------------------------------------------------------------------------------------------
-- Implements a minmaxheap
-- A min/max heap allows efficient removal of both the minimum and maximum value in the heap
--
-- local heap = MinMaxHeap.new()
-- heap.Add(1)
--     heap.PeekMax() == 1
--     heap.PeekMin() == 1
-- heap.AddMany({2,3,4,5})
--     heap.PeekMax() == 5
--     heap.PeekMin() == 1
-- heap.DeleteMax() == 5
--     heap.PeekMax() == 4
--
-- The heap uses the > and < operators
-- to define custom ordering relations, simple set the "lt" metamethod on your objects before passing them into the heap
--
-- Check out the tests at the bottom of this file for more examples
---------------------------------------------------------------------------------------------------------

MinMaxHeap = {}

local function Swap(heap, indexA, indexB)
	local a = heap[indexA]
	heap[indexA] = heap[indexB]
	heap[indexB] = a
end

local function IsMinLevel(index)
	local level = math.floor(math.log(index + 1) / math.log(2))
	return (level % 2) == 0
end

local function Parent(index)
	if (index <= 0) then
		return -1
	end
	return math.floor((index - 1) / 2)
end

local function IndexLeftChild(index)
	return ((index + 1) * 2) - 1
end

local function IndexRightChild(index)
	return (index + 1) * 2;
end

local function IndexMinChildGrandchild(heapObject, index)
	local a = IndexLeftChild(index)
	local b = IndexRightChild(index)
	local d = ((a + 1) * 2)
	local c = d - 1
	local f = ((b + 1) * 2)
	local e = f - 1
	
	local size = heapObject.GetSize()
	local heap = heapObject.heap
	local indexMin = -1
	
	if (a < size) then
		indexMin = a
	end
	if (b < size and heap[b] < heap[indexMin]) then
		indexMin = b
	end
	if (c < size and heap[c] < heap[indexMin]) then
		indexMin = c
	end
	if (d < size and heap[d] < heap[indexMin]) then
		indexMin = d
	end
	if (e < size and heap[e] < heap[indexMin]) then
		indexMin = e
	end
	if (f < size and heap[f] < heap[indexMin]) then
		indexMin = f
	end
	
	return indexMin
end

local function IndexMaxChildGrandchild(heapObject, index)
	local a = IndexLeftChild(index)
	local b = IndexRightChild(index)
	local d = ((a + 1) * 2)
	local c = d - 1
	local f = ((b + 1) * 2)
	local e = f - 1
	
	local size = heapObject.GetSize()
	local heap = heapObject.heap
	local indexMin = -1
	
	if (a < size) then
		indexMin = a
	end
	if (b < size and heap[b] > heap[indexMin]) then
		indexMin = b
	end
	if (c < size and heap[c] > heap[indexMin]) then
		indexMin = c
	end
	if (d < size and heap[d] > heap[indexMin]) then
		indexMin = d
	end
	if (e < size and heap[e] > heap[indexMin]) then
		indexMin = e
	end
	if (f < size and heap[f] > heap[indexMin]) then
		indexMin = f
	end
	
	return indexMin
end

local function BubbleUpMax(heap, index)
	grandparent = Parent(Parent(index))
	if (grandparent < 0) then
		return index
	end
	if (heap[index] > heap[grandparent]) then
		Swap(heap, index, grandparent)
		return BubbleUpMax(heap, grandparent)
	end
	return index
end

local function BubbleUpMin(heap, index)
	grandparent = Parent(Parent(index))
	if (grandparent < 0) then
		return index
	end
	if (heap[index] < heap[grandparent]) then
		Swap(heap, index, grandparent)
		return BubbleUpMin(heap, grandparent)
	end
	return index
end

local function BubbleUp(heap, index)
	local parent = Parent(index)
	if (parent < 0) then
		return index
	end
	if (IsMinLevel(index)) then
		if (heap[index] > heap[parent]) then
			Swap(heap, index, parent)
			return BubbleUpMax(heap, parent)
		else
			return BubbleUpMin(heap, index)
		end
	else
		if (heap[index] < heap[parent]) then
			Swap(heap, index, parent)
			return BubbleUpMin(heap, parent)
		else
			return BubbleUpMax(heap, index)
		end
	end
end

local function TrickleDownMin(heapObject, index)
	local heap = heapObject.heap

	local m = IndexMinChildGrandchild(heapObject, index)
	if (m <= -1) then
		return
	end
	if (heap[m] < heap[index]) then
		if (m > (index + 1) *2) then
			--m is a grandchild index
			Swap(heap, m, index)
			local mParent = Parent(m)
			if (heap[m] > heap[mParent]) then
				Swap(heap, m, mParent)
			end
			TrickleDownMin(heapObject, m)
		else
			--m is a child index
			Swap(heap, m, index)
			TrickleDownMin(heapObject, index)
		end
	end
end

local function TrickleDownMax(heapObject, index)
	local heap = heapObject.heap

	local m = IndexMaxChildGrandchild(heapObject, index)
	if (m <= -1) then
		return
	end
	if (heap[m] > heap[index]) then
		if (m > (index + 1) * 2) then
			-- m is a grandchild
			Swap(heap, m, index)
			local mParent = Parent(m)
			if (heap[m] < heap[mParent]) then
				Swap(heap, m, mParent)
			end
			TrickleDownMax(heapObject, m)
		else
			-- m is a child
			Swap(heap, m, index)
			TrickleDownMax(heapObject, index)
		end
	end
end

local function TrickleDown(heapObject, index)
	if (IsMinLevel(index)) then
		TrickleDownMin(heapObject, index)
	else
		TrickleDownMax(heapObject, index)
	end
end

local function Heapify(heapObject)
	local size = heapObject.GetSize()
	local heap = heapObject.heap
	
	for i = math.floor(size / 2) - 1, 0, -1 do
		TrickleDown(heapObject, i)
	end
end

local function MaxIndex(heapObject)
	local size = heapObject.GetSize()
	local heap = heapObject.heap
	if (size == 0) then
		return -1
	elseif (size == 1) then
		return 0
	elseif (size == 2) then
		return 1
	elseif heap[1] > heap[2] then
		return 1
	else
		return 2
	end
end

MinMaxHeap.new = function()
	local t = {}
	
	local heap = {}
	t.heap = heap
	local size = 0
	
	t.GetSize = function()
		return size
	end
	
	t.Heapify = function()
		Heapify(t)
	end
	
	t.PeekMax = function()
		return heap[MaxIndex(t)]
	end
	
	t.PeekMin = function()
		return heap[0]
	end
	
	t.DeleteMax = function()
		local oldMax = t.PeekMax()
	
		if (t.GetSize() == 0) then
			error("Tried to remove max from an empty table")
		end
		if (t.GetSize() == 1) then
			size = 0
			heap[0] = nil
			return
		end
		if (t.GetSize() == 2) then
			table.remove(heap, 1)
			size = size - 1
			return
		end
		
		local maxPos = MaxIndex(t)
		local lastPos = t.GetSize() - 1
		if (maxPos == lastPos) then
			table.remove(heap, lastPos)
			size = size - 1
		else
			heap[maxPos] = heap[lastPos]
			table.remove(heap, lastPos)
			size = size - 1
			TrickleDown(t, maxPos)
		end
		
		return oldMax
	end
	
	t.DeleteMin = function()
		if (t.GetSize() == 0) then
			error("Tried to remove min from an empty table")
		end
		if (t.GetSize() <= 2) then
			size = size - 1
			table.remove(heap, 0)
			return
		end
		
		size = size - 1
		heap[0] = heap[t.GetSize() - 1]
		table.remove(heap, t.GetSize() - 1)
		TrickleDown(t, 0)
	end
	
	t.Add = function(value)
		table.insert(heap, t.GetSize(), value)
		size = size + 1
		BubbleUp(heap, t.GetSize() - 1)
	end
	
	t.AddMany = function(values)
		for _, v in pairs(values) do
			table.insert(heap, t.GetSize(), v)
			size = size + 1
		end
		Heapify(t)
	end
	
	return t
end

function TestHeap()
	local heap = MinMaxHeap.new()
	
	heap.Add(1)
	heap.Add(2)
	heap.Add(100)
	heap.Add(10)
	heap.Add(3)
	heap.Add(12)
	
	if (heap.PeekMax() ~= 100) then
		error("Incorrect max " .. heap.PeekMax())
	end
	if (heap.PeekMin() ~= 1) then
		error("Incorrect min " .. heap.PeekMin())
	end
	
	heap.DeleteMin()
	if (heap.PeekMax() ~= 100) then
		error("Incorrect max " .. heap.PeekMax())
	end
	if (heap.PeekMin() ~= 2) then
		error("Incorrect min " .. heap.PeekMin())
	end
	
	heap.AddMany({10, 11, 0, 12, 1000})
	if (heap.PeekMax() ~= 1000) then
		error("Incorrect max " .. heap.PeekMax())
	end
	if (heap.PeekMin() ~= 0) then
		error("Incorrect min " .. heap.PeekMin())
	end
	
	print "min max Heap works"
end