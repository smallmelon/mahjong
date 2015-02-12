local Player = {
    uid = 0,
    nickname = 0,
    gold = 0,
    sex = 0,
    sign = ""
}

function Player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
end

return Player