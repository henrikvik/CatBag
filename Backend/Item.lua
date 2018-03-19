Item = {
    bag_id       = -1,
    slot_id      = -1,

    id           = -1,

    name         = "",
    base_type    = "",
    sub_type     = "",
    equip_loc    = "",
    
    rarity       = -1,
    quality      = -1,
    level        = -1,
    min_level    = -1,
    stack_count  = -1,
    stack_size   = -1,
    sell_price   = -1,

    class_id     = -1,
    sub_class_id = -1,
    bind_id      = -1,
    expac_id     = -1,
    set_id       = -1, 

    locked       = false,
    readable     = false,
    lootable     = false,
    is_filtered  = false,
    is_crafting_reagent = false,
    
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

    if rawget(obj, "bag_id") and rawget(obj, "slot_id") then
        assert_type(
            obj.bag_id, "number",
            obj.slot_id, "number"
        )
        obj:query_info()        
    end

    return obj
end

--==# Meta Functions #==--

function Item:__tostring()
    return "Item { id = "..self.id..", name = "..self.name.." }"
end

--==# Member Functions #==--

function Item:query_info()
    local id = GetContainerItemID(self.bag_id, self.slot_id)

    local icon_texture, count,      locked,     quality, 
          readable,     lootable,   link,       is_filtered 
          = GetContainerItemInfo(self.bag_id, self.slot_id)
          
    local name,         link,       rarity,     level, 
          min_level,    base_type,  sub_type,   stack_size,
          equip_loc,    icon_id,    sell_price, class_id,
          sub_class_id, bind_type,  expac_id,   set_id,
          is_crafting_reagent = GetItemInfo(id) 

    self.id           = id

    self.name         = name
    self.base_type    = base_type
    self.sub_type     = sub_type
    self.equip_loc    = _G[equip_loc]
    self.rarity       = rarity
    self.quality      = quality
    self.level        = level
    self.min_level    = min_level
    self.stack_count  = count
    self.stack_size   = stack_size
    self.sell_price   = sell_price

    self.class_id     = class_id
    self.sub_class_id = sub_class_id
    self.bind_id      = bind_type
    self.expac_id     = expac_id
    self.set_id       = set_id

    self.locked       = locked ~= nil
    self.readable     = readable ~= nil
    self.lootable     = lootable
    self.is_filtered  = is_fileterd
    self.is_crafting_reagent = is_crafting_reagent

    self.link         = link
    self.icon_id      = icon_id
    self.icon_texture = icon_texture
end