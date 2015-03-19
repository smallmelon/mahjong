local snax = require "snax"
local skynet = require "skynet"
local mysql = require "lib_mysql"
local redis = require "lib_redis"



local agents = {}

function init( ... )
end

function exit( ... )
    -- body
end

function response.login(uid, agent)
    agents[uid] = agent
end

function response.is_online(uid)
    return agents[uid] ~= nil
end

function response.logout(uid)
    local agent = agents[uid]
    if agent then
        skynet.send(agent, "lua", "close")
        agents[uid] = nil
    end
end