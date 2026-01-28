-- [[ PROJECT VISION: ELITE UI LIBRARY ]] --
-- Um design inovador focado em Glassmorphism e Micro-interações.

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local UI = { Tabs = {}, Elements = {} }
local LocalPlayer = Players.LocalPlayer

-- Paleta de Cores "Deep Sea"
local Theme = {
    Accent = Color3.fromRGB(0, 150, 255),
    Secondary = Color3.fromRGB(0, 40, 80),
    Glass = Color3.fromRGB(8, 8, 10),
    Stroke = Color3.fromRGB(50, 50, 60),
    Text = Color3.fromRGB(255, 255, 255),
    ElementBG = Color3.fromRGB(15, 15, 20)
}

local function Create(class, properties)
    local inst = Instance.new(class)
    for i, v in pairs(properties) do inst[i] = v end
    return inst
end

local function Tween(obj, info, goal)
    local t = TweenService:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), goal)
    t:Play()
    return t
end

-- ScreenGui
local SG = Create("ScreenGui", { Name = "ProjectVision_Beyond", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })

-- Main Container
local Main = Create("Frame", {
    Name = "Main", Parent = SG,
    BackgroundColor3 = Theme.Glass, BackgroundTransparency = 0.1,
    Position = UDim2.new(0.5, -280, 0.5, -180), Size = UDim2.new(0, 560, 0, 420),
    ClipsDescendants = false
})
Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Main })

-- Gradiente na borda Animada
local MainStroke = Create("UIStroke", { Thickness = 2.5, Transparency = 0.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Main })
local StrokeGradient = Create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(0.5, Theme.Secondary),
        ColorSequenceKeypoint.new(1, Theme.Accent)
    }),
    Parent = MainStroke
})
RunService.RenderStepped:Connect(function() StrokeGradient.Rotation = StrokeGradient.Rotation + 1.5 end)

-- Barra de Status Superior
local TopStatusBar = Create("Frame", {
    Name = "StatusBar", Parent = Main,
    BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.6,
    Position = UDim2.new(0, 15, 0, 12), Size = UDim2.new(1, -30, 0, 40)
})
Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TopStatusBar })
Create("UIStroke", { Thickness = 1, Color = Theme.Stroke, Transparency = 0.5, Parent = TopStatusBar })

local UserIcon = Create("ImageLabel", { Parent = TopStatusBar, Position = UDim2.new(0, 8, 0.5, -14), Size = UDim2.new(0, 28, 0, 28), BackgroundColor3 = Theme.Secondary, Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) })
Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = UserIcon })
Create("UIStroke", { Thickness = 1.5, Color = Theme.Accent, Parent = UserIcon })

local UserName = Create("TextLabel", { Parent = TopStatusBar, BackgroundTransparency = 1, Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(0, 100, 1, 0), Font = Enum.Font.GothamBold, Text = LocalPlayer.Name:upper(), TextColor3 = Theme.Text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })
local FPSLabel = Create("TextLabel", { Parent = TopStatusBar, BackgroundTransparency = 1, Position = UDim2.new(1, -70, 0, 0), Size = UDim2.new(0, 60, 1, 0), Font = Enum.Font.GothamBold, Text = "60 FPS", TextColor3 = Theme.Text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right })

local lastUpdate, frames = tick(), 0
RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - lastUpdate >= 1 then FPSLabel.Text = frames .. " FPS" frames, lastUpdate = 0, tick() end
end)

-- Barra de Navegação Horizontal (Pílula Flutuante)
local NavBackground = Create("Frame", { Name = "NavBG", Parent = Main, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.4, Position = UDim2.new(0.5, -220, 0, -32), Size = UDim2.new(0, 440, 0, 42) })
Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = NavBackground })
Create("UIStroke", { Thickness = 1.2, Color = Theme.Stroke, Parent = NavBackground })

local TabContainer = Create("Frame", { Name = "Tabs", Parent = NavBackground, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) })
local TabListLayout = Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 25), Parent = TabContainer })

-- Container de Páginas
local PagesContainer = Create("Frame", { Name = "Pages", Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 20, 0, 70), Size = UDim2.new(1, -40, 1, -90) })

-- Footer Logo
local Logo = Create("TextLabel", { Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(1, -160, 1, -30), Size = UDim2.new(0, 150, 0, 25), Font = Enum.Font.GothamBold, Text = "PROJECT VISION", TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right, TextTransparency = 0.7 })

-- Dragging (Apenas por Bordas e Topo)
local function Drag(frame)
    local dragToggle, dragStart, startPos = nil, nil, nil
    frame.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = i.Position
            local relativeX = mousePos.X - frame.AbsolutePosition.X
            local relativeY = mousePos.Y - frame.AbsolutePosition.Y
            
            -- Detecta se o clique foi na área das páginas (onde ficam os botões/sliders)
            -- PagesContainer está em (20, 70) com margem de 20 nas bordas.
            local inPageArea = (relativeX > 20 and relativeX < frame.AbsoluteSize.X - 20) and 
                               (relativeY > 70 and relativeY < frame.AbsoluteSize.Y - 20)

            if not inPageArea then
                dragToggle, dragStart, startPos = true, i.Position, frame.Position 
            end
        end 
    end)

    UserInputService.InputChanged:Connect(function(i) 
        if dragToggle and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end 
    end)

    UserInputService.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragToggle = false 
        end 
    end)
end
Drag(Main)

function UI:CreateTab(name)
    local TabBtn = Create("TextButton", { Parent = TabContainer, BackgroundTransparency = 1, Size = UDim2.new(0, 65, 0, 25), Font = Enum.Font.GothamBold, Text = name:upper(), TextColor3 = Color3.fromRGB(150, 150, 150), TextSize = 11, AutoButtonColor = false })
    local Indicator = Create("Frame", { Parent = TabBtn, BackgroundColor3 = Theme.Accent, Position = UDim2.new(0.5, -10, 1, 2), Size = UDim2.new(0, 20, 0, 2), BackgroundTransparency = 1 })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Indicator })
    local Page = Create("ScrollingFrame", { Parent = PagesContainer, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0) })
    Create("UIListLayout", { Padding = UDim.new(0, 10), Parent = Page })

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(UI.Tabs) do
            t.Page.Visible = false
            Tween(t.Btn, 0.4, { TextColor3 = Color3.fromRGB(150, 150, 150) })
            Tween(t.Ind, 0.4, { BackgroundTransparency = 1, Size = UDim2.new(0, 20, 0, 2) })
        end
        Page.Visible = true
        Tween(TabBtn, 0.4, { TextColor3 = Theme.Text })
        Tween(Indicator, 0.4, { BackgroundTransparency = 0, Size = UDim2.new(0, 30, 0, 2) })
    end)

    table.insert(UI.Tabs, { Btn = TabBtn, Page = Page, Ind = Indicator })
    if #UI.Tabs == 1 then Page.Visible = true Indicator.BackgroundTransparency = 0 TabBtn.TextColor3 = Theme.Text end

    local Elements = {}

    function Elements:Button(txt, cb)
        local B = Create("TextButton", { Parent = Page, BackgroundColor3 = Theme.ElementBG, Size = UDim2.new(1, 0, 0, 45), Font = Enum.Font.GothamMedium, Text = "  " .. txt, TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = B })
        local S = Create("UIStroke", { Thickness = 1.2, Color = Theme.Stroke, Parent = B })
        B.MouseEnter:Connect(function() Tween(B, 0.3, { BackgroundColor3 = Color3.fromRGB(22, 22, 28) }) Tween(S, 0.3, { Color = Theme.Accent }) end)
        B.MouseLeave:Connect(function() Tween(B, 0.3, { BackgroundColor3 = Theme.ElementBG }) Tween(S, 0.3, { Color = Theme.Stroke }) end)
        B.MouseButton1Click:Connect(cb)
    end

    function Elements:Toggle(txt, def, cb)
        local T = Create("Frame", { Parent = Page, BackgroundColor3 = Theme.ElementBG, Size = UDim2.new(1, 0, 0, 45) })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = T })
        local Label = Create("TextLabel", { Parent = T, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -100, 1, 0), Font = Enum.Font.Gotham, Text = txt, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
        local SwitchBG = Create("Frame", { Parent = T, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = def and Theme.Accent or Color3.fromRGB(30, 30, 35), Position = UDim2.new(1, -15, 0.5, 0), Size = UDim2.new(0, 40, 0, 20) })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SwitchBG })
        local Dot = Create("Frame", { Parent = SwitchBG, BackgroundColor3 = Theme.Text, Position = def and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2), Size = UDim2.new(0, 16, 0, 16) })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Dot })
        local state = def
        T.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then state = not state Tween(SwitchBG, 0.3, { BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(30, 30, 35) }) Tween(Dot, 0.4, { Position = state and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2) }) cb(state) end end)
    end

    function Elements:Slider(txt, min, max, def, cb)
        local SldFrame = Create("Frame", { Parent = Page, BackgroundColor3 = Theme.ElementBG, Size = UDim2.new(1, 0, 0, 50) })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = SldFrame })
        local Label = Create("TextLabel", { Parent = SldFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(1, -20, 0, 15), Font = Enum.Font.Gotham, Text = txt .. ": " .. tostring(def), TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })
        local Bar = Create("Frame", { Parent = SldFrame, BackgroundColor3 = Color3.fromRGB(40, 40, 40), Position = UDim2.new(0, 10, 0, 32), Size = UDim2.new(1, -25, 0, 4) })
        local Fill = Create("Frame", { Parent = Bar, BackgroundColor3 = Theme.Accent, Size = UDim2.new((def - min) / (max - min), 0, 1, 0) })
        local function Update()
            local percent = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            Label.Text = txt .. ": " .. tostring(value)
            cb(value)
        end
        local sliding = false
        SldFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true Update() end end)
        UserInputService.InputChanged:Connect(function(i) if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then Update() end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
    end

    function Elements:Keybind(txt, def, cb)
        local KFrame = Create("Frame", { Parent = Page, BackgroundColor3 = Theme.ElementBG, Size = UDim2.new(1, 0, 0, 45) })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = KFrame })
        local Label = Create("TextLabel", { Parent = KFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -100, 1, 0), Font = Enum.Font.Gotham, Text = txt, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
        local KeyLabel = Create("TextLabel", { Parent = KFrame, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(30, 30, 35), Position = UDim2.new(1, -15, 0.5, 0), Size = UDim2.new(0, 85, 0, 25), Font = Enum.Font.GothamBold, Text = def.Name, TextColor3 = Theme.Accent, TextSize = 12 })
        KFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then KeyLabel.Text = "..." local conn conn = UserInputService.InputBegan:Connect(function(i2) if i2.UserInputType == Enum.UserInputType.Keyboard then KeyLabel.Text = i2.KeyCode.Name cb(i2.KeyCode) conn:Disconnect() end end) end end)
    end

    function Elements:Label(txt)
        local L = Create("TextLabel", { Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Font = Enum.Font.GothamMedium, Text = txt, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })
        return L
    end

    function Elements:TextBox(txt, placeholder, cb)
        local TFrame = Create("Frame", { Parent = Page, BackgroundColor3 = Theme.ElementBG, Size = UDim2.new(1, 0, 0, 45) })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TFrame })
        local Label = Create("TextLabel", { Parent = TFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(0, 100, 1, 0), Font = Enum.Font.Gotham, Text = txt, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
        local Box = Create("TextBox", { Parent = TFrame, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(30, 30, 35), Position = UDim2.new(1, -15, 0.5, 0), Size = UDim2.new(0, 150, 0, 28), Font = Enum.Font.Gotham, PlaceholderText = placeholder, Text = "", TextColor3 = Theme.Text, TextSize = 12, ClearTextOnFocus = false })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Box })
        Box.FocusLost:Connect(function() cb(Box.Text) end)
    end

    function Elements:ColorPicker(txt, def, cb)
        local CPFrame = Create("Frame", { Parent = Page, BackgroundColor3 = Theme.ElementBG, Size = UDim2.new(1, 0, 0, 45) })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = CPFrame })
        local Label = Create("TextLabel", { Parent = CPFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -100, 1, 0), Font = Enum.Font.Gotham, Text = txt, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
        
        local ColorPreview = Create("Frame", { Name = "Preview", Parent = CPFrame, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = def, Position = UDim2.new(1, -15, 0.5, 0), Size = UDim2.new(0, 35, 0, 20) })
        Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = ColorPreview })
        Create("UIStroke", { Thickness = 1.2, Color = Theme.Stroke, Parent = ColorPreview })

        local colors = {Color3.fromRGB(0, 150, 255), Color3.fromRGB(255, 80, 80), Color3.fromRGB(80, 255, 80), Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0,0,0)}
        local currIdx = 1

        CPFrame.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                currIdx = currIdx + 1
                if currIdx > #colors then currIdx = 1 end
                local newCol = colors[currIdx]
                ColorPreview.BackgroundColor3 = newCol
                cb(newCol)
            end
        end)
    end

    -- Sistema de Proteção Interna (Anti-Skid)
    local function CheckIntegrity()
        if Logo.Text ~= "PROJECT VISION" or Logo.TextTransparency > 0.8 then
            Main:Destroy()
            SG:Destroy()
            error("INTEGRITY ERROR: Don't rename Project Vision GUI!")
        end
    end
    
    -- Verifica a cada 5 segundos se alguém tentou mudar os créditos via script externo
    task.spawn(function()
        while task.wait(5) do
            pcall(CheckIntegrity)
        end
    end)

    return Elements
end


function UI:CreateLogTab()
    local LogTab = self:CreateTab("Logs")
    local LogPage = UI.Tabs[#UI.Tabs].Page
    
    function UI:Log(msg, type)
        local color = Theme.Text
        if type == "warn" then color = Color3.fromRGB(255, 200, 0)
        elseif type == "error" then color = Color3.fromRGB(255, 80, 80)
        elseif type == "success" then color = Color3.fromRGB(80, 255, 80) end
        
        local L = Create("TextLabel", {
            Parent = LogPage,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Font = Enum.Font.Code,
            Text = "[" .. os.date("%X") .. "] " .. msg,
            TextColor3 = color,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        print("[VISION] " .. msg)
    end
end

UI.Main = Main
UI.SG = SG
return UI

