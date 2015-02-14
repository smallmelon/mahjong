local snax = require "snax"
local redis = snax.queryservice("mod_redis")

local Player = {
    uid = 0,
    nickname = "",
    gold = 0,
    sign = "",
    voucher = 0
}

local player_prefix = "player:uid:"

function Player:new(id)
    local o = {uid = id}
    setmetatable(o, self)
    self.__index = self
end

function Player:register(p)
    return redis.req.hmset(player_prefix..p.uid, "uid", p.uid, "gold" : p.gold, 
        "nickname", p.nickname, "voucher", p.voucher, "sign", p.sign)
end

function Player:load_from_db(uid)
    local rs = redis.req.hmget(player_prefix..uid, "uid", "nickname", "gold", "voucher", "sign")
    local p = Player:new(uid)
    p.uid, p.nickname, p.gold, p.voucher , p.sign = rs[1], rs[2], rs[3], rs[4], rs[5]
    return p
end