--!nolint LocalShadow
local TweenService = game:GetService("TweenService")
local Signal = require(script.Parent.Parent.Libraries.Signal)
local btn = {}
btn.plugin = nil
btn.__index = btn

export type ButtonType = {
	StateChanged: Signal.Signal<boolean>,
	main: TextButton,
	baseColor: Color3,
	toggle: boolean,
	hovering:boolean,
	GetState: (self:ButtonType) -> (boolean),
	SetState: (self:ButtonType, newState:boolean) -> (),
	SetLabel: (ButtonType, newText: string) -> (),
	SetPosition: (ButtonType, newPos: UDim2) -> (),
	UpdateColor: (ButtonType, newColor: Color3) -> (),
	_state: boolean,
}

function btn.init(plugin: Plugin)
	btn.plugin = plugin
end

function btn.new(): ButtonType
	local self = setmetatable({}, btn)
	self._state = false
	self.baseColor = Color3.fromRGB(87, 77, 198)
	self.main = Instance.new("TextButton")
	self.main.BackgroundColor3 = Color3.fromRGB(87, 77, 198)
	self.main.TextColor3 = Color3.new(1, 1, 1)
	self.main.AnchorPoint = Vector2.one * 0.5
	self.main.Size = UDim2.fromOffset(200, 50)
	self.main.TextSize = 15
	self.main.AutoButtonColor = false
	self.main.Font = Enum.Font.Gotham

	local corner = Instance.new("UICorner")
	corner.Parent = self.main
	corner.TopLeftRadius = UDim.new(0.125, 0)
	corner.TopRightRadius = UDim.new(0.125, 0)

	local info = TweenInfo.new(0.25)
	local goalColor = self.baseColor

	local function UpdateColor()
		local final = goalColor
		if self.hovering then
			final = final:Lerp(Color3.new(0,0,0), .125)
		end
		TweenService:Create(self.main, info, {
			BackgroundColor3 = final,
		}):Play()
	end

	self.main.MouseEnter:Connect(function()
		self.hovering = true
		UpdateColor()
	end)

	self.main.MouseLeave:Connect(function()
		self.hovering = false
		UpdateColor()
	end)

	self.main.MouseButton1Down:Connect(function()
		if self.toggle then
			self:SetState(not self:GetState())
		else
			self:SetState(true)
		end
	end)

	self.main.MouseButton1Up:Connect(function()
		if not self.toggle then
			self:SetState(false)
		end
	end)

	self.StateChanged = Signal()

	self.StateChanged:Connect(function(new)
		if new == true then
			goalColor = self.baseColor:Lerp(Color3.new(0,0,0), .5)
		else
			goalColor = self.baseColor
		end
		UpdateColor()
	end)

	return self
end

function btn:GetState(): boolean
	local self: ButtonType = self
	return self._state
end

function btn:SetState(new: boolean)
	local self: ButtonType = self
	self._state = new
	self.StateChanged:Fire(new)
	-- Need to add more logic here, for animations
end

function btn:SetLabel(label: string)
	self.main.Text = label
end

function btn:SetPosition(new: UDim2)
	self.main.Position = new
end

function btn:SetParent(new: Instance)
	self.main.Parent = new
end

function btn:UpdateColor(new:Color3)
	local self: ButtonType = self
	self.StateChanged:Fire(self:GetState())
end

return btn
