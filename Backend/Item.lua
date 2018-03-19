Item = {
    ilevel = 0
}

--==# Constructor #==--

function Item:new(obj)
    obj = obj or {}
    self.__type = "Item"
    self.__index = self
    setmetatable(obj, self)
    return obj
end

--==# Meta Functions #==--

function Item:__tostring()
    return "Item {}"
end

--==# Member Functions #==--

