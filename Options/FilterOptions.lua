local _, package = ...
local REST = package.REST


local FilterOptions = {
    backend = {},
    filter = {},
    index = -1,
    options = {}
}

--==# Constructor #==--

function FilterOptions:new(obj)
    obj = obj or {}
    self.__type = "FilterOptions"
    self.__index = self
    setmetatable(obj, self)

    obj.options = obj:make_options()

    return obj
end

--==# Meta Functions #==--

--==# Member Functions #==--

function FilterOptions:make_options()
    return {
        type = "group",
        name = self.filter.name,
        order = self.index,
        handler = self,
        args = {
            up = {
                order = 1,
                type = "execute",
                name = "Move Up",
                func = "move_up"
            },
            down = {
                order = 2,
                type = "execute",
                name = "Move Down",
                func = "move_down"
            },
            remove = {
                order = 3,
                type = "execute",
                name = "Remove",
                func = "remove",
                confirm = "remove_confirm"
            },
            name = {
                order = 5,
                type = "input",
                name = "Name",
                width = "full",
                get = "name_get",
                set = "name_set",
                validate = "name_validate"
            },
            code = {
                order = 10,
                type = "input",
                name = "Function",
                width = "full",
                multiline = 10,
                get = "code_get",
                set = "code_set",
                validate = "code_validate"
            }
        }
    }
end

function FilterOptions:move_up()
    if self.index > 1 then
        table.remove(self.backend.filters, self.index)
        table.insert(self.backend.filters, self.index - 1, self.filter)
        REST:Send("UPDATE")
    end
end


function FilterOptions:move_down()
    if self.index < #self.backend.filters then
        table.remove(self.backend.filters, self.index)
        table.insert(self.backend.filters, self.index + 1, self.filter)
        REST:Send("UPDATE")
    end
end

function FilterOptions:remove()
    table.remove(self.backend.filters, self.index)
    REST:Send("UPDATE")
end

function FilterOptions:remove_confirm()
    return "Are you sure you want to remove \"" ..
        self.filter.name .. "\"?\nThis action can not be undone."
end

function FilterOptions:name_get()
    return self.filter.name 
end

function FilterOptions:name_set(info, name)
    self.filter.name = name
    REST:Send("UPDATE")
end

function FilterOptions:name_validate(info, name)
    if name ~= self.filter.name and self.backend:filter_exists(name) then
        return "A category with name \"" .. name .. "\" already exists"
    end
    return true
end

function FilterOptions:code_get()
    return self.filter.code
end

function FilterOptions:code_set(info, code) 
    self.filter:set_code(code)
    REST:Send("UPDATE")
end

function FilterOptions:code_validate(info, code)
    return self.filter:validate_code(code)
end

--==# Export #==--

package.FilterOptions = FilterOptions