local Window = {}
Window.__index = Window

local Players = game:GetService("Players")

function Window:Create(vexui, options)
    local self = setmetatable({}, Window)

    self.VexUI = vexui
    self.Config = options.Config
    self.Theme = options.Theme
    self.Tabs = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "VexUI"
    gui.Parent = game.CoreGui

    local main = Instance.new("Frame")
    main.Size = self.Config.Size
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = self.Theme.Background
    main.BackgroundTransparency = self.Theme.Transparency
    main.Parent = gui

    self.Gui = gui
    self.Main = main

    return self
end
--// DRAG SYSTEM (Mobile + PC, smooth)

local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

top.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
return Window