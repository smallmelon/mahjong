local lib_player = require "lib_player"
local print_r = require "print_r"
local Request = {}

function Request:login(msg)
    local player = lib_player:new()
    local password = player:get_password_by_uid(msg.uid)
    if password ~= msg.passwd then
        return {code = 400}
    end
    player:get_info_from_redis(msg.uid)
    player:undate_login()
    self.player = player
    self.auth = true
    local msg = player:get_user_info()
    msg["code"] = 200
    return msg
end

function Request:register(msg)
    local player = lib_player:new()
    player:register(msg)
    return {code = 200, uid = player:get_uid()}
end
function Request:player()
    -- body
end


function Request:handshake()
    return { msg = "Welcome to mj, I will send heartbeat every 5 sec." }
end


return Request