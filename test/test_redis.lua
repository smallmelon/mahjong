local redis = require "lib_redis"
local skynet = require "skynet"

local test = {}

function test:hmget(n)
    local now = skynet.now()
    
    redis:hmset("mykey", "a", 1, "b", 2, "c", 3)
    for i = 1, n do
        rs = redis:hmget("mykey", "a", "b", "c")
    end
    print("time total ", skynet.now() - now)
end

return test
