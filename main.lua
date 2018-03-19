function print_table(t)
    local ln = "{ "
    for i,v in ipairs(t) do
        ln = ln .. tostring(v) .. ", "
    end
    print(ln .. "}")
end


local f = Filter:new()
local items = { 
    Item:new({ilevel = 10}),
    Item:new({ilevel = 10}),
    Item:new({ilevel = 20}),
    Item:new({ilevel = 20})
}

local ts, fs = f:filter_items(items)
print_table(ts)
print_table(fs)

f:set_filter_func("function(item) return item.ilevel > 0 end")

local ts, fs = f:filter_items(items)
print_table(ts)
print_table(fs)



