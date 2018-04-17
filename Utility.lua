local _, package = ...

local function type_name(var)
    local name = type(var)
    if name == "table" then
        name = var.__type or name
    end
    return name
end

local function assert_type(...)
    for i = 1, select("#", ...), 2 do
        local v, t = select(i, ...)
        assert(
            type_name(v) == t, 
            "failed assert_type " ..
            "(" .. t .. " expected, got " .. type_name(v) .. ")"
        )
    end
end

local function table_tostring(t, pad)
    if type_name(pad) ~= "string" then pad = "" end
    local str = pad .. "{"
    pad = pad .. "  "
    for k,v in pairs(t) do
        if str:len() > 2 then str = str .. ", " end
        str = str .. "\n".. pad .. tostring(k) .. " = "
        if type_name(v) == "table" then
            str = str .. table_tostring(v, pad)
        else
            str = str .. tostring(v)
        end
    end
    return "\n" .. str .. "\n}"
end

local function print_table(...)
    for i = 1, select("#", ...) do
        print(table_tostring(select(i,...)))
    end
end

local function merg_tables(a, b)
    local t = {}
    for k,v in pairs(a) do t[k] = v end 
    for k,v in pairs(b) do t[k] = v end
    return t
end

local function mixin(obj, ...)
    obj = obj or {}
    for i = 1, select("#", ...) do
        for k,v in pairs(select(i, ...)) do
            obj[k] = v
        end  
    end
end


--==# Export #==--

mixin(package, {
    type_name = type_name,
    assert_type = assert_type,
    print_table = print_table,
    merge_table = merge_table,
    mixin = mixin
})