List = {
}

--==# Constructor #==--

function List:new(obj)
    obj = obj or {}
    self.__index = self
    self.__type = "List"
    setmetatable(obj, self)
    return obj
end

--==# Functions #==--

