local _, g = ...
local TitleFrame = g.TitleFrame
local StatusFrame = g.StatusFrame
local FilterFrame = g.FilterFrame
local ItemFrame = g.ItemFrame
local REST = g.REST


local Frontend = {
    filter_frames = {},
    item_frames = {},

    old_filter_frames = {},
    old_item_frames = {}
}

--==# Constructor #==--

function Frontend:new(obj)
    obj = obj or {}
    self.__type = "Frontend"
    self.__index = self
    setmetatable(obj, self)

    obj:create_title()
    obj:create_status()

    obj:update_layout()

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function Frontend:create_title()
    self.title = TitleFrame:new({
        settings = self.settings,
        parent = UIParent 
    })

    self.title:set_point("TOPRIGHT", UIParent, "BOTTOMRIGHT", -100, 500)
    self.title:add_button("RIGHT", {
        icon = "Interface\\ICONS\\INV_Misc_EngGizmos_27.blp",
        func = function() print("CLOSE") end })
    self.title:add_button("RIGHT", {
        icon = "Interface\\ICONS\\INV_Misc_Gear_02.blp",
        func = function() LibStub("AceConfigDialog-3.0"):Open("CatBagCategories") end })
    self.title:add_button("LEFT", {
        icon = "Interface\\ICONS\\Ability_Creature_Cursed_04.blp",
        func = function()
            REST:Send("UPDATE_ITEMS")
            REST:Send("FILTER_ITEMS")
            REST:Send("UPDATE_LAYOUT")
        end })

    local pots = {
        -- "Interface\\ICONS\\INV_Potion_51.blp", -- Red
        -- "Interface\\ICONS\\INV_Potion_37.blp", -- Orange
        -- "Interface\\ICONS\\INV_Potion_58.blp", -- Yellow
        -- "Interface\\ICONS\\INV_Potion_93.blp", -- Green
        "Interface\\ICONS\\INV_Potion_72.blp", -- Blue
        -- "Interface\\ICONS\\INV_Potion_44.blp", -- Purple
    }

    for i,v in ipairs(pots) do
        local off = "Interface\\ICONS\\INV_Potion_86.blp"
        local on = v
        self.title:add_button("LEFT", {
            icon = off,
            func = function(btn)
                btn.show_hidden = not btn.show_hidden
                if btn.show_hidden then 
                    btn:set_icon(on) 
                else
                    btn:set_icon(off) 
                end            
            end 
        })
    end
end

function Frontend:create_status()
    self.status = StatusFrame:new({
        parent = self.title.frame
    })

    local pad = REST:Get("SETTINGS").padding
    self.status:set_point("TOPLEFT", self.title.frame, "BOTTOMLEFT", 0, -pad)
end

function Frontend:update_layout()
    self:recycel_frames()

    local pad = REST:Get("SETTINGS").padding
    local prev_frame = self.title.frame
    for i,filter in ipairs(REST:Get("FILTERS")) do
        if #filter.items > 0 then
            local filter_frame = self:get_filter_frame(filter)
            filter_frame:set_point("TOPLEFT", prev_frame, "BOTTOMLEFT", 0, -pad)
            filter_frame:set_item_frames(self:get_item_frames(filter.items))
            prev_frame = filter_frame.wrapper
        end
    end

    self.status:set_point("TOPLEFT", prev_frame, "BOTTOMLEFT", 0, -pad)
end

function Frontend:get_filter_frame(filter)
    local frame = nil

    if #self.old_filter_frames > 0 then
        frame = table.remove(self.old_filter_frames, #self.old_filter_frames)
    else
        frame = FilterFrame:new({ parent = self.title.frame })
    end

    frame:set_filter(filter)
    table.insert(self.filter_frames, frame)
    frame.wrapper:Show()

    return frame
end

function Frontend:get_item_frame(item)
    local frame = nil

    if #self.old_item_frames > 0 then
        frame = table.remove(self.old_item_frames, #self.old_item_frames)
    else
        frame = ItemFrame:new({ parent = self.title.frame })
    end

    frame:set_item(item)
    table.insert(self.item_frames, frame)
    frame.frame:Show()

    return frame
end

function Frontend:get_item_frames(items)
    local frames = {}

    for _,item in ipairs(items) do
        table.insert(frames, self:get_item_frame(item))
    end

    return frames
end

function Frontend:recycel_frames()
    for _, filter_frame in ipairs(self.filter_frames) do
        filter_frame.wrapper:Hide()
        table.insert(self.old_filter_frames, filter_frame)
    end

    for _, item_frame in ipairs(self.item_frames) do
        item_frame.frame:Hide()
        table.insert(self.old_item_frames, item_frame)
    end

    table.wipe(self.filter_frames)
    table.wipe(self.item_frames)    
end

--==# Export #==--

g.Frontend = Frontend