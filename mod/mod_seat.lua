local snax = require "snax"
local skynet = require "skynet"

local seat = {
    hallId = 0,
    roomId = 0,
    seatId = 0,
    max = 0,
    min = 0,
    base = 0
}

local players = {}

local agents = {}

function init(cf)
    -- body
end

function exit()
    -- body
end

 
function push_message(uid, name, msg)
    if agents[uid] then
        skynet.send(agents[uid], "lua", "push", name, msg)
    end
end

function response.is_empty()
    return not next(players)
end

function response.enter(from,  msg)
    print("seat enter uid ", msg.uid)
    agents[msg.uid] = from
    push_message(msg.uid, "send from seat", "helllo")
    return {code = 200}
end

function response.ready( ... )
    -- body
end

function response.host( ... )
    -- body
end

function response.nohost( ... )
    -- body
end

function  response.restore( ... )
    -- body
end
function response.draw( ... )
    -- body
end

function response.chow( ... )
    -- body
end

function response.kongdraw( ... )
    -- body
end

function response.pop( ... )
    -- body
end

function response.pong( ... )
    -- body
end

function response.chowkong( ... )
    -- body
end

function response.pongkong( ... )
    -- body
end

--暗杠
function response.concealed( ... )
    -- body
end

function response.drawhu( ... )
    -- body
end

function response.chowhu( ... )
    -- body
end

function response.redouble( ... )
    -- body
end

function response.ting( ... )
    -- body
end

function response.confirmwin( ... )
    -- body
end

function response.leave( ... )
    -- body
end

function response.force_leave( ... )
    -- body
end

function push_message(uid, name, msg)
    if agents[uid] then
        skynet.call(agents[uid], "lua", "push", name, msg)
    end
end