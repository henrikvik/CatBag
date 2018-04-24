local _, package = ...
local Item = package.Item
local assert_type = package.assert_type
local type_name = package.type_name


local Filter = {
    name = "New Filter",
    code = "function(item)\n    return false\nend",
    func = function(item) return false end,
    items = {}
}

--==# Constructor #==--

function Filter:new(obj)
    obj = obj or {}
    self.__type = "Filter"
    self.__index = self
    setmetatable(obj, self)

    if (obj.code) then
        obj:set_code(obj.code)
    end
    
    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function Filter:filter_items(items, passed)
    local failed = {}

    assert_type(items, "table")
    for _, item in ipairs(items) do
        assert_type(item, "Item")

        if self.func(item) then
            table.insert(passed, item)
        else
            table.insert(failed, item)
        end
    end

    print(self.name .. ": " .. #items .. " items, " .. #passed .. " passed, " .. #failed .. " failed")
    

    return failed
end

function Filter:set_code(code)
    self.code = code
    self.func = loadstring("return " .. code)()
end

function Filter:validate_code(code)
    local s1, r1 = xpcall(function()
        return loadstring("return " .. code)()
    end, function(err) 
        return err
    end)

    if not s1 then return r1 end

    local s2, r2 = xpcall(function()
        if r1(Item:new():protected_clone()) then end
    end, function(err) 
        return err
    end)

    -- if not s2 then return r2 end
    
    -- local r_type = type_name(r2)
    -- if r_type ~= "boolean" then
    --     return "Function return type has to be boolean." ..
    --         " (currently " .. r_type .. ")"
    -- end

    return true
end

--==# Export #==--

package.Filter = Filter