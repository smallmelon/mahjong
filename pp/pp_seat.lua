local lib_player = require "lib_player"
local lib_seat = require "lib_seat"

local Request = {
    
}

function Request:enter( ... ) -- 
    self.seat = lib_seat:new() -- client.seat = seat object
    return self.seat:enter(...)
end

setmetatable(Request, {__index = function (t, k)
    local cmd = string.lower(k)
    local  f = function (self, ... )
        if not self.seat then
            print("error requst", ...)
            return {}
        end
        return self.seat.[cmd](self.seat, ...) -- seat:cmd(...)
    end
    t[k] = f
    return f
end})

return Request