require "Utilities/Set"

Pipes = {}
Pipes.Subscriptions = {}

PipeManager.Send(name, data)
	local p = Pipes.Subscriptions[name]
	if (p ~= nil) then
		local enumerator = p.Enumerator()
		for k in enumerator do
			k.OnData(data)
		end
	end
end

PipeManager.Subscribe(name, onDataFunc)
	local sub = {}
	sub.OnData = onDataFunc
	sub.Name = name
	
	sub.Unsubscribe = function()
		return Pipes.Subscriptions[name].Remove(sub)
	end

	if (Pipes.Subscriptions[name] == nil) then
		Pipes.Subscriptions[name] = Set.new({})
	Pipes.Subscriptions[name].Add(sub)
	
	return sub
end