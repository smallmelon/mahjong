local skynet = require "skynet"
local snax = require "snax"
local lib_redis = require "lib_redis"

skynet.start(function ()
    print("Mahjong server start")
    local console = skynet.newservice("console")
    skynet.newservice("debug_console", 8000)
    -- init table sup
    lib_redis:init()
    print(lib_redis:get("aaa"))
    -- init watchdog
    --print(db.req.cmd("set", "a", "bb"))
    --print(db.req.cmd("get", "a"))
end)