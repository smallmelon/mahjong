local lib_mysql =  require "lib_mysql"
local print_r  = require "print_r"
local skynet = require "skynet"

skynet.start(function ()
    local mysql = lib_mysql;
    local rs = mysql:query("show databases")
    print_r(rs)
end)