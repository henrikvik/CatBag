local _, CatBag = ...
local Item = CatBag.Item
local assert_type = CatBag.assert_type
local type_name = CatBag.type_name


local Filter = {
    name = "New Filter",
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

--==# Meta Functions #==--

--==# Member Functions #==--

function Filter:filter_items(items)
    local passed = {}
    local failed = {}

    assert_type(items, "table")
    for _, item in ipairs(items) do
        assert_type(item, "Item")
        local clone = {}
        if not item:empty() and self.func(item) then
            table.insert(passed, item)
        else
            table.insert(failed, item)
        end
    end

    return passed, failed
end

function Filter:eval_func(code)
    local func = loadstring("return " .. code)()
    if type_name(func(Item:new())) == "boolean" then
        self.code = code
        self.func = func
        return true
    end
    return false
end

--==# Export #==--

CatBag.Filter = Filter