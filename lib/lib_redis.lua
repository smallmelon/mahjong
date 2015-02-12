local skynet = require "skynet"
local redis = require "redis"

local conf = {
    host = "127.0.0.1" ,
    port = 6379 ,
    db = 0
}

local db

db = redis.connect(conf)

return db