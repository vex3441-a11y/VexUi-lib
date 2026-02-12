--// VexUI Library - Ultra Polished Test Build v1.3
--// Window + Tabs + Button/Toggle/Slider + Rounded Profile + Transparent Shortcut

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
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    main.BackgroundTransparency = 0.15
    main.Parent = gui

    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 18)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(120, 40, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.3

    local scale = Instance.new("UIScale", main)
    scale.Scale = 0.92

    -- TopBar
    local top = Instance.new("Frame")
    top.Name = "TopBar"
    top.Size = UDim2.new(1, 0, 0, 48)
    top.BackgroundTransparency = 1
    top.Parent = main

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = config.Title or "VexUI Library"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextColor3 = Color3.fromRGB(235, 235, 235)
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(14,0)
    title.Size = UDim2.new(1,-14,1,0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    -- Tabs container (left)
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "Tabs"
    tabsFrame.Size = UDim2.new(0, 120, 1, -48)
    tabsFrame.Position = UDim2.fromOffset(0, 48)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Parent = main

    -- Pages container (right)
    local pagesFrame = Instance.new("Frame")
    pagesFrame.Name = "Pages"
    pagesFrame.Size = UDim2.new(1, -120, 1, -48)
    pagesFrame.Position = UDim2.fromOffset(120, 48)
    pagesFrame.BackgroundTransparency = 1
    pagesFrame.Parent = main

    -- Drag system
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    local function update(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
    top.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Scale=1.02}):Play()
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    dragging=false
                    TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Scale=1}):Play()
                end
            end)
        end
    end)
    top.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            dragInput=input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input==dragInput and dragging then update(input) end
    end)

    -- Tab system
    local function createTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1,0,0,36)
        tabButton.BackgroundTransparency=0.8
        tabButton.Text=name
        tabButton.Font=Enum.Font.GothamBold
        tabButton.TextSize=14
        tabButton.TextColor3=Color3.fromRGB(230,230,230)
        tabButton.Parent=tabsFrame

        local page = Instance.new("Frame")
        page.Size=UDim2.new(1,0,1,0)
        page.BackgroundTransparency=1
        page.Visible=false
        page.Parent=pagesFrame

        tabButton.MouseEnter:Connect(function()
            TweenService:Create(tabButton,TweenInfo.new(0.15),{BackgroundTransparency=0.6}):Play()
        end)
        tabButton.MouseLeave:Connect(function()
            TweenService:Create(tabButton,TweenInfo.new(0.15),{BackgroundTransparency=0.8}):Play()
        end)
        tabButton.MouseButton1Click:Connect(function()
            for _,p in pairs(pagesFrame:GetChildren()) do
                if p:IsA("Frame") then p.Visible=false end
            end
            page.Visible=true
        end)

        -- Components container inside page
        page.Components = Instance.new("Folder")
        page.Components.Name="Components"
        page.Components.Parent=page

        -- Add Button
        function page:AddButton(txt,callback)
            local btn = Instance.new("TextButton")
            btn.Size=UDim2.new(0,180,0,36)
            btn.Position=UDim2.fromOffset(10,10+36*#page.Components:GetChildren())
            btn.BackgroundColor3 = Color3.fromRGB(35,35,40)
            btn.Text=txt
            btn.Font=Enum.Font.GothamBold
            btn.TextSize=14
            btn.TextColor3=Color3.fromRGB(255,255,255)
            btn.Parent=page
            local corner = Instance.new("UICorner", btn)
            corner.CornerRadius = UDim.new(0,10)
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(50,50,60)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(35,35,40)}):Play()
            end)
            btn.MouseButton1Click:Connect(callback)
            return btn
        end

        -- Add Toggle
        function page:AddToggle(txt,callback)
            local toggle = Instance.new("TextButton")
            toggle.Size=UDim2.new(0,180,0,36)
            toggle.Position=UDim2.fromOffset(10,10+36*#page.Components:GetChildren())
            toggle.BackgroundColor3 = Color3.fromRGB(35,35,40)
            toggle.Text=txt.." [OFF]"
            toggle.Font=Enum.Font.GothamBold
            toggle.TextSize=14
            toggle.TextColor3=Color3.fromRGB(255,255,255)
            toggle.Parent=page
            local corner = Instance.new("UICorner", toggle)
            corner.CornerRadius = UDim.new(0,10)
            local state=false
            toggle.MouseButton1Click:Connect(function()
                state=not state
                toggle.Text=txt.." ["..(state and "ON" or "OFF").."]"
                if callback then callback(state) end
            end)
            return toggle
        end

        -- Add Slider
        function page:AddSlider(txt,min,max,callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size=UDim2.new(0,200,0,36)
            sliderFrame.Position=UDim2.fromOffset(10,10+36*#page.Components:GetChildren())
            sliderFrame.BackgroundColor3 = Color3.fromRGB(35,35,40)
            sliderFrame.Parent=page
            local corner = Instance.new("UICorner", sliderFrame)
            corner.CornerRadius = UDim.new(0,10)
            local bar = Instance.new("Frame", sliderFrame)
            bar.Size=UDim2.new(0,0,1,0)
            bar.BackgroundColor3=Color3.fromRGB(120,40,255)
            local label = Instance.new("TextLabel", sliderFrame)
            label.Text=txt.." 0"
            label.Size=UDim2.new(1,0,1,0)
            label.TextColor3=Color3.fromRGB(255,255,255)
            label.BackgroundTransparency = 1
            label.TextScaled = true
            local dragging=false
            sliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
            end)
            sliderFrame.InputEnded:Connect(function(input)
                dragging=false
            end)
            sliderFrame.InputChanged:Connect(function(input)
                if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
                    local pos=math.clamp(input.Position.X-sliderFrame.AbsolutePosition.X,0,sliderFrame.AbsoluteSize.X)
                    bar.Size=UDim2.new(0,pos,1,0)
                    local value = min + (pos/sliderFrame.AbsoluteSize.X)*(max-min)
                    label.Text=txt.." "..math.floor(value)
                    if callback then callback(value) end
                end
            end)
            return sliderFrame
        end

        return page
    end

    -- Profile panel (avatar real, bottom-left, redondo)
    local profile = Instance.new("Frame", main)
    profile.Size=UDim2.fromOffset(160,60)
    profile.Position=UDim2.fromScale(0,1)
    profile.AnchorPoint=Vector2.new(0,1)
    profile.BackgroundTransparency = 1

    local avatar = Instance.new("ImageLabel", profile)
    avatar.Size = UDim2.fromOffset(50,50)
    avatar.Position = UDim2.fromOffset(5,5)
    avatar.BackgroundTransparency = 1
    avatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    local cornerAvatar = Instance.new("UICorner", avatar)
    cornerAvatar.CornerRadius = UDim.new(0,50)

    local labelP = Instance.new("TextLabel",profile)
    labelP.Text = Player.Name
    labelP.Position = UDim2.fromOffset(60,5)
    labelP.Size = UDim2.new(1,-60,1,0)
    labelP.BackgroundTransparency = 1
    labelP.TextColor3 = Color3.fromRGB(255,255,255)
    labelP.TextScaled = true
    labelP.TextXAlignment = Enum.TextXAlignment.Left

    -- Mobile Shortcut (top-center, transparente)
    local shortcut = Instance.new("ImageButton", gui)
    shortcut.Size=UDim2.fromOffset(50,50)
    shortcut.Position=UDim2.new(0.5, -25, 0, 20)
    shortcut.AnchorPoint=Vector2.new(0.5,0)
    shortcut.BackgroundTransparency=1
    shortcut.Image="rbxassetid://71194548478826"
    local cornerS = Instance.new("UICorner", shortcut)
    cornerS.CornerRadius = UDim.new(0,12)
    local draggingShortcut=false
    local startPos
    local dragStart
    shortcut.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
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
        if draggingShortcut and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart
            shortcut.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
    shortcut.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)

    return {
        Main=main,
        CreateTab=createTab
    }
end

return VexUI