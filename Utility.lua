function type_name(var)
    local name = type(var)
    if name == "table" then
        name = var.__type or name
    end
    return name
end

function assert_type(...)
    for i = 1, select("#", ...), 2 do
        local v, t = select(i, ...)
        assert(
            type_name(v) == t, 
            "failed assert_type " ..
            "(" .. t .. " expected, got " .. type_name(v) .. ")"
        )
    end
end

function table_tostring(t, pad)
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


function print_table(...)
    for i = 1, select("#", ...) do
        print(table_tostring(select(i,...)))
    end
end