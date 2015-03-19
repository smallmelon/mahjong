local snax = require "snax"
local redis = require "lib_redis"

local player = {
    player_sup = nil,
    pid = nil
}

function player:init()
    self.player_sup = snax.uniqueservice("mod_player_sup")
end

function player:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.player_sup = snax.queryservice("mod_player_sup")
    return o
end


return player