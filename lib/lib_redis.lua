local skynet = require "skynet"
local redis = require "redis"

local conf = {
    host = "127.0.0.1" ,
    port = 6380 ,
    db = 0,
    auth = "_jiami2013"
}

local db

db = redis.connect(conf)

return db