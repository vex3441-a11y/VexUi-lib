-- VexUI Definitive Build - Garantia total
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

local VexUI = {}
VexUI.__index = VexUI

-- Sistema de temas
VexUI.Theme = {
    Primary = Color3.fromRGB(20,20,25),
    Secondary = Color3.fromRGB(35,35,40),
    Accent = Color3.fromRGB(120,40,255),
    TextColor = Color3.fromRGB(235,235,235)
}

function VexUI:SetTheme(theme)
    for k,v in pairs(theme) do
        if self.Theme[k] then
            self.Theme[k] = v
        end
    end
end

function VexUI:CreateWindow(config)
    config = config or {}
    
    -- Cria o ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "VexUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = Player:WaitForChild("PlayerGui")

    -- Frame principal
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.fromOffset(520,360)
    main.Position = UDim2.fromScale(0.5,0.5)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = VexUI.Theme.Primary
    main.BackgroundTransparency = 0.15
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)
    
    -- TopBar
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1,0,0,48)
    top.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", top)
    title.Text = config.Title or "VexUI"
    title.Size = UDim2.new(1,0,1,0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = VexUI.Theme.TextColor
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    -- Tabs container
    local tabsFrame = Instance.new("Frame", main)
    tabsFrame.Size = UDim2.new(0,120,1,-48)
    tabsFrame.Position = UDim2.fromOffset(0,48)
    tabsFrame.BackgroundTransparency = 1

    -- Pages container
    local pagesFrame = Instance.new("Frame", main)
    pagesFrame.Size = UDim2.new(1,-120,1,-48)
    pagesFrame.Position = UDim2.fromOffset(120,48)
    pagesFrame.BackgroundTransparency = 1

    -- Dragging
    local dragging, dragInput, dragStart, startPos = false,nil,nil,nil
    local function update(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,
                                  startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
    top.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    dragging = false
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
        if input==dragInput and dragging then update(input) end
    end)

    -- Criação de Tab
    local function createTab(name)
        local tabButton = Instance.new("TextButton", tabsFrame)
        tabButton.Size = UDim2.new(1,0,0,36)
        tabButton.Text = name
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.TextColor3 = VexUI.Theme.TextColor
        tabButton.BackgroundColor3 = VexUI.Theme.Secondary
        tabButton.BackgroundTransparency = 0.8

        local page = Instance.new("Frame", pagesFrame)
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.Visible = false

        -- Layout
        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0,8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

        -- Garante que a primeira aba visível
        local visibleCount = 0
        for _,child in pairs(pagesFrame:GetChildren()) do
            if child:IsA("Frame") and child.Visible then visibleCount = visibleCount + 1 end
        end
        if visibleCount==0 then page.Visible=true end

        -- Funções de elementos
        function page:AddButton(txt,callback)
            local btn = Instance.new("TextButton", page)
            btn.Size = UDim2.new(0,180,0,36)
            btn.Text = txt
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.TextColor3 = VexUI.Theme.TextColor
            btn.BackgroundColor3 = VexUI.Theme.Secondary
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
            btn.MouseButton1Click:Connect(callback)
            return btn
        end

        function page:AddToggle(txt,callback)
            local toggle = Instance.new("TextButton", page)
            toggle.Size = UDim2.new(0,180,0,36)
            toggle.Text = txt.." [OFF]"
            toggle.Font = Enum.Font.GothamBold
            toggle.TextSize = 14
            toggle.TextColor3 = VexUI.Theme.TextColor
            toggle.BackgroundColor3 = VexUI.Theme.Secondary
            Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,10)
            local state=false
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = txt.." ["..(state and "ON" or "OFF").."]"
                if callback then callback(state) end
            end)
            return toggle
        end

        function page:AddSlider(txt,min,max,callback)
            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(0,200,0,36)
            frame.BackgroundColor3 = VexUI.Theme.Secondary
            Instance.new("UICorner", frame).CornerRadius=UDim.new(0,10)
            local bar = Instance.new("Frame", frame)
            bar.Size = UDim2.new(0,0,1,0)
            bar.BackgroundColor3 = VexUI.Theme.Accent
            local label = Instance.new("TextLabel", frame)
            label.Text = txt.." 0"
            label.Size = UDim2.new(1,0,1,0)
            label.BackgroundTransparency=1
            label.TextColor3=VexUI.Theme.TextColor
            label.TextScaled=true
            local dragging=false
            frame.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
            end)
            frame.InputEnded:Connect(function(input) dragging=false end)
            frame.InputChanged:Connect(function(input)
                if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
                    local pos = math.clamp(input.Position.X - frame.AbsolutePosition.X,0,frame.AbsoluteSize.X)
                    bar.Size=UDim2.new(0,pos,1,0)
                    local val=min+(pos/frame.AbsoluteSize.X)*(max-min)
                    label.Text=txt.." "..math.floor(val)
                    if callback then callback(val) end
                end
            end)
            return frame
        end

        tabButton.MouseButton1Click:Connect(function()
            for _,p in pairs(pagesFrame:GetChildren()) do
                if p:IsA("Frame") then p.Visible=false end
            end
            page.Visible=true
        end)

        return page
    end

    -- Profile
    local profile = Instance.new("Frame", main)
    profile.Size = UDim2.fromOffset(60,60)
    profile.Position = UDim2.fromScale(0,1)
    profile.AnchorPoint = Vector2.new(0,1)
    profile.BackgroundTransparency = 1
    local avatar = Instance.new("ImageLabel", profile)
    avatar.Size = UDim2.fromOffset(50,50)
    avatar.Position = UDim2.fromOffset(5,5)
    avatar.BackgroundTransparency=1
    avatar.Image = Players:GetUserThumbnailAsync(Player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
    Instance.new("UICorner", avatar).CornerRadius=UDim.new(0,25)

    -- Shortcut
    local shortcut = Instance.new("ImageButton", gui)
    shortcut.Size=UDim2.fromOffset(50,50)
    shortcut.Position=UDim2.new(0.5,-25,0,20)
    shortcut.BackgroundTransparency=0
    shortcut.BackgroundColor3=VexUI.Theme.Primary
    shortcut.Image="rbxassetid://71194548478826"
    local corner = Instance.new("UICorner", shortcut)
    corner.CornerRadius=UDim.new(0,12)
    local stroke = Instance.new("UIStroke", shortcut)
    stroke.Color = VexUI.Theme.Accent
    stroke.Thickness=2
    stroke.Transparency=0.2
    local draggingShortcut=false
    local startPos, dragStart
    shortcut.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            draggingShortcut=true
            dragStart=input.Position
            startPos=shortcut.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    draggingShortcut=false
                end
            end)
        end
    end)
    shortcut.InputChanged:Connect(function(input)
        if draggingShortcut and input.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=input.Position-dragStart
            shortcut.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
    shortcut.MouseButton1Click:Connect(function()
        main.Visible=not main.Visible
    end)

    return {
        Main=main,
        CreateTab=createTab,
        Theme=VexUI.Theme,
        SetTheme=function(self,theme) VexUI:SetTheme(theme) end
    }
end

-- Teste completo garantido
local win = VexUI:CreateWindow({Title="VexUI Teste Final"})
local tab = win.CreateTab("Principal")
tab:AddButton("Botão OK", function() print("Botão clicado") end)
tab:AddToggle("Toggle OK", function(v) print("Toggle:",v) end)
tab:AddSlider("Slider OK",0,100,function(v) print("Slider:",v) end)

return VexUI