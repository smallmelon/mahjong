local skynet = require "skynet"
local snax = require "snax"
local mysql = require "mysql"

local conf = {  
    host="127.0.0.1",
    port=3306,
    database="mhjong",
    user="root",
    password="",
    max_packet_size = 1024 * 1024
}

local db

function init(cf)
    cf = cf or conf
    db = mysql.connect(cf)
    if not db then
        print("failed to connect")
    end
end

function exit()
    db:close()
end

function response.query( ... )
    return db:query(...)
end
