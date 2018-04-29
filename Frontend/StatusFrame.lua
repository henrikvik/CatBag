local _, package = ...
local CurrencyFrame = package.CurrencyFrame
local calc_width = package.calc_width
local REST = package.REST


local StatusFrame = {
    frame = {},
    gold = {},
    empty = {},
    tracked = {}
}

--==# Constructor #==--

function StatusFrame:new(obj)
    obj = obj or {}
    self.__type = "StatusFrame"
    self.__index = self
    setmetatable(obj, self)

    obj.frame = obj:create_status_frame()
    obj:register_events()

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function StatusFrame:set_point(p, f, fp, x, y)
    self.frame:SetPoint(p, f, fp, x, y)
end

function StatusFrame:create_status_frame()
    local settings = REST:Get("SETTINGS")

    local pad, font_size = settings.padding, settings.font.title
    local frame = CreateFrame("FRAME", nil, self.parent)

    frame:SetHeight(pad * 2 + font_size)
    frame:SetWidth(calc_width(settings) + pad * 2)

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    -- frame.bg:SetTexture("Interface\\Tooltips\\CHATBUBBLE-BACKGROUND.BLP")
    frame.bg:SetColorTexture(0,0,0,0.66)
    frame.bg:SetAllPoints(frame)

    self.empty = CurrencyFrame:new({parent = frame, right_aligned = true})
    self.empty:set_point("TOPRIGHT", frame, "TOPRIGHT", -pad, -pad)
    self.empty:set_icon("Interface\\BUTTONS\\Button-Backpack-Up.blp")

    self.gold = CurrencyFrame:new({parent = frame})
    self.gold:set_point("TOPLEFT", frame, "TOPLEFT", pad, -pad)
    self.gold:set_icon("Interface\\MONEYFRAME\\UI-GoldIcon.blp")

    self.tracked = {}
    self.tracked[1] = CurrencyFrame:new({parent = frame, right_aligned = true})
    self.tracked[2] = CurrencyFrame:new({parent = frame, right_aligned = true})
    self.tracked[3] = CurrencyFrame:new({parent = frame, right_aligned = true})

    local c_pad = settings.currency_padding    
    self.tracked[2]:set_point("LEFT", self.gold.frame,  "RIGHT",  c_pad, 0)
    self.tracked[2]:set_point("LEFT", self.tracked[1].frame,  "RIGHT",  c_pad, 0)
    self.tracked[3]:set_point("LEFT", self.tracked[2].frame,  "RIGHT",  c_pad, 0)



    return frame
end

function StatusFrame:update_currency()
    self.gold:set_count(math.floor(GetMoney() / 10000))
    self.empty:set_count(#REST:Get("EMPTY"))

    for i = 1, 3 do
        local _, count, icon, id = GetBackpackCurrencyInfo(i)
        self.tracked[i]:set_count(count)
        self.tracked[i]:set_icon(icon)
    end

    local c_pad = REST:Get("SETTINGS").currency_padding
    local w = (c_pad + self.tracked[1]:get_width()) * GetNumWatchedTokens() - c_pad
    self.tracked[1]:set_point("LEFT", self.frame, "CENTER", -w/2, 0)
end


function StatusFrame:register_events()
    local events = {
        "PLAYER_MONEY",
        "CHAT_MSG_CURRENCY",
        "CURRENCY_DISPLAY_UPDATE",
        "BAG_OPEN"
    }

    for i,event in ipairs(events) do
        self.frame:RegisterEvent(event)
    end

    local event_handler = self:get_event_handler()
    self.frame:SetScript("OnEvent", event_handler)

    -- hooksecurefunc("BackpackTokenFrame_Update", function()
    --     event_handler(self.frame, "BackpackTokenFrame_Update")
    -- end)
end

function StatusFrame:get_event_handler()
    return function(f, e, ...)
        print(e)
        self:update_currency()
    end
end

--==# Export #==--

package.StatusFrame = StatusFrame