local skynet = require "skynet"
local redis = require "redis"
local snax = require "snax"
local lib_logger = require "lib_logger"

local dbs = {}
local logger

function init(cf, num)
    num = num or 5
    for i =1, num do
        table.insert(dbs, redis.connect(cf))
    end
    logger = lib_logger:new("./mahjong/logs/redis")
end

function exit( )
    for i, db in ipairs(dbs) do
        db:close()
    end
end

function response.cmd(cmd, ... )
    logger:debug(cmd, ...)
    while #dbs < 1 do
        logger:warn("redis busy")
        skynet.sleep(math.random(1, 50))
    end
    db = table.remove(dbs, 1)
    local f = db[cmd]
    local r = f(db, ...)
    table.insert(dbs, db)
    return r
end

function accept.cmd(cmd, ... )
    logger:debug(cmd, ...)
    while #dbs < 1 do
        skynet.sleep(0)
    end
    db = table.remove(dbs, 1)
    local f = db[cmd]
    f(db, ...)
    table.insert(dbs, db)
end
