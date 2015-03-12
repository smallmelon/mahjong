local snax = require "snax"


local seats = {}

function init(cf)
    -- body
end

function exit()
    for i = 1, #seats do
        snax.kill(seats[i])
    end
end

function response.acquire()
    if #seats >= 1 then
        return table.remove(seats, 1)
    else
        local seat = snax.newservice("mod_seat")
        table.insert(seats, seat.handle)
        return seat.handle
    end
end


function accept.release(handle)
    local seat = snax.bind(handle, "mod_seat")
    if seat.req.is_empty() then
        snax.kill(seat)
    else
        table.insert(seats, handle)
    end
end
