local skynet = require "skynet"
local snax = require "snax"
local mysql = require "mysql"
local lib_logger = require "lib_logger" 
local lib_utils = require "lib_utils"

local logger 

local dbs = {}
function init(cf, num)
    num = num or 5
    logger = lib_logger:new("./mahjong/logs/mysql")
    for i = 1, num do
        local db = mysql.connect(cf)
        if not db then
            logger:error("failed to connect mysql %s", lib_utils.format_dict(cf))
        end
        table.insert(dbs, db)
    end
end

function exit()
    for k, db in ipairs(dbs) do
        db:close()
    end
end

function response.query( ... )
    while #dbs < 1 do
        skynet.sleep(math.random(1, 50))
        logger:warn("mysql busy")
    end
    local db = table.remove(dbs, 1)
    logger:debug(...)
    local rs = db:query(...)
    table.insert(dbs, db)
    return rs
end
