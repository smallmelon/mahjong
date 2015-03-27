local skynet = require "skynet"
 
skynet.start(function ()
    for i = 1, 1 do
        local uid = i
        --print("new client uid ", uid)
        skynet.newservice("test_client", uid)
    end
end)