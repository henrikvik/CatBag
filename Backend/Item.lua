local _, CatBag = ...
local assert_type = CatBag.assert_type
local type_name = CatBag.type_name


local Item = {
    bag_id       = -1,
    slot_id      = -1,

    id = -1,

    name      = "",
    base_type = "",
    sub_type  = "",
    equip_loc = "",
    
    rarity         = -1,
    quality        = -1,
    level          = -1,
    min_level      = -1,
    stack_count    = -1,
    stack_size     = -1,
    sell_price     = -1,
    durability     = -1,
    max_durability = -1,

    class_id     = -1,
    sub_class_id = -1,
    bind_id      = -1,
    expac_id     = -1,
    set_id       = -1,
    equip_id     = ""

    locked           = false,
    readable         = false,
    lootable         = false,
    filtered         = false,
    crafting_reagent = false,
    quest_item       = false,
    starts_quest     = false,
    started_quest    = false,

    has_cooldown      = false,
    cooldown_start    = -1,
    cooldown_duration = -1,
    
    link         = "",
    icon_id      = -1,
    icon_texture = ""
}

--==# Constructor #==--

function Item:new(obj)
    obj = obj or {}
    self.__type = "Item"
    self.__index = self
    setmetatable(obj, self)
    return obj
end

function Item:from_bag_slot(bag_id, slot_id)
    assert_type(bag_id, "number", slot_id, "number")

    local id = GetContainerItemID(self.bag_id, self.slot_id)
    if id then
        local obj = self:new()
    end

end

--==# Meta Functions #==--

function Item:__tostring()
    return "Item { id = "..self.id..", name = "..self.name.." }"
end

--==# Member Functions #==--

function Item:update()
    self.id = GetContainerItemID(self.bag_id, self.slot_id)

    if id then
        local icon_texture, count,      locked,     quality, 
            readable,     lootable,   link,       filtered 
            = GetContainerItemInfo(self.bag_id, self.slot_id)

        local name,         link,       rarity,     level, 
            min_level,    base_type,  sub_type,   stack_size,
            equip_loc,    icon_id,    sell_price, class_id,
            sub_class_id, bind_type,  expac_id,   set_id,
            crafting_reagent = GetItemInfo(id) 

        local cd_start,     cd_dur,     cd_enabled 
            = GetContainerItemCooldown(self.bag_id, self.slot_id)

        local dur_current,  dur_maximum 
            = GetContainerItemDurability(self.bag_id, self.slot_id);

        local is_quest_item, quest_id, active_quest 
            = GetContainerItemQuestInfo(bag, slot)


        self.name           = name
        self.base_type      = base_type
        self.sub_type       = sub_type
        self.equip_loc      = _G[equip_loc]
        self.rarity         = rarity
        self.quality        = quality
        self.level          = level
        self.min_level      = min_level
        self.stack_count    = count
        self.stack_size     = stack_size
        self.sell_price     = sell_price
        self.durability     = dur_current
        self.max_durability = dur_maximum

        self.class_id     = class_id
        self.sub_class_id = sub_class_id
        self.bind_id      = bind_type
        self.expac_id     = expac_id
        self.set_id       = set_id
        self.equip_id     = equip_loc

        self.locked           = locked ~= nil
        self.readable         = readable ~= nil
        self.lootable         = lootable
        self.filtered         = fileterd
        self.crafting_reagent = crafting_reagent
        self.quest_item       = is_quest_item ~= nil
        self.starts_quest     = quest_id ~= nil
        self.started_quest    = active_quest ~= nil

        self.has_cooldown      = cd_enabled == 1
        self.cooldown_start    = cd_start
        self.cooldown_duration = cd_dur

        self.link         = link
        self.icon_id      = icon_id
        self.icon_texture = icon_texture
    end
end

function Item:empty()
    return id ~= nil
end

function Item:use()
    UseContainerItem(self.bag_id, self.slot_id)
end

function Item:pickup(amount)
    if type_name(amount) == "number" then
        SplitContainerItem(self.bag_id, self.slot_id, amount)
    else
        PickupContainerItem(self.bag_id, self.slot_id)
    end
end

--==# Export #==--

CatBag.Item = Item