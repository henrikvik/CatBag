local _, package = ...

local REST = {
    listeners = {},
    getters = {}
}

--==# Constructor #==--

function REST:new(obj)
    obj = obj or {}
    self.__type = "REST"
    self.__index = self
    setmetatable(obj, self)
    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function REST:Register(query, func)
    self.getters[query] = func
end

function REST:Get(query, ...)
    return (self.getters[query] or nil_func)(...)
end

function REST:Listen(query, func)
    self.listeners[query] = self.listeners[query] or {}
    table.insert(self.listeners[query], func)
end

function REST:Send(query, ...)
    for i,func in ipairs(self.listeners[query]) do
        func(...)
    end
end
--==# Export #==--

package.REST = REST:new()