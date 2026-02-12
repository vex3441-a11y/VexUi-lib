-- Window.lua - VexUI
-- Responsável por criar e gerenciar janelas dentro da Library

local TweenService = game:GetService("TweenService")

local Window = {}
Window.__index = Window

-- Cria uma nova janela
function Window.new(config)
    config = config or {}

    local self = setmetatable({}, Window)

    -- Main Frame
    self.Main = Instance.new("Frame")
    self.Main.Name = config.Name or "VexWindow"
    self.Main.Size = UDim2.fromOffset(config.Width or 520, config.Height or 360)
    self.Main.Position = UDim2.fromScale(0.5, 0.5)
    self.Main.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    self.Main.BackgroundTransparency = 0.15
    self.Main.Parent = config.Parent or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Corner e Stroke
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = self.Main

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 40, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = self.Main

    -- UIScale pra animações
    local scale = Instance.new("UIScale")
    scale.Scale = 0.92
    scale.Parent = self.Main

    -- TopBar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 48)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.Parent = self.Main

    -- Icon
    self.Icon = Instance.new("ImageLabel")
    self.Icon.Image = config.Icon or "rbxassetid://71194548478826"
    self.Icon.Size = UDim2.fromOffset(28, 28)
    self.Icon.Position = UDim2.fromOffset(14, 10)
    self.Icon.BackgroundTransparency = 1
    self.Icon.ImageTransparency = 0
    self.Icon.Parent = self.TopBar

    -- Title
    self.Title = Instance.new("TextLabel")
    self.Title.Text = config.Title or "VexUI Window"
    self.Title.Font = Enum.Font.GothamBold
    self.Title.TextSize = 16
    self.Title.TextColor3 = Color3.fromRGB(235, 235, 235)
    self.Title.BackgroundTransparency = 1
    self.Title.Position = UDim2.fromOffset(52, 0)
    self.Title.Size = UDim2.new(1, -52, 1, 0)
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.TopBar

    -- Tabs Container
    self.Tabs = Instance.new("Frame")
    self.Tabs.Name = "Tabs"
    self.Tabs.Size = UDim2.new(0, 120, 1, -48)
    self.Tabs.Position = UDim2.fromOffset(0, 48)
    self.Tabs.BackgroundTransparency = 1
    self.Tabs.Parent = self.Main

    -- Pages Container
    self.Pages = Instance.new("Frame")
    self.Pages.Name = "Pages"
    self.Pages.Size = UDim2.new(1, -120, 1, -48)
    self.Pages.Position = UDim2.fromOffset(120, 48)
    self.Pages.BackgroundTransparency = 1
    self.Pages.Parent = self.Main

    -- Entrada Animada (pop + fade)
    TweenService:Create(
        scale,
        TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Scale = 1}
    ):Play()

    TweenService:Create(
        self.Main,
        TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.15}
    ):Play()

    return self
end

-- Função pra adicionar Tabs
function Window:AddTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 36)
    tabButton.Text = name
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 14
    tabButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    tabButton.BackgroundTransparency = 0.8
    tabButton.Parent = self.Tabs

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = self.Pages

    tabButton.MouseButton1Click:Connect(function()
        -- Esconde todas as páginas
        for _, p in pairs(self.Pages:GetChildren()) do
            if p:IsA("Frame") then
                p.Visible = false
            end
        end
        page.Visible = true
    end)

    return page
end

return Window