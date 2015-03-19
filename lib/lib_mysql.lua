local skynet = require "skynet"
local snax = require "snax"


local Mysql = {
    mysql_sup = nil,
    pool = {}
}


function Mysql:init(cf) 
    self.mysql_sup = snax.uniqueservice("mod_mysql_sup", cf)
end

function Mysql:query( ... )
    if not self.mysql_sup then
        self.mysql_sup = snax.queryservice("mod_mysql_sup")
    end
    local handle = self.mysql_sup.req.acquire()
    if handle > 0 then
        local db = self.pool[handle]
        if not db then
            db = snax.bind(handle, "mod_mysql")
            self.pool[handle] = db
        end
        local rs = db.req.query(...)
        self.mysql_sup.post.release(handle)
        return rs
    end
    skynet.sleep(0.001)
    return self:query(...)
end

return Mysql