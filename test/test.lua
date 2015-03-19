local skynet = require "skynet"
local print_r = require "print_r"

skynet.start(function ( )
    skynet.newservice("test_mysql")
    skynet.newservice("test_redis")
    skynet.newservice("test_logger", "_a")
    skynet.newservice("test_logger", "_b")
end)