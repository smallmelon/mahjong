local utils = {}

function utils.token_create(uid, timestamp, secret)
    -- body
end

function utils.token_parse(token, secret)
    
end

function utils.format(fmt, ...)
    if not fmt then
        return ""
    end
    fmt = fmt.."\t"
    for i = 1, select("#", ...) do
        fmt = fmt .. "%s\t"
    end
    return string.format(fmt, ...)
end

function utils.format_dict(t)
    if not t then
        return
    end
    local r = {}
    for k, v in pairs(t) do
        if type(v) == "number" or type(v) == "string" then
            table.insert(r, string.format("%s : %s", k, v))
        end
    end
    return utils.format(table.unpack(r))
end

function utils.find_cmd( name )
    local pos = string.find(name, "set_")
    if pos ~= 1 then
        pos = string.find(name, "get_")
    end
    if pos == 1 then
        local cmd = string.sub(name, 1, 4)
        local e = string.sub(name, 5, #name)
        return cmd, e
    end
end

return utils