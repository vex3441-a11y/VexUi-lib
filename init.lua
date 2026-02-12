--// VexUI Library - Full Build with Animated Tabs
--// Window + Drag + Animated Tabs (Mobile + PC)

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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

    -- Corner & Stroke
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = main

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 40, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = main

    -- UIScale (animation safe)
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

    -- Tabs container (left side)
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "Tabs"
    tabsFrame.Size = UDim2.new(0, 120, 1, -48)
    tabsFrame.Position = UDim2.fromOffset(0, 48)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Parent = main

    -- Pages container (right side)
    local pagesFrame = Instance.new("Frame")
    pagesFrame.Name = "Pages"
    pagesFrame.Size = UDim2.new(1, -120, 1, -48)
    pagesFrame.Position = UDim2.fromOffset(120, 48)
    pagesFrame.BackgroundTransparency = 1
    pagesFrame.Parent = main

    -- Animations for window entry
    TweenService:Create(
        main,
        TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.15}
    ):Play()

    TweenService:Create(
        scale,
        TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Scale = 1}
    ):Play()

    TweenService:Create(
        icon,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {ImageTransparency = 0}
    ):Play()

    TweenService:Create(
        title,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    ):Play()

    TweenService:Create(
        stroke,
        TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true),
        {Transparency = 0.3}
    ):Play()

    -- Drag system
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position

            -- small lift
            TweenService:Create(
                scale,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad),
                {Scale = 1.02}
            ):Play()

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    TweenService:Create(
                        scale,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                        {Scale = 1}
                    ):Play()
                end
            end)
        end
    end)

    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Tab system
    local function createTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 36)
        tabButton.BackgroundTransparency = 0.8
        tabButton.Text = name
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.TextColor3 = Color3.fromRGB(230, 230, 230)
        tabButton.Parent = tabsFrame

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = pagesFrame

        tabButton.MouseEnter:Connect(function()
            TweenService:Create(tabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.6}):Play()
        end)
        tabButton.MouseLeave:Connect(function()
            TweenService:Create(tabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.8}):Play()
        end)

        tabButton.MouseButton1Click:Connect(function()
            for _, p in pairs(pagesFrame:GetChildren()) do
                if p:IsA("Frame") then
                    p.Visible = false
                end
            end
            page.Visible = true
        end)

        return page
    end

    return {
        Main = main,
        CreateTab = createTab
    }
end

return VexUI