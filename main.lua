local _, CatBag = ...
local print_table = CatBag.print_table
local Backend = CatBag.Backend
local Filter = CatBag.Filter

local b = Backend:new()
local i = b:query_items()

local f = Filter:new()
f:set_filter_func("function(item) return item.stack_size > 10 end")

print_table(f:filter_items(i))
