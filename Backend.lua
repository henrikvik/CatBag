Backend = {
    items = {},
    filters = {}
}

--==# Constructor #==--

function Backend:new(obj)
    obj = obj or {}
    self.__index = self
    setmetatable(obj, self)
    return obj
end

--==# Member Functions #==--

function Backend:addFilter(string)

end