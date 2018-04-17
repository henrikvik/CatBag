UIParentLoadAddOn('Blizzard_DebugTools')
local addon_name, package = ...
local Options = package.Options
local Backend = package.Backend


local AceDB = LibStub("AceDB-3.0")

local CatBag = LibStub("AceAddon-3.0"):NewAddon("CatBag", "AceEvent-3.0")

local function ReloadBackend(event, db)
    ReloadUI()
end

function CatBag:OnInitialize()
    self.db = AceDB:New("CatBagDB", {}, true)
    self.db.profile.backend = Backend:new(self.db.profile.backend)
    self.db:RegisterCallback("OnProfileReset", ReloadBackend)
    self.db:RegisterCallback("OnProfileChanged", ReloadBackend)

    self.options = Options:new({ name = "CatBag", db = self.db})
    self.options:register_options_tables()
    self.options:register_bliz_frames()
end

function CatBag:OnEnable()
    print("enable")
end

function CatBag:OnDisable()
end

CatBag:RegisterEvent("PLAYER_ENTERING_WORLD", function() 
    LibStub("AceConfigDialog-3.0"):Open("CatBagCategories")
end)

