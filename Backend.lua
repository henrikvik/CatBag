local _, CatBag = ...
local Item = CatBag.Item
local Filter = CatBag.Filter

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
    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function Backend:query_items()
    self.items = {}
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
    table.insert(self.filters, Filter:new())
    return self.filters[#self.filters]
end

function Backend:filter_items()
    local unfiltered_items = self.items
    for index,filter in ipairs(self.filters) do
        filter.items, unfiltered_items
        = filter:filter_items(unfiltered_items)
    end
end

--==# Export #==--

CatBag.Backend = Backend