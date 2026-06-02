local Loadstring = script.Parent.Parent.Libraries.Promise

return function(code:string)
    local clone = Loadstring:Clone()
    clone.Parent = script
    local loadstring = require(clone)
    loadstring(code)()
    clone:Destroy()
end