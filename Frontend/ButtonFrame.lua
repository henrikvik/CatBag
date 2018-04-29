local _, package = ...

local ButtonFrame = {}

--==# Constructor #==--

function ButtonFrame:new(obj)
    obj = obj or {}
    self.__type = "ButtonFrame"
    self.__index = self
    setmetatable(obj, self)

    obj.frame = obj:create_button_frame()

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function ButtonFrame:set_point(p, f, fp, x, y)
    self.frame:SetPoint(p, f, fp, x, y)
end

function ButtonFrame:set_icon(icon)
    self.icon = icon
    self.frame.icon:SetTexture(self.icon)
    self.frame.hlight:SetTexture(self.icon)    
end

function ButtonFrame:create_button_frame()
    local pad, size = self.settings.padding, self.settings.font.title
    local btn = CreateFrame("Button", nil, self.parent)

    btn:SetWidth(size)
    btn:SetHeight(size)

    btn.icon = btn:CreateTexture(nil, "OVERLAY")
    btn.icon:SetTexture(self.icon)
    btn.icon:SetAllPoints(true)

    btn.hlight = btn:CreateTexture(nil, "OVERLAY")
    btn.hlight:SetTexture(self.icon)
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
        if m_hover then self.func(self) end
    end)
    btn:SetScript("OnEnter",     function() m_hover = true;  update() end)
    btn:SetScript("OnLeave",     function() m_hover = false; update() end)

    return btn
end

--==# Export #==--

package.ButtonFrame = ButtonFrame