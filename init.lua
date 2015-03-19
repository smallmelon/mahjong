local lib_redis = require "lib_redis"
local lib_mysql = require "lib_mysql"
local lib_player = require "lib_player"
local lib_seat = require "lib_seat"
local lib_logger = require "lib_logger"

local redis_config = require "redis_config"
local mysql_config = require "mysql_config"

function init()
    lib_logger:init()
    lib_redis:init(redis_config)
    lib_mysql:init(mysql_config)
    lib_seat:init()
    lib_player:init()   
end

return init