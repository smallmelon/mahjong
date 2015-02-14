local skynet = require "skynet"
local snax = require "snax"

skynet.start(function ()
    print("Mahjong server start")
    local console = skynet.newservice("console")
    skynet.newservice("debug_console", 8000)
    -- init table sup
    local db = snax.uniqueservice("mod_redis")
    print(db.req.get("aaaa1"))
    print(db.req.set("aaaa1", "redis2"))

    -- init watchdog
    --print(db.req.cmd("set", "a", "bb"))
    --print(db.req.cmd("get", "a"))
end)