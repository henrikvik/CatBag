local _, package = ...

local ItemFrame = {}

--==# Constructor #==--

function ItemFrame:new(obj)
    obj = obj or {}
    self.__type = "ItemFrame"
    self.__index = self
    setmetatable(obj, self)

    obj:create_frame()
    obj:update()

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function ItemFrame:on_enter()
    return function()
        GameTooltip:SetOwner(self.frame,"ANCHOR_LEFT")
        GameTooltip:SetBagItem(self.item.bag_id,self.item.slot_id)
        GameTooltip:Show()
    end
end

function ItemFrame:on_leave()
    return function()
        GameTooltip:Hide()
    end
end

function ItemFrame:on_click()
    return function(f, btn)
        self.frame:RegisterEvent("BAG_UPDATE")
        
        if btn == "LeftButton" then
            self.item:pickup()
        end
    end
end

function ItemFrame:on_event()
    return function(f, event)
        if event == "BAG_UPDATE"  then
            self:update()
        end
    end
end

function ItemFrame:create_frame()
    local frame = CreateFrame("Button", nil, self.parent, "SecureActionButtonTemplate")
    self.frame = frame
    frame.self = self
    frame:SetHeight(self.settings.size)
    frame:SetWidth(self.settings.size)

    frame:SetAttribute("type2", "item")
    frame:SetAttribute("item", self.item.bag_id.." "..self.item.slot_id)
    
    frame:RegisterForDrag("LeftButton")
    frame:RegisterForClicks("LeftButtonUp","RightButtonUp")
    
    
    frame:SetScript("OnDragStart", self:on_click())
    frame:HookScript("OnClick", self:on_click())
    frame:SetScript("OnEvent", self:on_event())
    frame:SetScript("OnEnter", self:on_enter())
    frame:SetScript("OnLeave", self:on_leave())



    local inset = 2
    frame.border = CreateFrame("FRAME", nil, frame)
    frame.border:SetPoint("TOPLEFT", frame, "TOPLEFT", -inset, inset)
    frame.border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", inset, -inset)
    frame.border:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border.blp",
        edgeSize = 16
    })

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(frame)
    frame.bg:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot.blp")
    
    frame.hi_q = frame:CreateTexture(nil, "OVERLAY")
    frame.hi_q:SetBlendMode("ADD")
    frame.hi_q:SetTexture("Interface\\BUTTONS\\CheckButtonHilight.blp")
    frame.hi_q:SetVertexColor(1, 0.8, 0, 1)
    frame.hi_q:SetAllPoints(frame)
    frame.hi_q:SetDesaturated(true)

    if not self.item.quest_item then frame.hi_q:Hide() end

    frame.hi = frame:CreateTexture(nil, "HIGHLIGHT")
    frame.hi:SetBlendMode("ADD")
    frame.hi:SetTexture("Interface\\BUTTONS\\CheckButtonHilight.blp")
    frame.hi:SetVertexColor(0.5,0.75,1,0.75)
    frame.hi:SetAllPoints(frame)
    frame.hi:SetDesaturated(true)
end

function ItemFrame:get_quality_color()
    local r, g, b = GetItemQualityColor(self.item.quality)
    r = (r + 0.1) * math.min(1, math.max(0.66, self.item.quality))
    g = (g + 0.1) * math.min(1, math.max(0.66, self.item.quality))
    b = (b + 0.1) * math.min(1, math.max(0.66, self.item.quality))
    return r, g, b
end

function ItemFrame:update()
    self.frame:UnregisterEvent("BAG_UPDATE")
    
    self.item:update()
    self.frame.bg:SetTexture(self.item.icon_texture)

    local r, g, b = self:get_quality_color()
    self.frame.border:SetBackdropBorderColor(r, g, b, 1)

    if self.item.quest_item then 
        self.frame.hi_q:Show()
    else
        self.frame.hi_q:Hide()
    end    
end

--==# Export #==--

package.ItemFrame = ItemFrame