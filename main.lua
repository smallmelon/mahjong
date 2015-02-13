local skynet = require "skynet"
local snax = require "snax"

skynet.start(function ()
    print("Mahjong server start")
    local console = skynet.newservice("console")
    skynet.newservice("debug_console", 8000)
    -- init table sup
    local db = skynet.newservice("mod_redis")
    -- init watchdog
    --print(db.req.cmd("set", "a", "bb"))
    --print(db.req.cmd("get", "a"))
end)