local skynet = require "skynet"
local snax = require "snax"
local table = require "table"
local redis = require "lib_redis"
local mysql = require "lib_mysql"
local print_r = require "print_r"

local max_client = 10240
skynet.start(function ()
    print("Mahjong server start")
    local console = skynet.newservice("console")
    skynet.newservice("debug_console", 8000)
    redis:init()
    mysql:init()

    local watchdog = skynet.newservice("watchdog")
    skynet.call(watchdog, "lua", "start", {
        port = 10086,
        maxclient = max_client,
        nodelay = true,
    })

    skynet.kill(skynet.newservice("test_redis"))
    skynet.kill(skynet.newservice("test_mysql"))
    print("Watchdog listen on ", 10086)

    skynet.exit()
    
end)