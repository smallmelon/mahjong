local skynet = require "skynet"
local snax = require "snax"


local Mysql = {
    mysql_sup = nil,
    pool = nil
}


function Mysql:init(cf) 
    self.mysql_sup = snax.uniqueservice("mod_mysql_sup", cf)
end

function Mysql:query( ... )
    if not self.mysql_sup then
        self.mysql_sup = snax.queryservice("mod_mysql_sup")
    end
    if not self.pool then 
        self.pool = {} -- get mysql pool
        local pool = self.mysql_sup.req.acquire()
        for k, v in ipairs(pool) do
            self.pool[k] = snax.bind(v, "mod_mysql")
        end
    end
    local db = self.pool[math.random(1, #self.pool)]
    return db.req.query(...)
end

return Mysql