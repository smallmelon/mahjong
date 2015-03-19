local skynet = require "skynet"
local snax = require "snax"
local mysql = require "mysql"
local lib_logger = require "lib_logger"

local db
local logger 

function init(cf)
    logger = lib_logger:new("./mahjong/logs/mysql")
    db = mysql.connect(cf)
    if not db then
        logger:error("failed to connect mysql", table.unpack(cf))
    end
end

function exit()
    db:close()
end

function response.query( ... )
    logger:debug(...)
    return db:query(...)
end
