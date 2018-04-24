local _, package = ...
local ItemFrame = package.ItemFrame


local FilterFrame = {
    wrapper = {},
    title = {},
    content = {}
}

--==# Constructor #==--

function FilterFrame:new(obj)
    obj = obj or {}
    self.__type = "FilterFrame"
    self.__index = self
    setmetatable(obj, self)

    obj:create_wrapper_frame()
    obj:create_title_frame()
    obj:create_content_frame()
    obj.wrapper:Show()

    obj:update()

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function FilterFrame:calc_items_size(num)
    return (self.settings.item.size + self.settings.item.padding) 
        * num - self.settings.item.padding
end

function FilterFrame:create_wrapper_frame()
    self.wrapper = CreateFrame("FRAME", self.filter.name .. "Wrapper", self.parent)
    local wrapper = self.wrapper
    local height = math.ceil(#self.filter.items / self.settings.width)
    
    wrapper:SetWidth(self:calc_items_size(self.settings.width) + self.settings.padding * 2)
    wrapper:SetPoint("TOPLEFT", self.relative, "BOTTOMLEFT", 0, -self.settings.padding)
    
    wrapper.bg = wrapper:CreateTexture(nil, "BACKGROUND")
    wrapper.bg:SetTexture("Interface\\Tooltips\\CHATBUBBLE-BACKGROUND.BLP")
    wrapper.bg:SetAllPoints(wrapper)
end

function FilterFrame:create_title_frame()
    self.title = CreateFrame("FRAME", nil, self.wrapper)
    local title = self.title
    title:Show()

    title:SetHeight(self.settings.padding * 2 + self.settings.font.normal)
    title:SetWidth(self.wrapper:GetWidth())
    title:SetPoint("TOPLEFT", self.wrapper)

    title.arrow = title:CreateTexture(nil, "ARTWORK")
    local arrow = title.arrow
    arrow:SetTexture("Interface\\Worldmap\\WorldMapArrow.blp")
    arrow:SetWidth(24)
    arrow:SetHeight(arrow:GetWidth())    
    arrow:SetPoint("CENTER", title, "TOPLEFT", 
       arrow:GetWidth() / 2, title:GetHeight() / -2)

    title.text = title:CreateFontString(nil, "OVERLAY")
    local text = title.text
    text:SetFont("Fonts\\FRIZQT__.TTF", 12)
    text:SetText(self.filter.name)
    text:SetPoint("TOPLEFT", title, "TOPLEFT", 
        self.settings.padding * 2 + arrow:GetWidth() / 2, -self.settings.padding)

    title:SetScript("OnMouseDown", function(_, button) 
        self.closed = not self.closed
        self:update()
    end)
end

function FilterFrame:create_content_frame()
    self.content = CreateFrame("FRAME", nil, self.wrapper)
    local content = self.content

    local width = self.settings.width
    local height = math.ceil(#self.filter.items / width)

    content:SetWidth(self:calc_items_size(width))
    content:SetHeight(self:calc_items_size(height))
    content:SetPoint("TOPLEFT", self.title, "BOTTOMLEFT", 
        self.settings.padding, 0)
    
    content.items = {}
    local item_offset = self.settings.item.size + self.settings.item.padding    
    for i, item in ipairs(self.filter.items) do
        local item_frame = ItemFrame:new({ 
            item = item,
            settings = self.settings.item,
            parent = self.content
        })
        table.insert(content.items, item_frame)

        local i = i - 1
        local x = (i % width) * item_offset
        local y = math.floor(i / width) * item_offset

        item_frame.frame:SetPoint("TOPLEFT", content, "TOPLEFT", x, -y)
    end
end

function FilterFrame:set_item_frames(item_frames)
end

function FilterFrame:create_item_frame(item)

    
    return frame
end

function FilterFrame:change_offset(x, y)
    local p, rf, rp = self.wrapper:GetPoint()
    self.wrapper:SetPoint(p, rf, rp, x, y)
end

function FilterFrame:update()
    local down = 3.14159
    local right = down / -2

    self.hidden = #self.filter.items == 0

    if self.hidden then
        self.title:Hide()
        self.wrapper.bg:Hide()
        self.wrapper:SetHeight(1)
        self:change_offset(0, 1)
    else
        self.wrapper.bg:Show()
        self:change_offset(0, -self.settings.padding)        
        
        if self.closed then
            self.wrapper:SetHeight(self.title:GetHeight())
            self.title.arrow:SetRotation(right)
            self.content:Hide()
        else
            self.wrapper:SetHeight(self.title:GetHeight() 
                + self.content:GetHeight() + self.settings.padding)
            self.title.arrow:SetRotation(down)
            self.content:Show()
        end
    end
end

--==# Export #==--

package.FilterFrame = FilterFrame