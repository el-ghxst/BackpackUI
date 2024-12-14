
local players = game:GetService("Players")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

local BackpackUI = {
	Connections = {},
	OnChildAdded = {},
	OnChildRemoved = {},
	OnToolEquip = {},
	OnToolUnequip = {},
	Slots = {},
	Animations = true,
	EquipColor = Color3.fromRGB(24, 105, 255),
	EquipAnimTime = 0.1,
	Disconnected = false,
	Version = 1
}
local ScreenGui = Instance.new("ScreenGui")
local Base = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Frame = Instance.new("Frame")
local SlotFrame = Instance.new("TextButton")
local ToolName = Instance.new("TextLabel")
local SlotNumber = Instance.new("TextLabel")
local UIGradient = Instance.new("UIGradient")

--Properties:

ScreenGui.Parent = game:GetService("CoreGui")

Base.Name = "Base"
Base.Parent = ScreenGui
Base.AnchorPoint = Vector2.new(0.5, 0.5)
Base.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Base.BackgroundTransparency = 1.000
Base.Position = UDim2.new(0.5, 0, 0.949999988, 0)
Base.Size = UDim2.new(0, 572, 0, 57)

UIListLayout.Parent = Base
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

Frame.Parent = nil
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.368881106, 0, -0.157894731, 0)
Frame.Size = UDim2.new(0, 58, 0, 56)

SlotFrame.Name = "SlotFrame"
SlotFrame.Parent = Frame
SlotFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SlotFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SlotFrame.BackgroundTransparency = 0.850
SlotFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
SlotFrame.Position = UDim2.new(0.5, 0, 0.519999981, 0)
SlotFrame.Size = UDim2.new(0, 54, 0, 52)
SlotFrame.Text = ""

ToolName.Name = "ToolName"
ToolName.Parent = SlotFrame
ToolName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToolName.BackgroundTransparency = 1.000
ToolName.BorderSizePixel = 0
ToolName.Position = UDim2.new(-0.000908868969, 0, -0.00539104734, 0)
ToolName.Size = UDim2.new(0, 53, 0, 52)
ToolName.Font = Enum.Font.RobotoCondensed
ToolName.Text = "M4A1"
ToolName.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolName.TextScaled = true
ToolName.TextSize = 14.000
ToolName.TextWrapped = true

SlotNumber.Name = "SlotNumber"
SlotNumber.Parent = SlotFrame
SlotNumber.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SlotNumber.BackgroundTransparency = 1.000
SlotNumber.Position = UDim2.new(0,0,0,0)
SlotNumber.Size = UDim2.new(0, 18, 0, 14)
SlotNumber.Font = Enum.Font.SourceSans
SlotNumber.Text = "1"
SlotNumber.TextColor3 = Color3.fromRGB(255, 255, 255)
SlotNumber.TextSize = 14.000

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(162, 162, 162)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
UIGradient.Rotation = -90
UIGradient.Parent = SlotFrame

local lp = players.LocalPlayer

BackpackUI.Currentbackpack = {}
BackpackUI.CurrentSlots = {}
local Pos1 = UDim2.new(0.5, 0, 0.519999981, 0)
local Pos2 = UDim2.new(0.5, 0, 0.479999989, 0)

local Color1 = Color3.fromRGB(0, 0, 0)
local Color2 = BackpackUI.EquipColor
local function equipOrUnequip(tool)
	if tool then
		local char = lp.Character
		local backpack = lp.Backpack
		local hum = char:FindFirstChild("Humanoid")
		if hum then
			if tool.Parent == char then
				hum:UnequipTools()
			elseif tool.Parent == backpack then
				hum:UnequipTools()
				hum:EquipTool(tool)
			end
		end
	end
end
local function UpFrame(Frame)
	local f2 = Frame.SlotFrame
	if BackpackUI.Animations == true then
		ts:Create(f2, TweenInfo.new(BackpackUI.EquipAnimTime), {BackgroundColor3 = Color2}):Play()
		ts:Create(f2, TweenInfo.new(BackpackUI.EquipAnimTime), {Position = Pos2}):Play()
	else
		f2.Position = Pos2
		f2.BackgroundColor3 = Color2
	end
end
local function DownFrame(Frame)
	local f2 = Frame.SlotFrame
	if BackpackUI.Animations == true then
		ts:Create(f2, TweenInfo.new(BackpackUI.EquipAnimTime), {BackgroundColor3 = Color1}):Play()
		ts:Create(f2, TweenInfo.new(BackpackUI.EquipAnimTime), {Position = Pos1}):Play()
	else
		f2.Position = Pos1
		f2.BackgroundColor3 = Color1
	end
end
BackpackUI.BConnection = nil
local function tool(child, backpack)
	if not table.find(BackpackUI.Currentbackpack, child) then
		table.insert(BackpackUI.Currentbackpack, child)
		for i,funct in pairs(BackpackUI.OnChildAdded) do
			if type(funct) == "function" then
				task.spawn(function()
					pcall(funct, child, true)
				end)
			end
		end
		local Slot = Frame:Clone()
		Slot.Parent = Base
		local slotNumber = table.find(BackpackUI.Slots, child.Name)
		if slotNumber then
			BackpackUI.CurrentSlots[slotNumber] = child
			Slot.LayoutOrder = slotNumber
			Slot.SlotFrame.SlotNumber.Text = slotNumber
		else
			Slot.LayoutOrder = 10000
			Slot.SlotFrame.SlotNumber.Text = "?"
		end
		Slot.SlotFrame.ToolName.Text = child.Name
		Slot.SlotFrame.MouseButton1Down:connect(function()
			equipOrUnequip(child)
		end)
		local conn
		conn = child.AncestryChanged:connect(function(child, parent)
			if parent ~= lp.Character and parent ~= backpack and parent ~= lp then
				Slot:Destroy()
				if tonumber(slotNumber) ~= nil then
					if BackpackUI.CurrentSlots[slotNumber] then
						BackpackUI.CurrentSlots[slotNumber] = nil
					end
				end
				conn:Disconnect()
			end
			if parent ~= nil and parent.Name == lp.Name then
				UpFrame(Slot)
			end
			if parent ~= nil and parent.Name == "Backpack" then
				DownFrame(Slot)
			end
		end)
	else
		for i,funct in pairs(BackpackUI.OnChildAdded) do
			if type(funct) == "function" then
				task.spawn(function()
					pcall(funct, child, true)
				end)
			end
		end
	end
end
local function scriptbackpack(backpack)
	for _,v in pairs(Base:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	BackpackUI.Currentbackpack = {}
	BackpackUI.CurrentSlots = {}
	if BackpackUI.BConnection ~= nil then
		BackpackUI.BConnection:Disconnect()
		BackpackUI.BConnection = nil
	end
	
	BackpackUI.BConnection = backpack.ChildAdded:connect(function(child)
		tool(child,backpack)
	end)
	for _,child in pairs(backpack:GetChildren()) do
		tool(child,backpack)
	end
end

function BackpackUI.OnChildAdded:Connect(funct)
	if type(funct) ~= "function" then return nil end
	local tab = {}
	table.insert(BackpackUI.OnChildAdded, funct)
	function tab:Disconnect()
		table.remove(BackpackUI, table.find(BackpackUI, funct))
		tab = nil
	end
	return tab
end
function BackpackUI.OnToolEquip:Connect(funct)
	if type(funct) ~= "function" then return nil end
	local tab = {}
	table.insert(BackpackUI.OnToolEquip, funct)
	function tab:Disconnect()
		table.remove(BackpackUI, table.find(BackpackUI, funct))
		tab = nil
	end
	return tab
end
function BackpackUI.OnToolUnequip:Connect(funct)
	if type(funct) ~= "function" then return nil end
	local tab = {}
	table.insert(BackpackUI.OnToolEquip, funct)
	function tab:Disconnect()
		table.remove(BackpackUI, table.find(BackpackUI, funct))
		tab = nil
	end
	return tab
end
function BackpackUI.OnChildRemoved:Connect(funct)
	if type(funct) ~= "function" then return nil end
	local tab = {}
	table.insert(BackpackUI.OnChildRemoved, funct)
	function tab:Disconnect()
		table.remove(BackpackUI, table.find(BackpackUI, funct))
		tab = nil
	end
	return tab
end

BackpackUI.Connections = {
	lp.CharacterAdded:Connect(function()
		local b = lp:WaitForChild("Backpack")
		scriptbackpack(b)
	end),
	uis.InputBegan:connect(function(input, process)
		if not process then
			local letnum = {
				"One",
				"Two",
				"Three",
				"Four",
				"Five",
				"Six",
				"Seven",
				"Eight",
				"Nine",
				"Zero"
			}
			local num = nil
			for i = 1,#letnum do
				if input.KeyCode.Name == letnum[i] then
					num = i
				end
			end
			if num then
				local tool = BackpackUI.CurrentSlots[num]
				equipOrUnequip(tool)
			end
		end

	end)
}
function BackpackUI:SetSlot(Name, Number)
	if tostring(Name) and tonumber(Number) then
		local find = table.find(BackpackUI.Slots, Name)
		if find then
			BackpackUI.Slots[find] = nil
		end
		BackpackUI.Slots[Number] = Name
	end
end
function BackpackUI:Disconnect()
	for _,conn in pairs(BackpackUI.Connections) do
		conn:Disconnect()
	end
	BackpackUI.Connections = nil
	BackpackUI.Disconnected = true
	BackpackUI = nil
	Base:Destroy()
	Frame:Destroy()
	SlotFrame:Destroy()
	UIGradient:Destroy()
	ToolName:Destroy()
	SlotNumber:Destroy()
end
task.spawn(function()
	repeat wait()
		if game.StarterGui:GetCoreGuiEnabled("Backpack") == true then
			game.StarterGui:SetCoreGuiEnabled("Backpack", false)
		end
	until BackpackUI.Disconnected == true
end)

return BackpackUI
