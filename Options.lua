local _, package = ...

local Options = {
    backend = {}
}

--==# Constructor #==--

function Options:new(obj)
    obj = obj or {}
    self.__type = "Options"
    self.__index = self
    setmetatable(obj, self)

    obj:create_frame()
    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function Options:create_frame()

end

function Options:create_filter_frame(name)

end


--==# Export #==--

package.Options = Options