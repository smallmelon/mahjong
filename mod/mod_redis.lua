local skynet = require "skynet"
local redis = require "redis"
local snax = require "snax"
local lib_logger = require "lib_logger"

local db
local logger

function init(cf)
    db = redis.connect(cf)
    logger = lib_logger:new("./mahjong/logs/redis")
end

function exit( )
    db:close()
end

function response.cmd(cmd, ... )
    logger:debug(cmd, ...)
    local f = db[cmd]
    return f(db, ...)
end

function accept.cmd(cmd, ... )
    local f = db[cmd]
    f(db, ...)
end
