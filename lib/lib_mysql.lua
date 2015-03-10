local skynet = require "skynet"
local snax = require "snax"


local Mysql = {
    mysql_sup = nil
}

local conf = {  
    host="127.0.0.1",
    port=3306,
    database="mhjong",
    user="root",
    password="",
    max_packet_size = 1024 * 1024
}

function Mysql:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.mysql_sup = snax.queryservice("mod_mysql_sup")
    return o
end

function Mysql:init(cf)
    cf = cf or conf 
    self.mysql_sup = snax.uniqueservice("mod_mysql_sup", cf)
end

function Mysql:query( ... )
    local handle = self.mysql_sup.req.acquire()
    if handle > 0 then
        local db = snax.bind(handle, "mod_mysql")
        local rs = db.req.query(...)
        self.mysql_sup.post.release(handle)
        return rs
    end
    skynet.sleep(0.01)
    return self:query(...)
end

return Mysql