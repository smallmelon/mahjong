local skynet = require "skynet"
local string = require "string"
local snax = require "snax"
local print_r = require "print_r"


local Redis = {
    redis_sup = nil,
    pool = nil
}


function hash_key(key)
    local value = 0
    for i=1, #key do
        value = value + string.byte(key, i)
    end
    return value
end

function get_uid(key)
    local pos = string.find(key, "uid:")
    if pos then
        return tonumber(string.sub(key, pos + 4, #key))
    end
    return false
end

function Redis:init(cf)
    self.redis_sup = snax.uniqueservice("mod_redis_sup", cf)
end

function Redis:get_db(key)
    local uid = get_uid(key)
    if uid and uid  < 100000 then -- uid is robot 
        local dbs = self.pool[1]
        return dbs[math.random(1, #dbs)]
    end
    if not uid then
        uid = hash_key(key)
    end
    local dbs = self.pool[uid % #self.pool + 1]
    return dbs[math.random(1, #dbs)]   
end

function Redis:get_redis_pool()
    local pool = self.redis_sup.req.acquire()  
     self.pool = {}
     for k, v in pairs(pool) do
        local dbs = {}
        for c, handle in pairs(v) do
            dbs[c] = snax.bind(handle, "mod_redis")
        end
        self.pool[k] = dbs
    end
end
setmetatable(Redis, { __index = function (t, k)
    local cmd = string.lower(k)
    Redis.redis_sup = snax.queryservice("mod_redis_sup")
    Redis:get_redis_pool()
    local function f (self, ... )
        local db = self:get_db(select(1, ...))
        return db.req.cmd(cmd, ...)
    end
    t[k] = f
    return f
end})


return Redis
