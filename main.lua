local skynet = require "skynet"
local snax = require "snax"
local table = require "table"
local redis = require "lib_redis"
local mysql = require "lib_mysql"
local test_logger = require "test_logger"


skynet.start(function ()
    print("Mahjong server start")
    local console = skynet.newservice("console")
    skynet.newservice("debug_console", 8000)
    -- init redis, mysql pool
    test_logger:test()
    redis:init()
    mysql:init()
    
end)