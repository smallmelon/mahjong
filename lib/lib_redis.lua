local skynet = require "skynet"
local string = require "string"
local snax = require "snax"
local print_r = require "print_r"



local Redis = {
    redis_sup = nil
}


function Redis:init(cf)
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
        skynet.sleep(0.001)
        return f(self, ...)
    end
    t[k] = f
    return f
end})


return Redis
