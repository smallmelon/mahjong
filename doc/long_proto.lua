local proto = { 
    s2c = nil,
    c2s = nil
}
proto.c2s = [[
.package {
    type 0 : integer
    session 1 : integer
}

handshake 1 {
    response {
        msg 0  : string
    }
}

login 2 {
    request {
        ver 0 : integer
        token 1 : string
    }
    response {
        code 0 : integer
    }
}
]]

proto.s2c = 
[[
.package {
    type 0 : integer
    session 1 : integer
}

heartbeat 1 {}
]]

return proto