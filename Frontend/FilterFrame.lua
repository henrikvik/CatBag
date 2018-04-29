local _, g = ...
local ItemFrame = g.ItemFrame
local calc_width = g.calc_width
local REST = g.REST


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

    if obj.filter then 
        obj:set_filter(obj.filter) 
    end

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function FilterFrame:create_wrapper_frame()
    local wrapper = CreateFrame("FRAME", nil, self.parent)
    
    local settings = REST:Get("SETTINGS")
    wrapper:SetWidth(calc_width(settings) + settings.padding * 2)
    wrapper:SetHeight(settings.font.normal + settings.padding * 2)

    wrapper.bg = wrapper:CreateTexture(nil, "BACKGROUND")
    wrapper.bg:SetTexture(settings.bg_texture)
    wrapper.bg:SetAllPoints(wrapper)

    self.wrapper = wrapper
end

function FilterFrame:create_title_frame()
    local settings = REST:Get("SETTINGS")
    
    local title = CreateFrame("FRAME", nil, self.wrapper)
    title:SetHeight(settings.font.normal + settings.padding * 2)
    title:SetWidth(self.wrapper:GetWidth())
    title:SetPoint("TOPLEFT", self.wrapper)
    title:SetScript("OnMouseDown", function(_, button) 
        self.filter.closed = not self.filter.closed
        self:update()
    end)

    local arrow = title:CreateTexture(nil, "ARTWORK")
    arrow:SetTexture("Interface\\Worldmap\\WorldMapArrow.blp")
    arrow:SetWidth(24)
    arrow:SetHeight(arrow:GetWidth())    
    arrow:SetPoint("CENTER", title, "TOPLEFT", 
       arrow:GetWidth() / 2, title:GetHeight() / -2)
    title.arrow = arrow


    local text = title:CreateFontString(nil, "OVERLAY")
    text:SetFont("Fonts\\FRIZQT__.TTF", settings.font.normal)
    text:SetPoint("TOPLEFT", title, "TOPLEFT", 
        settings.padding * 2 + arrow:GetWidth() / 2, -settings.padding)
    title.text = text

    self.title = title
end

function FilterFrame:create_content_frame()
    local settings = REST:Get("SETTINGS")

    local content = CreateFrame("FRAME", nil, self.wrapper)
    content:SetWidth(calc_width(settings))
    content:SetHeight(1)
    content:SetPoint("TOPLEFT", self.title, "BOTTOMLEFT", 
        settings.padding, 0)
    
    self.content = content
end


function FilterFrame:set_point(p, f, fp, x, y)
    self.wrapper:SetPoint(p, f, fp, x, y)
end

function FilterFrame:set_filter(filter)
    self.filter = filter
    self.title.text:SetText(self.filter.name)
    self:update()
end

function FilterFrame:set_item_frames(items)
    local settings = REST:Get("SETTINGS")

    self.content:SetWidth(calc_width(settings))
    self.content:SetHeight(calc_width(settings,
        math.ceil(#items / settings.width)
    ) + settings.padding)
    

    self.content.items = table.wipe(self.content.items or {})
    local offset = settings.item.size + settings.item.padding
    for i, item in ipairs(items) do
        local id = i - 1
        local col = id % settings.width
        local row = -math.floor(id / settings.width)

        item:set_parent(self.content)
        item:set_point("TOPLEFT", self.content, "TOPLEFT",
            col * offset, row * offset)
    end

    self:update()
end

function FilterFrame:open()
    local down = 3.1415
    
    self.title.arrow:SetRotation(down)
    self.wrapper:SetHeight(
        self.title:GetHeight() +
        self.content:GetHeight())
    self.content:Show()   
end

function FilterFrame:close()
    local right = 3.1415 / -2

    self.title.arrow:SetRotation(right)
    self.wrapper:SetHeight(
        self.title:GetHeight())
    self.content:Hide()
end

function FilterFrame:update()
    if self.filter.closed then
        self:close()
    else
        self:open()
    end
end


--==# Export #==--

g.FilterFrame = FilterFrame