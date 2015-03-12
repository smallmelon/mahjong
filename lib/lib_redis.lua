local skynet = require "skynet"
local string = require "string"
local snax = require "snax"
local print_r = require "print_r"



local Redis = {
    redis_sup = nil
}

local conf = {
    {
        host = "127.0.0.1" ,
        port = 6379 ,
        db = 0,
        auth = "_jiami2013"
    },
    {
        host = "127.0.0.1" ,
        port = 6380 ,
        db = 0,
        auth = "_jiami2013"
    }
}


function Redis:init(cf)
    cf = cf or conf
    self.redis_sup = snax.uniqueservice("mod_redis_sup", cf)
end

setmetatable(Redis, { __index = function (t, k)
    local cmd = string.lower(k)
    print(cmd)
    Redis.redis_sup = snax.queryservice("mod_redis_sup")
    local f = function (self, ... )
        local handle, pos = self.redis_sup.req.acquire(...)
        if handle > 0 then
            local db = snax.bind(handle, "mod_redis")
            local rs = db.req.cmd(cmd, ...)
            self.redis_sup.post.release(handle, pos)
            return rs
        end
        skynet.sleep(0.01)
        return f(self, ...)
    end
    t[k] = f
    return f
end})


return Redis
