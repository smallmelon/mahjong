local skynet = require "skynet"
local snax = require "snax"
local init = require "init"
local print_r = require "print_r"

local max_client = 10240
skynet.start(function ()
    print("Mahjong server start")
    local console = skynet.newservice("console")
    skynet.newservice("debug_console", 8000)
    init() -- init
    local watchdog = skynet.newservice("watchdog")
    skynet.call(watchdog, "lua", "start", {
        port = 10086,
        maxclient = max_client,
        nodelay = true,
    })
    
    skynet.newservice("test")
    print("Watchdog listen on ", 10086)

    skynet.exit()
    
end)