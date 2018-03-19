Filter = {
    name = "Unnamed Filter",
    code = "function(item) return false end",
    func = function(item) return false end
}

--==# Constructor #==--

function Filter:new(obj)
    obj = obj or {}
    self.__type = "Filter"
    self.__index = self
    setmetatable(obj, self)
    return obj
end

--==# Member Functions #==--

function Filter:filter_items(items)
    local passed = {}
    local failed = {}

    for _, item in ipairs(items) do
        assert_type(item, "Item")
        if self.func(item) then
            table.insert(passed, item)
        else
            table.insert(failed, item)
        end
    end

    return passed, failed
end

function Filter:set_filter_func(code)
    local func = loadstring("return " .. code)()
    assert_type(func(Item:new()), "boolean")
    self.code = code
    self.func = func
end

