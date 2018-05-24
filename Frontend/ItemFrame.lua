local _, package = ...
local REST = package.REST


local ItemFrame = {}

--==# Constructor #==--

function ItemFrame:new(obj)
    obj = obj or {}
    self.__type = "ItemFrame"
    self.__index = self
    setmetatable(obj, self)

    obj:create_frame()
    
    if obj.item then
        obj:set_item(obj.item)
    end

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function ItemFrame:on_enter()
    return function()
        GameTooltip:SetOwner(self.frame,"ANCHOR_LEFT")
        GameTooltip:SetBagItem(self.item.bag_id,self.item.slot_id)
        GameTooltip:Show()

        if MerchantFrame:IsShown() then
            SetCursor("BUY_CURSOR")
        end
    end
end

function ItemFrame:on_leave()
    return function()
        GameTooltip:Hide()
        SetCursor("POINT_CURSOR")
    end
end

function ItemFrame:on_click()
    return function(f, btn)
        self.frame:RegisterEvent("BAG_UPDATE")
        
        if btn == "LeftButton" then
            self.item:pickup()
        end

        if btn == "MiddleButton" then
            tinspect(self.item)            
        end
    end
end

function ItemFrame:on_event()
    return function(f, event)
        if event == "BAG_UPDATE" then
            self.frame:UnregisterEvent("BAG_UPDATE")
            self.item:update()
            self:update()
        end
    end
end

function ItemFrame:set_item(item)
    self.item = item
    self.frame:SetAttribute("item", 
        self.item.bag_id .. " " .. self.item.slot_id)
    self:update()
end

function ItemFrame:set_point(p, f, fp, x, y)
    self.frame:SetPoint(p, f, fp, x, y)
end

function ItemFrame:set_parent(parent)
    self.frame:SetParent(parent)
end


function ItemFrame:create_frame()
    local settings = REST:Get("SETTINGS")
    
    local frame = CreateFrame("Button", nil, self.parent, "SecureActionButtonTemplate")
    frame:SetHeight(settings.item.size)
    frame:SetWidth(settings.item.size)
    frame:SetAttribute("type2", "item")
    frame:RegisterForDrag("LeftButton")
    frame:RegisterForClicks("LeftButtonUp","RightButtonUp", "MiddleButtonUp")
    frame:HookScript("OnClick", self:on_click()) 
    frame:SetScript("OnDragStart", self:on_click())
    frame:SetScript("OnEvent", self:on_event())
    frame:SetScript("OnEnter", self:on_enter())
    frame:SetScript("OnLeave", self:on_leave())


    local border = CreateFrame("FRAME", nil, frame)
    border:SetPoint("TOPLEFT", frame, "TOPLEFT", 
        -settings.item.border.inset, 
        settings.item.border.inset)
    border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 
        settings.item.border.inset, 
        -settings.item.border.inset)
    border:SetBackdrop({
        edgeFile = settings.item.border.texture,
        edgeSize = settings.item.border.size})
    frame.border = border


    local ss = frame:CreateFontString(nil, "OVERLAY")
    ss:SetFont("Fonts\\ARIALN.TTF", 14, "OUTLINE")
    ss:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 3)
    frame.ss = ss


    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot.blp")
    bg:SetAllPoints(frame)
    frame.bg = bg


    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(frame)
    frame.icon = icon


    local hi_q = frame:CreateTexture(nil, "OVERLAY")
    hi_q:SetTexture("Interface\\BUTTONS\\CheckButtonHilight.blp")
    hi_q:SetVertexColor(1, 0.8, 0, 1)
    hi_q:SetDesaturated(true)
    hi_q:SetBlendMode("ADD")
    hi_q:SetAllPoints(frame)
    hi_q:Hide()
    frame.hi_q = hi_q


    local hi = frame:CreateTexture(nil, "HIGHLIGHT")
    hi:SetTexture("Interface\\BUTTONS\\CheckButtonHilight.blp")
    hi:SetVertexColor(0.5,0.75,1,0.75)
    hi:SetDesaturated(true)
    hi:SetBlendMode("ADD")
    hi:SetAllPoints(frame)
    frame.hi = hi


    self.frame = frame
end

function ItemFrame:get_quality_color()
    local r, g, b = GetItemQualityColor(self.item.quality)
    r = (r + 0.1) * math.min(1, math.max(0.66, self.item.quality))
    g = (g + 0.1) * math.min(1, math.max(0.66, self.item.quality))
    b = (b + 0.1) * math.min(1, math.max(0.66, self.item.quality))
    return r, g, b
end

function ItemFrame:update()

    self.frame.icon:SetTexture(self.item.icon_texture)

    local r, g, b = self:get_quality_color()
    self.frame.border:SetBackdropBorderColor(r, g, b, 1)

    if self.item.quest_item then 
        self.frame.hi_q:Show()
    else
        self.frame.hi_q:Hide()
    end

    if (self.item.stack_count or 0) > 1 then
        self.frame.ss:SetText(self.item.stack_count)
    else
        self.frame.ss:SetText("")
    end
end

--==# Export #==--

package.ItemFrame = ItemFrame