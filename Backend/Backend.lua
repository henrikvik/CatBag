local _, package = ...
local Item = package.Item
local Filter = package.Filter

local Backend = {
    filters = {},
    items = {},
    empty = {}
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
    self.items = self.items or {}
    self.empty = self.empty or {}
    table.wipe(self.items)
    table.wipe(self.empty)

    for bag_id = 0, 4 do
        local slots = GetContainerNumSlots(bag_id)
        for slot_id = 1, slots do
            local item = Item:new({ bag_id  = bag_id, slot_id = slot_id});
            if not item:is_empty() then
                table.insert(self.items, item)
            else
                table.insert(self.empty, item)
            end
        end
    end
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
        filter.items = filter.items or {}
        table.wipe(filter.items)
        unfiltered_items = filter:filter_items(unfiltered_items, filter.items)
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