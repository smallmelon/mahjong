local utils = {}

function utils.token_create(uid, timestamp, secret)
    -- body
end

function utils.token_parse(token, secret)
    
end

function utils.format(fmt, ...)
    fmt = tostring(fmt) .. "\t"
    for i = 1, select("#", ...) do
        fmt = fmt .. "%s" .. "\t"
    end
    return string.format(fmt, ...)
end


return utils