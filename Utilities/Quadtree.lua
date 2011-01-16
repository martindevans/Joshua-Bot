require "Utilities/Enumeration"

Quadtree = {}

local function CreateNode(parent, minX, minY, maxX, maxY)
	local t = {}

	t.GetMinX = function()
		return minX
	end

	t.GetMaxX = function()
		return maxX
	end

	t.GetMinY = function()
		return minY
	end

	t.GetMaxY = function()
		return maxY
	end

	t.IsRoot = function()
		return parent == nil
	end

	local depth = 0
	if parent ~= nil then
		depth = parent.Depth() + 1
	end
	t.Depth = function()
		return depth
	end
	
	local isLeaf = true
	t.IsLeaf = function()
		return isLeaf
	end

	t.DrawNode = function(DrawBox, DrawNumber)
		if isLeaf then
			DrawBox(minX, minY, maxX, maxY)
			if DrawNumber then
				DrawNumber(t.Depth(), minX, minY, 5, 5)
			end
		else
			t.TopLeft.DrawNode(DrawBox)
			t.TopRight.DrawNode(DrawBox)
			t.BottomLeft.DrawNode(DrawBox)
			t.BottomRight.DrawNode(DrawBox)
		end
	end
	
	t.Subdivide = function(condition)
		if isLeaf and not condition or (condition(t)) then
			local midX = minX + (maxX - minX) / 2
			local midY = minY + (maxY - minY) / 2
			t.BottomLeft = CreateNode(t, minX, minY, midX, midY)
			t.BottomRight = CreateNode(t, midX, minY, maxX, midY)
			t.TopLeft = CreateNode(t, minX, midY, midX, maxY)
			t.TopRight = CreateNode(t, midX, midY, maxX, maxY)

			isLeaf = false

			if condition ~= nil then
				if (condition(t.BottomLeft)) then
					t.BottomLeft.Subdivide(condition)
				end
				if (condition(t.BottomRight)) then
					t.BottomRight.Subdivide(condition)
				end
				if (condition(t.TopLeft)) then
					t.TopLeft.Subdivide(condition)
				end
				if (condition(t.TopRight)) then
					t.TopRight.Subdivide(condition)
				end
			end
			return true
		end
		return false
	end

	t.Merge = function()
		if isLeaf then
			return false
		end

		t.TopLeft = nil
		t.TopRight = nil
		t.BottomLeft = nil
		t.BottomRight = nil

		isLeaf = true
	end

	t.Enumerate = function()
		return Enumeration.CreateFromGenerator(function(yield)
			yield(t)

			local enumerate = function(iter)
				while iter.MoveNext() do
					yield(iter.Current())
				end
			end

			if (t.TopLeft ~= nil) then
				enumerate(t.TopLeft.Enumerate())
			end

			if (t.TopRight ~= nil) then
				enumerate(t.TopRight.Enumerate())
			end

			if (t.BottomRight ~= nil) then
				enumerate(t.BottomRight.Enumerate())
			end

			if (t.BottomLeft ~= nil) then
				enumerate(t.BottomLeft.Enumerate())
			end
		end)
	end

	return t
end

Quadtree.new = function(minX, minY, maxX, maxY)
	local t = {}

	local root = CreateNode(nil, minX, minY, maxX, maxY)
	t.Root = root

	t.Enumerate = function()
		return Enumeration.CreateFromGenerator(function(yield)
			local enumerator = root.Enumerate()
			while enumerator.MoveNext() do
				yield(enumerator.Current())
			end
		end)
	end

	t.Draw = function(DrawLine)
		local drawbox = function(minX, minY, maxX, maxY)
			DrawLine(minX, minY, maxX, minY)
			DrawLine(maxX, minY, maxX, maxY)
			DrawLine(maxX, maxY, minX, maxY)
			DrawLine(minX, maxY, minX, minY)
		end

		root.DrawNode(drawbox)
	end

	return t
end

local function TestCreate()
	local qTree = Quadtree.new(0,0,10,20)

	if (qTree.Root.GetMinX() ~= 0) then
		return false
	elseif (qTree.Root.GetMinY() ~= 0) then
		return false
	elseif (qTree.Root.GetMaxX() ~= 10) then
		return false
	elseif (qTree.Root.GetMaxY() ~= 20) then
		return false
	else
		return true
	end
end

local function TestSubdivide()
	local qTree = Quadtree.new(0,0,10,20)

	if not qTree.Root.IsLeaf() then
		return false
	end

	qTree.Root.Subdivide()

	if qTree.Root.IsLeaf() then
		return false
	end

	if qTree.Root.TopLeft.GetMaxX() ~= 5 then
		return false
	end

	local iter = qTree.Enumerate()
	iter.MoveNext()
	if iter.Current() ~= qTree.Root then
		return "BAR"
	end

	return true
end

local function TestQuadtree()
	print(TestCreate())
	print(TestSubdivide())
end

TestQuadtree()
