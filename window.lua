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

return Window