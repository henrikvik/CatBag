local _, package = ...
local Item = package.Item
local Filter = package.Filter

local Backend = {
    items = {},
    filters = {}
}

--==# Constructor #==--

function Backend:new(obj)
    obj = obj or {}
    self.__type = "Backend"
    self.__index = self
    setmetatable(obj, self)

    for i,filter in ipairs(obj.filters) do
        obj.filters[i] = Filter:new(filter)
    end    

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function Backend:query_items()
    table.wipe(self.items)
    self.items = self.items or {}
    for bag_id = 0, 4 do
        local slots = GetContainerNumSlots(bag_id)
        for slot_id = 1, slots do
            table.insert(self.items, Item:new({
                bag_id  = bag_id,
                slot_id = slot_id,
            }))
        end
    end
    return self.items
end

function Backend:new_filter()
    self.filters = self.filters or {}

    local i = 1
    local exists = true
    while exists do
        exists = self:filter_exists("Category " .. i)
        if exists then
            i = i + 1
        end
    end

    table.insert(self.filters, Filter:new({name = "Category " .. i}))
    return self.filters[#self.filters]
end

function Backend:filter_items()
    local unfiltered_items = self.items
    for index,filter in ipairs(self.filters) do
        filter.items, unfiltered_items
        = filter:filter_items(unfiltered_items)
    end
end

function Backend:filter_exists(name)
    local exists = false
    for index,filter in ipairs(self.filters) do
        if filter.name == name then
            exists = true
        end
    end
    return exists
end

--==# Export #==--

package.Backend = Backend