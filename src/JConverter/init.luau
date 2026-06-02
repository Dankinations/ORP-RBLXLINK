local CEnum = require(script.enums)

local DefaultValues = {
    Color = Color3.new(1,1,1),
    Size = Vector3.new(1,1,1),
    Position = Vector3.zero,
    Shape = Enum.PartType.Block,
    Transparency = 0,
    CanCollide = true
}

function CutOffFloat(num)
    local stringified = tostring(num)
    if stringified:find(".") then
        local split = stringified:split(".")
        local big = split[1]
        local decimal = split[2]
        decimal = decimal:sub(1,3)
        return tonumber(`{big}.{decimal}`)
    end
    return num
end

function SerializeProperty(var:any) : any
    if typeof(var) == "Color3" then
        return var:ToHex()
    elseif typeof(var) == "Vector3" then
        return {X=CutOffFloat(var.X),Y=CutOffFloat(var.Y),Z=CutOffFloat(var.Z)}
    elseif typeof(var) == "EnumItem" then
        return var.Value
    end

    return var
end

local converters = { -- ClassName : function
    ["Part"] = function(self:Part)
        local tbl = {}
        for name, index in CEnum.Properties.Part do
            tbl[index] = SerializeProperty(self[name])
        end
    end
}

return function(objects:{Instance})
    for _,v in objects do
        if not (typeof(v) == "Instance") then return end
        if not converters[v] then return end
    end
end
