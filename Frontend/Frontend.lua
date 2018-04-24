local _, package = ...
local FilterFrame = package.FilterFrame
local ItemFrame = package.ItemFrame

local Frontend = {
    settings = {},
    backend = {}
}

--==# Constructor #==--

function Frontend:new(obj)
    obj = obj or {}
    self.__type = "Frontend"
    self.__index = self
    setmetatable(obj, self)

    obj.wrapper = obj:create_wrapper_frame()
    obj.title   = obj:create_title_frame()
    obj.status  = obj:create_status_frame()

    obj:update_currency()

    return obj
end

--==# Meta Functions #==--

--==# Utility Functions #==--

function Frontend:calc_width(num_items)
    return (self.settings.item.size + self.settings.item.padding)
        * num_items - self.settings.item.padding
end

--==# Member Functions #==--

function Frontend:create_wrapper_frame()
    local frame = CreateFrame("Frame", "CatBag", UIParent)

    frame:SetWidth(self:calc_width(self.settings.width))
    frame:SetHeight(frame:GetWidth())

    frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -100, 100)

    frame:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border.blp",
        edgeSize = 8
    })
    frame:SetBackdropBorderColor(0,0,0,1)

    frame:SetMovable(true)

    return frame
end

function Frontend:create_button_frame(parent, name, icon, func)
    local pad, size = self.settings.padding, self.settings.font.title
    local btn = CreateFrame("Button", nil, parent)

    btn:SetWidth(size)
    btn:SetHeight(size)

    btn.icon = btn:CreateTexture(nil, "OVERLAY")
    btn.icon:SetTexture(icon)
    btn.icon:SetAllPoints(true)

    btn.hlight = btn:CreateTexture(nil, "OVERLAY")
    btn.hlight:SetTexture(icon)
    btn.hlight:SetBlendMode("ADD")
    btn.hlight:SetDesaturated(true)
    btn.hlight:SetAllPoints(true)
    btn.hlight:SetAlpha(0.5)
    btn.hlight:Hide()

    local inset = 5/64
    btn.icon:SetTexCoord(inset, 1-inset, inset, 1-inset)
    btn.hlight:SetTexCoord(inset, 1-inset, inset, 1-inset)

    local m_down = false
    local m_hover = false

    local function update() 
        if m_hover then 
            btn.hlight:Show() 
        else 
            btn.hlight:Hide() 
        end

        if m_hover then
            GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
            GameTooltip:SetText(name)
        else
            GameTooltip:Hide()
        end
    end

    local p1, f1, pf1, x1, y1
    local p2, f2, pf2, x2, y2
    local function update_down() 
        if m_down then
            p1, f1, pf1, x1, y1 = btn.icon:GetPoint(1)
            p2, f2, pf2, x2, y2 = btn.icon:GetPoint(2)
            btn.icon:SetPoint(p1, f1, pf1, x1+1, y1-1)
            btn.icon:SetPoint(p2, f2, pf2, x2+1, y2-1)
            btn.hlight:SetPoint(p1, f1, pf1, x1+1, y1-1)
            btn.hlight:SetPoint(p2, f2, pf2, x2+1, y2-1)
        else
            btn.icon:SetPoint(p1, f1, pf1, x1, y1)
            btn.icon:SetPoint(p2, f2, pf2, x2, y2)
            btn.hlight:SetPoint(p1, f1, pf1, x1, y1)
            btn.hlight:SetPoint(p2, f2, pf2, x2, y2)
        end
    end
    
    btn:SetScript("OnMouseDown", function() m_down = true;   update_down() end)
    btn:SetScript("OnMouseUp",   function() 
        m_down = false
        update_down()
        if m_hover then func() end
    end)
    btn:SetScript("OnEnter",     function() m_hover = true;  update() end)
    btn:SetScript("OnLeave",     function() m_hover = false; update() end)

    return btn
end

function Frontend:create_title_frame()
    local pad, font_size = self.settings.padding, self.settings.font.title
    local frame = CreateFrame("Frame", nil, self.wrapper)

    frame:SetHeight(pad * 2 + font_size)
    frame:SetPoint("BOTTOMLEFT", self.wrapper, "TOPLEFT", 0, pad)
    frame:SetPoint("BOTTOMRIGHT", self.wrapper, "TOPRIGHT", 0, pad)

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    -- frame.bg:SetTexture("Interface\\Tooltips\\CHATBUBBLE-BACKGROUND.BLP")
    frame.bg:SetColorTexture(0,0,0,0.66)
    frame.bg:SetAllPoints(frame)

    frame.text = frame:CreateFontString(nil, "OVERLAY")
    frame.text:SetFont("Fonts\\FRIZQT__.TTF", font_size)
    frame.text:SetText("CatBag")
    frame.text:SetPoint("CENTER")

    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function() self.wrapper:StartMoving() end)
    frame:SetScript("OnDragStop", function() self.wrapper:StopMovingOrSizing() end)

    frame.close = self:create_button_frame(frame, "Close",
        "Interface\\ICONS\\Boss_OdunRunes_Orange.blp",
        function()
            print("CLOSE")
        end
    )
    frame.options = self:create_button_frame(frame, "Config",
        "Interface\\ICONS\\Boss_OdunRunes_Yellow.blp",
        function()
            print("SETTINGS")
        end
    )
    frame.update = self:create_button_frame(frame, "Sort",
        "Interface\\ICONS\\Boss_OdunRunes_Blue.blp",
        function()
            print("UPDATE")
        end
    )
    local hidden = false
    local not_hidden_icon = "Interface\\ICONS\\Boss_OdunRunes_Green.blp"
    local hidden_icon = "Interface\\ICONS\\Pet_Type_Undead.blp"
    frame.hide = self:create_button_frame(frame, "Toggle Hidden",
    not_hidden_icon,
        function()
            hidden = not hidden
            frame.hide.icon:SetDesaturated(hidden)

            -- if hidden then
            --     frame.hide.icon:SetTexture(hidden_icon)
            -- else 
            --     frame.hide.icon:SetTexture(not_hidden_icon)
            -- end
            print("TOGGLE")
        end
    )

    frame.close:SetPoint(   "RIGHT", frame,         "RIGHT", -pad, 0)
    frame.options:SetPoint( "RIGHT", frame.close,   "LEFT",  -pad, 0)
    frame.update:SetPoint(  "LEFT",  frame,         "LEFT",   pad, 0)
    frame.hide:SetPoint(    "LEFT",  frame.update,  "RIGHT",  pad, 0)

    

    return frame
end

function Frontend:create_content_frame()
    
end

function Frontend:create_status_frame()
    local pad, font_size = self.settings.padding, self.settings.font.title
    local frame = CreateFrame("Frame", nil, self.wrapper)

    frame:SetHeight(pad * 2 + font_size)
    frame:SetPoint("TOPLEFT", self.wrapper, "BOTTOMLEFT", 0, -pad)
    frame:SetPoint("TOPRIGHT", self.wrapper, "BOTTOMRIGHT", 0, -pad)

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    -- frame.bg:SetTexture("Interface\\Tooltips\\CHATBUBBLE-BACKGROUND.BLP")
    frame.bg:SetColorTexture(0,0,0,0.66)
    frame.bg:SetAllPoints(frame)

    frame.empty = self:create_currency_frame(frame, true)
    frame.empty:set_point("TOPRIGHT", frame, "TOPRIGHT", -pad, -pad)
    frame.empty:set_icon("Interface\\BUTTONS\\Button-Backpack-Up.blp")

    frame.gold = self:create_currency_frame(frame)
    frame.gold:set_point("TOPLEFT", frame, "TOPLEFT", pad, -pad)
    frame.gold:set_icon("Interface\\MONEYFRAME\\UI-GoldIcon.blp")
    
    local right_align = true
    frame.tracked = {}
    frame.tracked[1] = self:create_currency_frame(frame, right_align)
    frame.tracked[2] = self:create_currency_frame(frame, right_align)
    frame.tracked[3] = self:create_currency_frame(frame, right_align)
    
    frame.tracked[2]:set_point("LEFT", frame.gold.frame,  "RIGHT",  15, 0)
    frame.tracked[2]:set_point("LEFT", frame.tracked[1].frame,  "RIGHT",  15, 0)
    frame.tracked[3]:set_point("LEFT", frame.tracked[2].frame,  "RIGHT",  15, 0)

    local events = {
        "PLAYER_MONEY",
        "CHAT_MSG_CURRENCY",
        "CURRENCY_DISPLAY_UPDATE",
        "BAG_UPDATE"
    }
    for i,event in ipairs(events) do
        frame:RegisterEvent(event)
    end

    hooksecurefunc("BackpackTokenFrame_Update", function()
        print("HOOKED CURRENCY")        
        self:update_currency()
    end)
    
    frame:SetScript("OnEvent", function(w, e)
        print(e)
        self:update_currency()
    end)

    return frame
end

function Frontend:update_currency()
    self.status.gold:set_count(math.floor(GetMoney() / 10000))
    self.status.empty:set_count(#self.backend.empty)

    for i = 1, 3 do
        local _, count, icon, id = GetBackpackCurrencyInfo(i)
        self.status.tracked[i]:set_count(count)
        self.status.tracked[i]:set_icon(icon)
    end

    local t = self.status.tracked    
    local w = -15
    for i = 1, GetNumWatchedTokens() do
        w = w + 15 + t[i]:get_width()
    end    

    t[1]:set_point("LEFT", self.status, "CENTER", -w/2, 0)
end


function Frontend:create_currency_frame(parent, right_aligned)
    local pad, font_size = self.settings.padding, self.settings.font.title
    
    local frame = CreateFrame("Frame", nil, parent)
    
    frame.icon = frame:CreateTexture(nil, "ARTWORK")
    frame.icon:SetWidth(font_size)
    frame.icon:SetHeight(font_size)

    local icon_inset = 0.07
    frame.icon:SetTexCoord(
        0 + icon_inset, 1 - icon_inset,
        0 + icon_inset, 1 - icon_inset
    )

    frame.count = frame:CreateFontString(nil, "OVERLAY")
    frame.count:SetFont("Fonts\\FRIZQT__.TTF", font_size)

    if right_aligned then
        frame.icon:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
        frame.count:SetPoint("RIGHT", frame.icon, "LEFT", -pad, 0)
    else
        frame.icon:SetPoint("LEFT", frame, "LEFT", 0, 0)
        frame.count:SetPoint("LEFT", frame.icon, "RIGHT", pad, 0)
    end

    frame:SetHeight(frame.icon:GetHeight())
    frame:SetWidth(
        font_size + pad + 
        frame.count:GetStringWidth()
    )

    local function set_count(self, count)
        
        if (count or 0) > 999 then
            count = math.floor(count / 100)
            count = count / 10
            count = string.format("%.1fk", count)
        end

        frame.count:SetText(count)
        frame:SetWidth(
            frame.icon:GetHeight() + pad + 
            frame.count:GetStringWidth()
        ) 
    end

    local function set_icon(self, icon)
        frame.icon:SetTexture(icon)
    end

    local function set_point(self, p, f, pf, x, y)
        frame:SetPoint(p, f, pf, x, y)
    end
    
    local function get_width(self)
        return frame:GetWidth()
    end
    

    return {
        frame = frame,
        set_count = set_count,
        set_icon = set_icon,
        set_point = set_point,
        get_width = get_width
    }
end


function Frontend:create_bag_frame()
    local frame = CreateFrame("FRAME", "CatBagFrame", UIParent)
    self.bag_frame = frame
    frame:SetFrameStrata("BACKGROUND")
    frame:SetWidth(self:calc_frame_width() + self.settings.padding * 2)
    frame:SetHeight(self.settings.font.title + self.settings.padding * 2)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetTexture("Interface\\Tooltips\\CHATBUBBLE-BACKGROUND.BLP")
    frame.bg:SetAllPoints(frame)

    frame.text = frame:CreateFontString(nil, "OVERLAY")
    frame.text:SetFont("Fonts\\FRIZQT__.TTF", self.settings.font.title)
    frame.text:SetText("CatBag")
    frame.text:SetPoint("CENTER")

    frame:SetPoint("CENTER", 0, 0)
    frame:Show()

    frame.filters = {}
    local prev = frame
    for i, filter in ipairs(self.backend.filters) do
        local filter_frame = self:create_filter_frame(filter, prev)
        table.insert(frame.filters, filter_frame)
        prev = filter_frame
    end
end

function Frontend:create_filter_frame(filter, prev)

    local ff = FilterFrame:new({
        filter = filter,
        parent = self.bag_frame,
        settings = self.settings,
        relative = prev
    })

    local frame = ff.wrapper

    return frame    
end


--==# Export #==--

package.Frontend = Frontend