local snax = require "snax"

local Seat = {
    seat_sup = nil
    pid = nil
}

function Seat:init(cf)
    self.seat_sup = snax.uniqueservice("mod_seat_sup", cf)
end

function Seat:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.seat_sup = snax.queryservice("mod_seat_sup")
    local handle = o.seat_sup.req.acquire()
    o.pid = snax.bind(handle, "mod_seat")
    return o
end

function Seat:change( ... )
    local s, r = self.pid.req.change(...)
    -- if success
    if s then
        local handle = self.seat_sup.req.acquire()
        s.pid = snax.bind(handle, "mod_seat")
    end
    return r
end

function Seat:leave( ... )
    local s , r = self.pid.req.leave(...)
    if s then
        self.pid = nil
    end
    return r
end

function Seat:leave_force( ... )
    local s , r = self.pid.req.leave_force(...)
    if s then
        self.pid = nil
    end
    return r
end


setmetatable(Seat, {__index = function (t, k)
    local cmd = string.lower(k)
    local f = function (self, ... )
        return self.pid.req[cmd](...) -- call seat service 
    end
    t[k] = f
end})

return Seat