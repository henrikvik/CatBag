
local _, package = ...
local Backend  = package.Backend
local Frontend = package.Frontend
local Options  = package.Options

local AceDB = LibStub("AceDB-3.0")
local CatBag = LibStub("AceAddon-3.0"):NewAddon("CatBag", "AceEvent-3.0")

function CatBag:OnInitialize()
    self.db = AceDB:New("CatBagDB", { profile = {
        settings = {
            item = {
                size = 38,
                padding = 2
            },
            width = 8,
            padding = 6,
            font = {
                normal = 12,
                title = 14
            }
        }
    }}, true)
    self.db:RegisterCallback("OnProfileReset", ReloadUI)
    self.db:RegisterCallback("OnProfileChanged", ReloadUI)

    self.db.profile.backend = Backend:new(self.db.profile.backend)

    self.db.profile.backend:query_items()
    self.db.profile.backend:filter_items()

    tinspect(self.db.profile.backend)

    self.db.profile.frontend = Frontend:new({
        settings = self.db.profile.settings,
        backend = self.db.profile.backend
    })
    
    self.options = Options:new({ name = "CatBag", db = self.db})
    self.options:register_options_tables()
    self.options:register_bliz_frames()
end

function CatBag:OnEnable()
end

function CatBag:OnDisable()
end

CatBag:RegisterEvent("PLAYER_ENTERING_WORLD", function()
    LibStub("AceConfigDialog-3.0"):Open("CatBagCategories")
end)

