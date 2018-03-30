UIParentLoadAddOn('Blizzard_DebugTools')
local addon_name, package = ...
local print_table = package.print_table
local Backend = package.Backend
local Filter  = package.Filter
local Options = package.Options

local CatBag = LibStub("AceAddon-3.0"):NewAddon("CatBag")

function CatBag:OnInitialize()
    local b = Backend:new()
    local f = b:new_filter()
    f:eval_func("function(item) return item.useable == true end")
    
    b:query_items()
    b:filter_items()

    local o = Options:new({backend = b})
end

function CatBag:OnEnable()
end

function CatBag:OnDisable()
end

  



