local skynet = require "skynet"
local string = require "string"
local snax = require "snax"



local Redis = {
    db_pool = {}
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

function hash_key(key)
    local value = 0
    for i=1, #key do
        value = value + string.byte(key, i)
    end
    return value
end

function Redis:choice_db(...)
    local hash_value = hash_key(select(1, ...))
    return self.db_pool[hash_value % 2 + 1]
end


function Redis:init(cf)
    cf = cf or conf
    for i=1, #cf do
        local dbs = {}
        for j= 1, 10 do
            local db = snax.newservice("mod_redis", cf[i])
            dbs[j] = db
        end
        self.db_pool[i] = dbs
    end
end

setmetatable(Redis, { __index = function (t, k)
    local cmd = string.lower(k)
    local f = function (self, ... )
        local dbs = self:choice_db(...)
        if #dbs > 0 then
            local db = table.remove(dbs, 1)
            local rs = db.req.cmd(cmd, ...)
            table.insert(dbs, db)
            return rs
        end
        skynet.sleep(0.01)
        return f(self, ...)
    end
    t[k] = f
    return f
end})

return Redis

