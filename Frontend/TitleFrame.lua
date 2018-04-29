local _, package = ...
local calc_width = package.calc_width
local ButtonFrame = package.ButtonFrame
local REST = package.REST


local TitleFrame = {
    buttons_left = {},
    buttons_right = {}
}

--==# Constructor #==--

function TitleFrame:new(obj)
    obj = obj or {}
    self.__type = "TitleFrame"
    self.__index = self
    setmetatable(obj, self)

    obj.frame = obj:create_wrapper_frame()

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function TitleFrame:create_wrapper_frame()
    local settings = REST:Get("SETTINGS")
    local pad, font_size = settings.padding, settings.font.title
    local frame = CreateFrame("Frame", nil, self.parent)

    frame:SetHeight(pad * 2 + font_size)
    frame:SetWidth(calc_width(settings, settings.width) + pad * 2)

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetTexture("Interface\\Tooltips\\CHATBUBBLE-BACKGROUND.BLP")
    --frame.bg:SetColorTexture(0,0,0,0.66)
    frame.bg:SetAllPoints(frame)

    frame.text = frame:CreateFontString(nil, "OVERLAY")
    frame.text:SetFont("Fonts\\FRIZQT__.TTF", font_size)
    frame.text:SetText("CatBag")
    frame.text:SetPoint("CENTER")

    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    return frame
end

function TitleFrame:set_point(p, f, fp, x, y)
    self.frame:SetPoint(p, f, fp, x, y)
end

function TitleFrame:add_button(side, options)
    local settings = REST:Get("SETTINGS")
    local pad, size = settings.padding, settings.font.title
    options.parent = self.frame
    options.settings = settings
    
    local btn = ButtonFrame:new(options)
    if side == "LEFT" then
        local btn_id = #self.buttons_left
        table.insert(self.buttons_left, btn)
        btn:set_point("LEFT", self.frame, "LEFT", 
            pad + (size + pad) * btn_id, 0
        )
    elseif side == "RIGHT" then
        local btn_id = #self.buttons_right
        table.insert(self.buttons_right, btn)
        btn:set_point("RIGHT", self.frame, "RIGHT", 
            -(pad + (size + pad) * btn_id), 0
        )
    else error("not a valid side") end
end


--==# Export #==--

package.TitleFrame = TitleFrame