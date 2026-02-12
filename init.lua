--// VexUI Library - Core
--// Mobile Safe + Smooth Animations

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local VexUI = {}
VexUI.__index = VexUI

function VexUI:CreateWindow(config)
    config = config or {}

    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "VexUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = Player:WaitForChild("PlayerGui")

    -- Main Frame
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.fromOffset(520, 360)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    main.BackgroundTransparency = 1
    main.Parent = gui

    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = main

    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 40, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = main

    -- UIScale (animação segura)
    local scale = Instance.new("UIScale")
    scale.Scale = 0.92
    scale.Parent = main

    -- TopBar
    local top = Instance.new("Frame")
    top.Name = "TopBar"
    top.Size = UDim2.new(1, 0, 0, 48)
    top.BackgroundTransparency = 1
    top.Parent = main

    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Image = "rbxassetid://71194548478826"
    icon.Size = UDim2.fromOffset(28, 28)
    icon.Position = UDim2.fromOffset(14, 10)
    icon.BackgroundTransparency = 1
    icon.ImageTransparency = 1
    icon.Parent = top

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = config.Title or "VexUI Library"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextColor3 = Color3.fromRGB(235, 235, 235)
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(52, 0)
    title.Size = UDim2.new(1, -52, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTransparency = 1
    title.Parent = top

    --// ANIMAÇÕES

    -- Fade + Glass
    TweenService:Create(
        main,
        TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.15}
    ):Play()

    -- Scale pop
    TweenService:Create(
        scale,
        TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Scale = 1}
    ):Play()

    -- Icon fade
    TweenService:Create(
        icon,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {ImageTransparency = 0}
    ):Play()

    -- Title fade
    TweenService:Create(
        title,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    ):Play()

    -- Stroke pulse (leve, sem loop manual)
    TweenService:Create(
        stroke,
        TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true),
        {Transparency = 0.3}
    ):Play()

    return main
end

return VexUI