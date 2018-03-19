local _, CatBag = ...
local Item = CatBag.Item

local Backend = {
    items = {}
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
            if GetContainerItemID(bag_id, slot_id) then
                table.insert(self.items, Item:new({
                    bag_id  = bag_id,
                    slot_id = slot_id,
                }))
            end
        end
    end
    return self.items
end

--==# Export #==--

CatBag.Backend = Backend