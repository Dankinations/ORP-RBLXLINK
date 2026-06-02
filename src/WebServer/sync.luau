local WebServer = require(script.Parent)

return function()
    WebServer.Send("sync|")
end