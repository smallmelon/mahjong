local lib_player = require "lib_player"

local Request = {}

function Request:login(msg)
    print("login", msg.ver, msg.token)
    local player = lib_player:new()
    player:get_info_from_redis(msg.ver)
    --player:set_info_to_redis()
    self.player = player
    self.auth = true
    return  {code = 200}
end

function Request:player()
    -- body
end


function Request:handshake()
    print("handshake")
    return { msg = "Welcome to mj, I will send heartbeat every 5 sec." }
end


return Request