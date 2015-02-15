local skynet = require "skynet"
local snax = require "snax"
local lib_redis = require "lib_redis"
local lib_mysql = require "lib_mysql"
local table = require "table"

local mysql = require "mysql"

local conf = {  
    host="127.0.0.1",
    port=3306,
    database="mhjong",
    user="root",
    password="",
    max_packet_size = 1024 * 1024
}



skynet.start(function ()
    print("Mahjong server start")
    local console = skynet.newservice("console")
    skynet.newservice("debug_console", 8000)
    -- init table sup
    lib_redis:init()
    lib_mysql:init()
    print(lib_redis:get("aaaa"))
    -- init watchdog
    --print(db.req.cmd("set", "a", "bb"))
    --print(db.req.cmd("get", "a"))
end)