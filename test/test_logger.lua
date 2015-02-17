local logger = require "lib_logger"
local skynet = require "skynet"

local test = {}

function  test:test( ... )
    log = logger:new("./mahjong/logs/test")
    log:set_level(4)
    while (1) do
        log:debug("debug log")
        log:warn("warn log")
        log:info("info log")
        log:error("error log")
        log:fatal("fatal log")
        skynet.sleep(0.1)
    end

end

return test