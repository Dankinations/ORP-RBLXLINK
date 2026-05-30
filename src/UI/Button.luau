--!nolint LocalShadow
local btn = {}
btn.plugin = nil
btn.__index = btn

export type ButtonType = {
    Clicked:RBXScriptSignal,
    Main:TextButton,
    Toggle:boolean,
    GetState:(ButtonType)->(boolean),
    SetLabel:(ButtonType,string)->(),
    _state:boolean
}

function btn.init(plugin:Plugin)
    btn.plugin = plugin
end

function btn.new() : ButtonType
    local self = setmetatable({}, btn)
    self._state = false
    self.Main = Instance.new("TextButton")
    self.Main.BackgroundColor3 = Color3.new(0.611, 0, 0)
    self.Main.TextColor3 = Color3.new(1,1,1)

    local corner = Instance.new("UICorner",self.Main)
    corner.CornerRadius = UDim2.fromScale(0,.125)

    self.Main.MouseButton1Down:Connect(function()
        if self.Toggle then
            self._state = not self._state
        else
            self._state = true
        end
    end)

    self.Main.MouseButton1Up:Connect(function()
        if not self.Toggle then
            self._stataet = false
        end
    end)

    return self
end

function btn:GetState() : boolean
    local self:ButtonType = self
    return self._state
end

function btn:SetState(new:boolean)
    local self:ButtonType = self
    self._state = new

end

function btn:SetLabel(label:string)
    local self:ButtonType = self
    self.Main.Text = label
end