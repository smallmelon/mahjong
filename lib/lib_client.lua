local socket = require "socket"
local sproto = require "sproto"

local client = {
    fd = nil,
    player = nil,
    auth = nil,
    seat = nil,
    host = nil,
    request = nil
}

function client:new( o )
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function client:start(fd, proto)
    self.fd = fd
    self.host = sproto.new(proto.c2s):host "package"
    self.request = self.host:attach(sproto.new(proto.s2c))
end

function client:send_package(pack)
    local package = string.pack(">s2", pack)
    if self.fd then
       socket.write(self.fd, package)
    end
end

function client:send_request(name, args)
    self:send_package( self.request(name, args))
end

function client:close()
    if self.seat then
        self.seat:leave({uid = self.player.uid})
        self.seat = nil
    end
    if self.fd then
        socket.close(self.fd)
        self.fd = nil
    end

    self.auth = false
end

return client

