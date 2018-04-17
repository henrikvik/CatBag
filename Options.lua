local _, package = ...
local FilterOptionsHandler = package.FilterOptionsHandler
local mixin = package.mixin

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")


local Options = {
    name = "",
    db = {}
}

--==# Constructor #==--

function Options:new(obj)
    obj = obj or {}
    self.__type = "Options"
    self.__index = self
    setmetatable(obj, self)
    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function Options:register_options_tables()
    AceConfig:RegisterOptionsTable(self.name, {
        type = "group",
        name = self.name,
        args = {}
    }) 

    AceConfig:RegisterOptionsTable(self.name .. "Categories",
        self:create_category_options()
    )

    AceConfig:RegisterOptionsTable(self.name .. "Profiles", 
        AceDBOptions:GetOptionsTable(self.db)
    )
end

function Options:register_bliz_frames()
    AceConfigDialog:AddToBlizOptions(self.name, self.name)
    AceConfigDialog:AddToBlizOptions(self.name .. "Categories", "Categories", self.name)
    AceConfigDialog:AddToBlizOptions(self.name .. "Profiles", "Profiles", self.name)
end

function Options:create_category_options()
    return function()
        local options = {
            type = "group",
            name = self.name .. " Categories",
            args = {
                new = {
                    order = 0,
                    type = "execute",
                    name = "New Category",
                    func = function()
                        self.db.profile.backend:new_filter()
                    end
                }
            }
        }

        for index, filter in ipairs(self.db.profile.backend.filters) do
            options.args[filter.name] = FilterOptionsHandler:new({
                backend = self.db.profile.backend,
                index = index,
                filter = filter
            }).options
        end
        
        return options
    end
end

--==# Export #==--

package.Options = Options