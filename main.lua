

local b = Backend:new()
local i = b:query_items()

local f = Filter:new()
f:set_filter_func("function(item) return item.lootable end")

print_table(f:filter_items(i))
