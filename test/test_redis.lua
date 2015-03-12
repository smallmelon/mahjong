local lib_redis = require "lib_redis"
local skynet = require "skynet"

local test = {}

function test:hmget(n)
    local now = skynet.now()
    local redis = lib_redis;
    redis:hmset("mykey", "a", 1, "b", 2, "c", 3)
    for i = 1, n do
        rs = redis:hmget("mykey", "a", "b", "c")
        print(rs[1], rs[2], rs[3])
    end
    print("time total ", skynet.now() - now)
end


skynet.start(function ()
    test:hmget(10)
end)