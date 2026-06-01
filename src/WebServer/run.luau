local ServerStorage = game:GetService("ServerStorage")
local Loadstring = ServerStorage["ORP-RBLXLINK"].Libraries.Loadstring

return function(code:string)
    local clone = Loadstring:Clone()
    clone.Parent = script
    local loadstring = require(clone)
    loadstring(code)()
    clone:Destroy()
end