local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local VexUI = {}
VexUI.__index = VexUI

function VexUI:CreateWindow(config)
    local gui = Instance.new("ScreenGui")
    gui.Name = "VexUI"
    gui.ResetOnSpawn = false
    gui.Parent = Player:WaitForChild("PlayerGui")

    -- MAIN
    local main = Instance.new("Frame")
    main.Size = UDim2.fromScale(0, 0)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    main.BackgroundTransparency = 0.15
    main.Parent = gui

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(120, 40, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.3

    -- TOP BAR
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 48)
    top.BackgroundTransparency = 1
    top.Parent = main

    -- ICON
    local icon = Instance.new("ImageLabel")
    icon.Image = "rbxassetid://71194548478826"
    icon.Size = UDim2.fromOffset(28, 28)
    icon.Position = UDim2.fromOffset(14, 10)
    icon.BackgroundTransparency = 1
    icon.ImageTransparency = 1
    icon.Parent = top

    -- TITLE
    local title = Instance.new("TextLabel")
    title.Text = config.Title or "VexUI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextColor3 = Color3.fromRGB(230,230,230)
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(52, 0)
    title.Size = UDim2.new(1, -52, 1, 0)
    title.TextXAlignment = Left
    title.TextTransparency = 1
    title.Parent = top

    -- 🎬 ANIMAÇÃO DE ENTRADA
    TweenService:Create(
        main,
        TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {Size = UDim2.fromOffset(520, 360)}
    ):Play()

    task.delay(0.1, function()
        TweenService:Create(
            icon,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {ImageTransparency = 0}
        ):Play()

        TweenService:Create(
            title,
            TweenInfo.new(0.4),
            {TextTransparency = 0}
        ):Play()
    end)

    return main
end

return VexUI