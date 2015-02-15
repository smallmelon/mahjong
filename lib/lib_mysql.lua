local skynet = require "skynet"
local snax = require "snax"
local table = require "table"

local Mysql = {
    db_pool = {}
}

local conf = {  
    host="127.0.0.1",
    port=3306,
    database="mhjong",
    user="root",
    password="",
    max_packet_size = 1024 * 1024
}


function Mysql:init(cf)
    cf = cf or conf 
    for i = 1, 10 do
        local db = snax.newservice("mod_mysql",cf)
        self.db_pool[i] = db
    end
end

function Mysql:query( ... )
    if #self.db_pool > 0 then
        local db = table.remove(self.db_pool, 1)
        local rs = db.req.query(...)
        table.insert(self.db_pool, db)
        return rs
    end
    print("here")
    skynet.sleep(0.01)
    return self:query(...)
end

return Mysql