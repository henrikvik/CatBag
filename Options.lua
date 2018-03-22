local _, CatBag = ...
local assert_type = CatBag.assert_type


local Options = {
    panel = {},
    name = nil
}

--==# Constructor #==--

function Options:new(obj)
    assert_type(obj.name, "string")
    assert_type(obj.backend, "Backend")
    
    obj = obj or {}
    self.__type = "Options"
    self.__index = self
    setmetatable(obj, self)

    obj.panel = CreateFrame("FRAME")
    obj.panel.name = obj.name
    obj.panel.parent = obj.parent
    InterfaceOptions_AddCategory(obj.panel)

    return obj
end


--==# Meta Functions #==--

--==# Member Functions #==--

--==# Export #==--

CatBag.Options = Options