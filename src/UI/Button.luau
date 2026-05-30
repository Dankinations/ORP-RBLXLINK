--!nolint LocalShadow
local TweenService = game:GetService("TweenService")
local btn = {}
btn.plugin = nil
btn.__index = btn

export type ButtonType = {
    Clicked:RBXScriptSignal,
    main:TextButton,
    baseColor:Color3,
    toggle:boolean,
    GetState:(ButtonType)->(boolean),
    SetLabel:(ButtonType,string)->(),
    SetPosition:(ButtonType,UDim2)->(),
    _state:boolean
}

function btn.init(plugin:Plugin)
    btn.plugin = plugin
end

function btn.new() : ButtonType
    local self = setmetatable({}, btn)
    self._state = false
    self.baseColor = Color3.fromRGB(87, 77, 198)
    self.main = Instance.new("TextButton")
    self.main.BackgroundColor3 = Color3.fromRGB(87, 77, 198)
    self.main.TextColor3 = Color3.new(1,1,1)
    self.main.AnchorPoint = Vector2.one*0.5
    self.main.Size = UDim2.fromOffset(200, 50)
    self.main.TextSize = 15
    self.main.AutoButtonColor = false
    self.main.Font = Enum.Font.Gotham

    local corner = Instance.new("UICorner",self.main)
    corner.TopLeftRadius = UDim.new(.125,0)
    corner.TopRightRadius = UDim.new(.125,0)

    local info = TweenInfo.new(.5)

    self.main.MouseEnter:Connect(function()
        TweenService:Create(self.main, info, {
            BackgroundColor3 = self.baseColor:Lerp(Color3.new(1,1,1), .25)
        }):Play()
    end)

    self.main.MouseLeave:Connect(function()
        TweenService:Create(self.main, info, {
            BackgroundColor3 = self.baseColor
        }):Play()
    end)

    self.main.MouseButton1Down:Connect(function()
        if self.toggle then
            self._state = not self._state
        else
            self._state = true
        end
    end)

    self.main.MouseButton1Up:Connect(function()
        if not self.toggle then
            self._state = false
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
    -- Need to add more logic here
end

function btn:SetLabel(label:string)
    self.main.Text = label
end

function btn:SetPosition(new:UDim2)
    self.main.Position = new
end

function btn:SetParent(new:Instance)
    self.main.Parent = new
end

return btn