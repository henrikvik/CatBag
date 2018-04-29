local _, package = ...
local Item = package.Item
local Filter = package.Filter

local Backend = {
    filters = {},
    slots = {},
    unfiltered = {}
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

function Backend:query_slots()
    self.slots = self.slots or {}
    for _,slot in ipairs(self.slots) do table.wipe(slot) end
    table.wipe(self.slots)

    for bag_id = 0, 4 do
        local num_slots = GetContainerNumSlots(bag_id)
        for slot_id = 1, num_slots do
            table.insert(self.slots,
                Item:new({ bag_id  = bag_id, slot_id = slot_id})
            )
        end
    end

    self:update_items()
end

function Backend:update_items()
    self.items = table.wipe(self.items or {})
    self.empty = table.wipe(self.empty or {})

    for i,slot in ipairs(self.slots) do
        slot:update()
        if not slot:is_empty() then
            table.insert(self.items, slot)
        else
            table.insert(self.empty, slot)
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
        filter.items = table.wipe(filter.items or {})        
        unfiltered_items = filter:filter_items(unfiltered_items, filter.items)
    end

    self.unfiltered = unfiltered_items
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