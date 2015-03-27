local snax = require "snax"
local skynet = require "skynet"

local Seat = {
    seat_sup = nil,
    pid = nil
}

function Seat:init(cf)
    self.seat_sup = snax.uniqueservice("mod_seat_sup", cf)
end

function Seat:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
    local seat_sup = snax.queryservice("mod_seat_sup")
    if not seat_sup then 
        skynet.error('seat_sup queryservice return nil')
        return nil
    end
    o.seat_sup = seat_sup
    local handle = seat_sup.req.acquire()
    o.pid = snax.bind(handle, "mod_seat")
    return o
end

function Seat:change( ... )
    local s, r = self.pid.req.change(...)
    -- if success
    if s then
        local handle = self.seat_sup.req.acquire()
        self.pid = snax.bind(handle, "mod_seat")
        self.pid.req.enter(...)
    end
    return r
end

function Seat:leave( ... )
    if self.pid then
        self.pid.post.leave(...)
        self.pid = nil
    end
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
    return f
end})

return Seat