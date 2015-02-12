local skynet = require "skynet"

skynet.start(function ()
    print("Mahjong server start")
    local console = skynet.newserveice("console")
    skynet.newserveice("debug_console", 8000)
    -- init table sup
    -- init watchdog
end)