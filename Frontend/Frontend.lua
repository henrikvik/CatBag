local _, package = ...
local FilterFrame = package.FilterFrame
local ItemFrame = package.ItemFrame

local Frontend = {}

--==# Constructor #==--

function Frontend:new(obj)
    obj = obj or {}
    self.__type = "Frontend"
    self.__index = self
    setmetatable(obj, self)

    obj:create_bag_frame()

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function Frontend:calc_frame_width()
    return (self.settings.item.size + self.settings.item.padding) 
        * self.settings.width - self.settings.item.padding
end

function Frontend:calc_frame_height(height)
    local s = self.settings
    local width = height * s.item.size 
        + math.max(0, height - 1) * s.item.padding
    return width
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