Filter = {
    code = "function(item) return false end",
    func = function(item) return false end
}

--==# Constructor #==--

function Filter:new(obj)
    obj = obj or {}
    self.__index = self
    self.__type = "Filter"
    setmetatable(obj, self)
    return obj
end

--==# Functions #==--

function Filter:filter_items(item_list)
    
end