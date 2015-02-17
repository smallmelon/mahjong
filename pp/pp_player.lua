local bit32 = require "bit32"

local Request = {}


function Request:register()
    print("register", self.device, self.uuid, self.channel)
    return {uid = 10001, passwd = "what fuck", key = "secret key"}
end

function Request:login()
    -- body
end

function Request:player()
    -- body
end


function Request:handshake()
    return { msg = "Welcome to mj, I will send heartbeat every 5 sec." }
end


return Request