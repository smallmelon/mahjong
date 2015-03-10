local snax = require "snax"

local player = {
    player_sup = nil
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


function player:spawn_player(uid)
    local handle = self.player_sup.req.spawn_player(uid)
    if handle then
        self.pid = snax.bind(handle, "mod_player")
        return true
    end
    return false
end

function player:get_player(uid)
    local handle = self.player_sup.get_player(uid)
    if handle then
        self.pid = snax.bind(handle, "mod_player")
        return true
    end
    return false
end

setmetatable(player, {__index = function (t, k)
    local cmd = string.lower(k)
    local f = function (self, ... )
        return self.pid.req[cmd](...)
    end
    t[k] = f
end})

return player