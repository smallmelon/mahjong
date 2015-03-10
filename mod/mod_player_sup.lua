local snax = require "snax"
local skynet = require "skynet"


local agents = {}
local players = {}

function init( ... )
    -- body
end

function exit( ... )
    -- body
end



function response.set_agent(uid, handle)
    if agents[uid] then
        return false
    end
    agents[uid] = handle
    return true
end

function response.get_agent(uid)
    return agents[uid]
end


function response.kick_agent(uid)
    local handle = agents[uid]
    if handle then
        return skynet.kill(handle)
    end
    return true
end


function accept.kick_player(uid)
    local p = players[uid]
    if p then
        snax.kill(p)
    end
    players[uid] = nil
end

function response.spawn_player(uid)
    local p = snax.newservice(uid)
    players[uid] = p
    return p.handle
end

function response.get_player(uid)
    local p = players[uid]
    if p then
        return p.handle
    end
    return 0
end