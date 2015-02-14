local skynet = require "skynet"
local redis = require "redis"
local snax = require "snax"


local db

function init(cf)
    db = redis.connect(cf)
end

function exit( )
    db:close()
end

function response.cmd(cmd, ... )
    local f = db[cmd]
    return f(db, ...)
end

function accept.cmd(cmd, ... )
    local f = db[cmd]
    f(db, ...)
end
