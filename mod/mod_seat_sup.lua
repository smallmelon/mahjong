local snax = require "snax"


local seats = {}

function init()
    -- body
end

function exit()
    for i = 1, #seats do
        snax.kill(seats[i])
    end
end

function response.get_seat()
    if #seats >= 1 then
        return table.remove(seats, 1)
    else
        local seat = snax.newservice("mod_seat")
        table.insert(seats, seat)
        return seat
    end
end

