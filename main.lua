local _, package = ...
local Backend  = package.Backend
local Frontend = package.Frontend
local Options  = package.Options
local REST = package.REST


local AceDB = LibStub("AceDB-3.0")
local CatBag = LibStub("AceAddon-3.0"):NewAddon("CatBag", "AceEvent-3.0")

function clean_db(db)
    local backend = db.profile.backend

    backend.slots = {}
    backend.unfiltered = {}

    for i, filter in ipairs(backend.filters) do
        filter.items = {}
        filter.frame = nil
    end
    
end

function CatBag:OnInitialize()
    self:load_db()
    self:load_backend()
    self:load_frontend()

    self.options = Options:new({ name = "CatBag", db = self.db })
    self.options:register_options_tables()
    self.options:register_bliz_frames()


    REST:Listen("UPDATE", function()
        REST:Send("UPDATE_ITEMS")
        REST:Send("FILTER_ITEMS")
        REST:Send("UPDATE_LAYOUT")
    end)


    hooksecurefunc("ToggleAllBags", function()
        REST:Send("TOGGLE_BAG")
        CloseAllBags()
    end)

end

function CatBag:load_db()
    self.db = AceDB:New("CatBagDB", { profile = {
        settings = {
            item = {
                size = 38,
                padding = 2,
                border = {
                    inset = 2,
                    texture = "Interface\\Tooltips\\UI-Tooltip-Border.blp",
                    size = 16
                }
            },
            width = 8,
            padding = 5,
            font = {
                normal = 12,
                title = 14
            },
            currency_padding = 10,
            bg_texture = "Interface\\Tooltips\\CHATBUBBLE-BACKGROUND.BLP"
        }
    }}, true)

    self.db:RegisterCallback("OnProfileReset", ReloadUI)
    self.db:RegisterCallback("OnProfileChanged", ReloadUI)
    self.db:RegisterCallback("OnProfileShutdown ", clean_db)
    self.db:RegisterCallback("OnDatabaseShutdown", clean_db)

    REST:Register("SETTINGS", function()
        return self.db.profile.settings
    end)
end

function CatBag:load_backend()
    self.db.profile.backend = Backend:new(self.db.profile.backend)

    REST:Register("EMPTY", function()
       return self.db.profile.backend.empty 
    end)

    REST:Register("FILTERS", function()
        return self.db.profile.backend.filters 
    end)

    REST:Listen("QUERY_SLOTS", function()
        self.db.profile.backend:query_slots()
    end)

    REST:Listen("UPDATE_ITEMS", function()
        self.db.profile.backend:update_items()
    end)

    REST:Listen("FILTER_ITEMS", function()
        self.db.profile.backend:filter_items()
    end)
end

function CatBag:load_frontend()
    self.frontend = Frontend:new()
end

function CatBag:OnEnable()
end

function CatBag:OnDisable()
end

CatBag:RegisterEvent("PLAYER_ENTERING_WORLD", function()
    REST:Send("QUERY_SLOTS")
    REST:Send("UPDATE_ITEMS")
    REST:Send("FILTER_ITEMS")
    REST:Send("UPDATE_LAYOUT")

    CatBag:RegisterEvent("BAG_UPDATE", function()
        REST:Send("UPDATE_ITEMS")
        REST:Send("FILTER_ITEMS")
        REST:Send("UPDATE_LAYOUT")
    end)
end)



