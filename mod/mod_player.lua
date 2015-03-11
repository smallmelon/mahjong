local snax = require "snax"
local lib_redis = require "lib_redis"

local redis
local player = {}

function init(uid)
    redis = lib_redis:new()
    -- load data from redis database
end