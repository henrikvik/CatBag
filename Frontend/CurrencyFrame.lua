local _, g = ...
local REST = g.REST


local CurrencyFrame = {}

--==# Constructor #==--

function CurrencyFrame:new(obj)
    obj = obj or {}
    self.__type = "CurrencyFrame"
    self.__index = self
    setmetatable(obj, self)

    obj.frame = obj:create_currency_frame()

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function CurrencyFrame:create_currency_frame()
    local settings = REST:Get("SETTINGS")
    local pad, font_size = settings.padding, settings.font.title
    
    local frame = CreateFrame("Frame", nil, self.parent)
    
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

    if self.right_aligned then
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

    return frame
end

function CurrencyFrame:set_count(count)
        
    if (count or 0) > 999 then
        count = math.floor(count / 100)
        count = count / 10
        count = string.format("%.1fk", count)
    end

    local pad = REST:Get("SETTINGS").currency_padding
    self.frame.count:SetText(count)
    self.frame:SetWidth(
        self.frame.icon:GetHeight() + pad + 
        self.frame.count:GetStringWidth()
    ) 
end

function CurrencyFrame:set_icon(icon)
    self.frame.icon:SetTexture(icon)
end

function CurrencyFrame:set_point(p, f, pf, x, y)
    self.frame:SetPoint(p, f, pf, x, y)
end

function CurrencyFrame:get_width()
    return self.frame:GetWidth()
end

--==# Export #==--

g.CurrencyFrame = CurrencyFrame