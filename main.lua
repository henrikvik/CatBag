UIParentLoadAddOn('Blizzard_DebugTools')

local _, CatBag = ...
local print_table = CatBag.print_table
local Backend = CatBag.Backend
local Filter  = CatBag.Filter
local Options = CatBag.Options


local b = Backend:new()
local f = b:new_filter()

f:eval_func("function(item) return item.useable == true end")

b:query_items()
b:filter_items()

DisplayTableInspectorWindow(b)
--DisplayTableInspectorWindow(failed)

local options = Options:new({ 
    name = "CatBag",
    backend = b
})


local frame = CreateFrame("Frame", "Filters", UIParent)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

frame:SetPoint("CENTER")
frame:SetSize(64,64)
local tex = frame:CreateTexture("ARTWORK")
tex:SetAllPoints()
tex:SetColorTexture(1.0,0.5,0,0.5)