local snax = require "snax"
local redis = require "lib_redis"
local print_r = require "print_r"
local player = {
    player_sup = nil,

    -- player element
    uid = 0,
    gold = 0,
    sex = 0,
    diamond = 0,
    nickname = "",
    iconUrl = "",
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

function player:get_info_from_redis(uid)
    local info = {"gold", "diamond", "sex", "nickname", "iconUrl"}
    local rs = redis:hmget("player:uid:"..uid, table.unpack(info))
    print_r(rs)
    self.gold = tonumber(rs[1]) or 0
    self.diamond = tonumber(rs[2]) or 0
    self.sex = tonumber(rs[3]) or 0
    self.nickname = rs[4] or ""
    self.iconUrl = rs[5] or ""
    self.uid = uid 
end

function player:set_info_to_redis()
    local info = {"gold", 1500, "diamond", 25, "sex", 1, "nickname", "i love you", "iconUrl", "hey you"}
    redis:hmset("player:uid:"..self.uid, table.unpack(info))
end

function player:add_gold(value)
    self.gold = self.gold + value
    redis:hincrby("player:uid:"..self.uid, "gold", value)
end

function player:add_diamond(value)
    self.diamond = self.diamond + value
    redis:hincrby("player:uid:"..self.uid, "diamond", value)
end



return player