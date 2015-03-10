local snax = require "snax"

local seat = {
    hallId = 0,
    roomId = 0,
    seatId = 0,
    max = 0,
    min = 0,
    base = 0
}

local players = {}

function init(cf)
    -- body
end

function exit()
    -- body
end
 
--
function response.enter( ... )
    -- body
end

function response.ready( ... )
    -- body
end

function response.host( ... )
    -- body
end

function response.nohost( ... )
    -- body
end

function  response.restore( ... )
    -- body
end
function response.draw( ... )
    -- body
end

function response.chow( ... )
    -- body
end

function response.kongdraw( ... )
    -- body
end

function response.pop( ... )
    -- body
end

function response.pong( ... )
    -- body
end

function response.chowkong( ... )
    -- body
end

function response.pongkong( ... )
    -- body
end

--暗杠
function response.concealed( ... )
    -- body
end

function response.drawhu( ... )
    -- body
end

function response.chowhu( ... )
    -- body
end

function response.redouble( ... )
    -- body
end

function response.ting( ... )
    -- body
end

function response.confirmwin( ... )
    -- body
end

function response.leave( ... )
    -- body
end

function response.force_leave( ... )
    -- body
end
