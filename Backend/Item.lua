local _, package = ...
local assert_type = package.assert_type
local type_name = package.type_name
local merge_table = package.merge_table



local Item = {
    bag_id       = -1,
    slot_id      = -1,
    id = -1,

    -- BOOLEAN VALUES -- 
    consumable       = false,
    crafting_reagent = false,
    equippable       = false,
    filtered         = false,
    locked           = false,
    lootable         = false,
    quest_item       = false,
    readable         = false,
    started_quest    = false,
    starts_quest     = false,
    has_spell        = false,
    usable           = false,

    -- STRING VALUES --
    base_type      = "",
    equip_id       = "",
    equip_location = "",
    link           = "",
    name           = "",
    spell_name     = "",
    spell_rank     = "",
    sub_type       = "",
    tooltip        = "",
}

--==# Constructor #==--

function Item:new(obj)
    obj = obj or {}
    self.__type = "Item"
    self.__index = self
    setmetatable(obj, self)

    obj:update()

    if obj.bag_id == 0 and obj.slot_id == 1 then
        _G["ITEM"] = obj
    end

    return obj
end

--==# Meta Functions #==--

function Item:__tostring()
    return "Item { id = "..(self.id or -1)..", name = "..(self.name or "").." }"
end

--==# Member Functions #==--

function Item:update()
    local bag_id, slot_id = self.bag_id, self.slot_id
    table.wipe(self)
    self.bag_id, self.slot_id = bag_id, slot_id
    
    self.id = GetContainerItemID(self.bag_id, self.slot_id)

    if not self:is_empty() then
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

        local   equippable, consumable, usable
            = IsEquippableItem(self.id), IsConsumableItem(self.id), IsUsableItem(self.id)

        local   tooltip
            = self:get_tooltip()
        
        -- STRING
        self.base_type      = base_type
        self.equip_id       = equip_loc
        self.equip_location = _G[equip_loc] or ""
        self.link           = link
        self.name           = name
        self.spell_name     = spell_name or ""
        self.spell_rank     = spell_rank or ""
        self.sub_type       = sub_type 
        self.tooltip        = tooltip

        -- NUMBER
        self.quality        = quality
        self.item_level     = level
        self.required_level = min_level
        self.stack_count    = count
        self.stack_size     = stack_size
        self.sell_price     = sell_price
        self.durability     = dur_current
        self.max_durability = dur_maximum
        self.class_id       = class_id
        self.sub_class_id   = sub_class_id
        self.bind_id        = bind_type
        self.expac_id       = expac_id
        self.set_id         = set_id

        -- BOLEAN
        self.consumable       = consumable
        self.crafting_reagent = crafting_reagent
        self.equippable       = equippable
        self.filtered         = filtered
        self.locked           = locked == 1
        self.lootable         = lootable
        self.quest_item       = is_quest_item ~= nil
        self.readable         = readable == 1
        self.started_quest    = active_quest ~= nil
        self.starts_quest     = quest_id ~= nil
        self.has_spell        = spell_id ~= nil
        self.usable           = usable

        -- DEV
        self.icon_id      = icon_id
        self.icon_texture = icon_texture
    else
        self.icon_texture = "Interface\\PaperDoll\\UI-Backpack-EmptySlot.blp"
        self.quality      = 0
    end
end

function Item:get_tooltip()
    local tooltip = ""

    if not self:is_empty() then
        GameTooltip:SetOwner(UIParent,"ANCHOR_NONE")
        GameTooltip:SetBagItem(self.bag_id, self.slot_id)
        for k=2,GameTooltip:NumLines(),1 do
        local text = _G["GameTooltipTextLeft"..k]:GetText() or ""
            tooltip = tooltip .. "\n" .. text
        end

        GameTooltip:Hide()
    end

    return tooltip
end

function Item:is_empty()
    return self.id == -1
end

function Item:use()
    UseContainerItem(self.bag_id, self.slot_id, nil, true)
end

function Item:pickup(amount)
    if type_name(amount) == "number" then
        SplitContainerItem(self.bag_id, self.slot_id, amount)
    else
        PickupContainerItem(self.bag_id, self.slot_id)
    end
end


local clone = {}
local function no_write(self, k, v)
    error("Item is write protected.")
end
setmetatable(clone, clone)

function Item:protected_clone()
    table.wipe(clone)
    clone.__index = self
    clone.__newindex = no_write
    return clone
end

--==# Export #==--

package.Item = Item