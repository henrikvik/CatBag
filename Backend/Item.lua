local _, package = ...
local assert_type = package.assert_type
local type_name = package.type_name
local merge_table = package.merge_table



local Item = {
    bag_id       = -1,
    slot_id      = -1,
    id = -1,
}

--==# Constructor #==--

function Item:new(obj)
    obj = obj or {}
    self.__type = "Item"
    self.__index = self
    setmetatable(obj, self)

    obj:update()

    return obj
end

--==# Meta Functions #==--

function Item:__tostring()
    return "Item { id = "..self.id..", name = "..self.name.." }"
end

--==# Member Functions #==--

function Item:update()
    self.id = GetContainerItemID(self.bag_id, self.slot_id)

    if not self:empty() then
        local   icon_texture,   count,      locked,     quality, 
                readable,       lootable,   link,       filtered 
            = GetContainerItemInfo(self.bag_id, self.slot_id)

        local   name,           link,       rarity,     level, 
                min_level,      base_type,  sub_type,   stack_size,
                equip_loc,      icon_id,    sell_price, class_id,
                sub_class_id,   bind_type,  expac_id,   set_id,
                crafting_reagent 
                = GetItemInfo(self.id) 

        local   dur_current,    dur_maximum 
            = GetContainerItemDurability(self.bag_id, self.slot_id);

        local   is_quest_item,  quest_id,    active_quest 
            = GetContainerItemQuestInfo(self.bag_id, self.slot_id)
        
        local   spell_name,     spell_rank,  spell_id
            = GetItemSpell(self.id)

        local   equippable, consumable
            = IsEquippableItem(self.id), IsConsumableItem(self.id)

        self.name           = name
        self.base_type      = base_type
        self.sub_type       = sub_type
        self.equip_location = _G[equip_loc]
        self.rarity         = rarity
        self.quality        = quality
        self.item_level     = level
        self.required_level = min_level
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

        self.spell_name   = spell_name
        self.spell_rank   = spell_rank
    
        self.equippable       = equippable
        self.consumable       = consumable
        self.useable          = spell_id ~= nil
        self.locked           = locked == 1
        self.readable         = readable == 1
        self.lootable         = lootable
        self.filtered         = fileterd
        self.crafting_reagent = crafting_reagent
        self.quest_item       = is_quest_item ~= nil
        self.starts_quest     = quest_id ~= nil
        self.started_quest    = active_quest ~= nil

        self.link         = link
        self.icon_id      = icon_id
        self.icon_texture = icon_texture
    end
end

function Item:empty()
    return self.id == -1
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

function Item:clone(clone)
    clone = clone or {}
    merge_table(clone, self)
    return clone
end

--==# Export #==--

package.Item = Item