local snax = require "snax"
local redis = require "lib_redis"
local print_r = require "print_r"
local lib_utils = require "lib_utils"
local mysql = require "lib_mysql"

local function get(key)
    return function (self)
            return self[key]
    end
end

local function set(key)
    return function(self, value)
        self[key] = value
    end
end

local function add(key)
     return function(self, value)
        local r = self[key] + value
        self[key] = r
        return r
    end   
end

local function redis_set(key)
    return function(self, value)
        self[key] = value
        redis:hmset("player:uid:"..self.uid, key, value)
    end
end

local function redis_get(key)
    return function (self)
            local r = redis:hget("player:uid"..self.uid, key)
            self[key] = r
            return r
    end
end

local function redis_add(key)
     return function(self, value)
        local r = self[key] + value
        self[key] = r
        redis:hincrby("player:uid:"..self.uid, key, value)
        return r
    end   
end

local player = {
    player_sup = nil,

    -- player element
    uid = 0,
    gold = 0,
    sex = 0,
    diamond = 0,
    nickname = "",
    icon_url = "",

    -- player get , set, add method
    get_uid = get("uid"),
    get_gold = get("gold"),
    get_sex = get("sex"),
    get_diamond = get("diamond"),
    get_nickname = get("nickname"),
    get_icon_url = get("icon_url"),

    set_uid = set("uid"),
    set_gold = redis_set("gold"),
    set_sex = redis_set("sex"),
    set_diamond = redis_set("diamond"),
    set_nickname =redis_set("nickname"),
    set_icon_url = redis_set("icon_url"),

    add_gold = redis_add("gold"),
    add_diamond = redis_add("diamond"),

    -- token
    token = "",
    get_token = redis_get("token"),
    set_token = redis_set("token")
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
    local info = {"gold", "diamond", "sex", "nickname", "icon_url"}

    local rs = redis:hmget("player:uid:"..uid, table.unpack(info))
    self.gold = tonumber(rs[1]) or 0
    self.diamond = tonumber(rs[2]) or 0
    self.sex = tonumber(rs[3]) or 0
    self.nickname = rs[4] or ""
    self.icon_url = rs[5] or ""
    self.uid = uid 
end

function player:undate_login()
    local sql = string.format("UPDATE `mahjong`.`user_account` SET `login_time`= now() WHERE `uid`=%d;", self.uid)
    mysql:query(sql)
end

function player:get_password_by_uid(uid)
    local sql = string.format("SELECT `password` from `mahjong`.`user_account` WHERE `uid`=%d ", uid)
    local r = mysql:query(sql)
    if r and r[1] then
        return r[1].password
    end
    print("get_password_by_uid ", uid)
    skynet.error("mysql busy")
    print_r(uid)
end

function player.generate_uid( )
    local uid = redis:incrby("user_max_uid", 1)
    return uid
end

function player:set_info_to_redis()
    local info = {"gold", 1500, "diamond", 25, "sex", 1, "nickname", "i love you", "icon_url", "hey you"}
    redis:hmset("player:uid:"..self.uid, table.unpack(info))
end

function player:set_info_to_mysql( )
    local sql = string.format("insert into user_account (uid, password, uuid, channel, device, register_time) value (%d, 'like you', 'without you', 12, 'iPhone6 plus', now());", self.uid)
    mysql:query(sql)
end

function player:register(msg)
    self:set_uid(self:generate_uid())
    self:set_info_to_mysql()
    self:set_info_to_redis()
end

function player:get_user_info()
    return {
        uid = self.uid,
        diamond = self.diamond,
        sex  = self.sex,
        gold = self.gold,
        nickname = self.nickname,
        icon_url = self.icon_url
    }
end

return player