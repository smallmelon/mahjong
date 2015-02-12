local redis = require "lib_redis"

local Player = {
    uid = 0,
    nickname = 0,
    gold = 0,
    sex = 0,
    sign = ""
}

function Player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
end

function Player:register(uid)
    local p = Player:new()
    p.uid = uid
    p.gold = 1000
    p.sex = 0
    redis:hmset("player:uid:" .. p.uid, "uid" , p.uid, "gold" : p.gold, "sex" : p.sex)
end

function Player:load(uid)
    local p = Player:new()
    local rs = redis:hmget("player:uid:" .. uid, "uid", "gold", "sex", "nickname")
    p.uid = uid
    return p
    -- body
end

return Player