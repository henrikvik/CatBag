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