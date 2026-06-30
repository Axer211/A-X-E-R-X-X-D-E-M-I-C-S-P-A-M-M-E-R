-- [[ 👑 AXER BOSS x WR4ITH - FULL FEATURES EDITION V3 ]]
-- [[ Discord: Mickeyyy009 | Roblox: erennn0779 ]]
-- [[ Credits: Axer, Xdemic ]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TextChatService = game:GetService("TextChatService")
local Lighting = game:GetService("Lighting")
local lp = Players.LocalPlayer

local ParentUI
local success, err = pcall(function() return game:GetService("CoreGui") end)
if success and err then ParentUI = err else ParentUI = lp:WaitForChild("PlayerGui") end

-- [[ VARIABLES ]]
local attackEnabled = false
local antiAfkEnabled = false
local speedEnabled = false
local jumpEnabled = false
local noclipEnabled = false
local nositEnabled = false
local antiCopyEnabled = false
local antiFlingEnabled = false
local delayTime = 2
local guiOpen = false
local spamMode = "default"
local customMessages = {}
local lastPosition = nil
local flingDetected = false
local antiFlingConnection = nil
local minimized = false

-- [[ SOUND ENGINE ]]
local function playSfx(id, vol)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Volume = vol or 0.5
    s.Parent = game:GetService("SoundService")
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local CLICK_SFX  = 6895079853
local TOGGLE_SFX = 4590657391
local OPEN_SFX   = 3719010497
local CLOSE_SFX  = 3714960718
local LOAD_SFX   = 1837359575
local START_SFX  = 4612740061

-- [[ SLANGS ]]
local slangs = {
    "TMX MEH BLAZE", "TMX MEH FIRE 🔥", "FYTER BNEGA? 🤣", "TMX MEH GOAT", "TMX MEH SALT",
    "TMX MEH ROD", "TMX MEH UNIVERSE", "TMX MEH SOFA", "TMX MEH KEYBOARD", "TMX MEH SNIPER",
    "LEAVE KR DE", "TMX MEH MONITOR", "TMX MEH TABLE", "TMX MEH GALAXLY", "TMX MEH MUSHROOM",
    "TMX MEH STONE KE", "TMX MEH BOT", "TMX MEH CYLINDER", "TMX MEH KING", "TMX MEH VOID",
    "TMX MEH REAPER", "TMX MEH GOD", "TMX MEH MASTER", "TMX MEH NOVA", "TMX MEH BEAST",
    "TMX MEH LEGEND", "TMX MEH GHOST", "TMX MEH NINJA", "TMX MEH STAR", "TMX MEH MOON",
    "TMX MEH NEON", "TMX MEH OMEGA", "TMX MEH STICK", "TMX MEH PAPER", "TMX MEH STYLE",
    "TMX MEH ALPHA", "TMX MEH AK47 🔥", "TMX MEH MOUNTAIN 💀", "LEAVE MARDE 🤣",
    "LALLU FIGHTER", "PIL GYA ITNI JALDI? 🤣", "TMX MEH DINO 😈", "TMKX MAI 🚫",
    "H8R KI XUDAI START!", "TMKX MAI FUNNY", "TMKX MAI SWORD", "TMKX MAI CASH",
    "TMKX MAI BAATE", "TMKX MAI PYTHON", "TMKX MAI GRAPHS", "TMKX MAI GALAXY",
    "TMKX MAI SOFTWARE", "TMKX MAI HARDWARE", "TMKX MAI EXCEL", "TMKX MAI MILKY-WAY",
    "TMKX MAI FORMULA", "TMKX MAI PIANO", "TMKX MAI INSTRUMENTS", "TMKX MAI EARTHQUAKE",
    "TMKX MAI ACID RAIN", "TMKX MAI POLLUTION", "TMKX MAI DELTA", "TMKX MAI STORM",
    "TMKX MAI BONES", "TMKX MAI PEACE", "TMKX MAI ANIME", "TMKX MAI HEAT", "TMKX MAI ICE",
    "TMKX MAI SCRIPT", "TMKX MAI MECHANICS", "TMKX MAI NEURONS", "TMKX MAI MUSIC",
    "USE AXER SPAMMER V3 (WR4ITH) 👑"
}

-- [[ ANTI-TAG SPAM SYSTEM ]]
local PATTERN_CYCLE = {
    "`", "/=-=", "Z_", "Q_", "@", "#", "*", "%", "@", "/-", "", "P_",
}
local currentPatternIndex = 1
local function formatSpamMessage(msg)
    local pattern = PATTERN_CYCLE[currentPatternIndex]
    currentPatternIndex = (currentPatternIndex % #PATTERN_CYCLE) + 1
    local pStr = ""
    while (#pStr + #pattern) <= (197 - #msg) do pStr = pStr .. pattern end
    return pStr .. " " .. msg
end

local function SendChatMessage(msg)
    local formatted = formatSpamMessage(msg)
    local tcs = TextChatService
    if tcs.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
        if channel then channel:SendAsync(formatted) end
    else
        local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
            chatEvent.SayMessageRequest:FireServer(formatted, "All")
        end
    end
end

-- [[ ANTI-LAG ]]
local function applyAntiLag()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 1
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
    end
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        end
    end
end
applyAntiLag()

-- [[ ANTI-COPY ]]
local function setupAntiCopy()
    spawn(function()
        while wait(2) do
            if antiCopyEnabled and game.PlaceId == 4924922222 then
                pcall(function()
                    local character = lp.Character
                    if character then
                        for _, v in pairs(character:GetChildren()) do
                            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then
                                local clone = v:Clone()
                                v:Destroy()
                                clone.Parent = character
                            end
                        end
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid:ApplyDescription(lp.CharacterAppearance)
                        end
                    end
                end)
            end
        end
    end)
end

-- [[ ANTI-FLING ]]
local function setupAntiFling()
    if antiFlingConnection then antiFlingConnection:Disconnect() end
    antiFlingConnection = RunService.Heartbeat:Connect(function()
        if antiFlingEnabled and lp.Character then
            local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = lp.Character:FindFirstChild("Humanoid")
            if hrp and humanoid and humanoid.Health > 0 then
                local currentPos = hrp.Position
                if lastPosition then
                    local velocity = (currentPos - lastPosition).Magnitude
                    if velocity > 200 and not flingDetected then
                        flingDetected = true
                        hrp.CFrame = CFrame.new(lastPosition)
                        humanoid.PlatformStand = false
                        if hrp:FindFirstChild("BodyVelocity") then
                            hrp.BodyVelocity:Destroy()
                        end
                        pcall(function()
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "⚠️ ANTI-FLING",
                                Text = "Fling detected! Teleported to safe position.",
                                Duration = 2
                            })
                        end)
                        wait(0.5)
                        flingDetected = false
                    elseif velocity < 50 then
                        flingDetected = false
                        if humanoid.Sit == false and humanoid.FloorMaterial ~= Enum.Material.Air then
                            lastPosition = currentPos
                        end
                    end
                else
                    lastPosition = currentPos
                end
            end
        end
    end)
end

-- [[ DRAGGABLE ]]
local function makeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = object.Position
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ============================================
-- [[ SCREEN GUI ]]
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AXER_HUB_V3"
ScreenGui.Parent = ParentUI
ScreenGui.ResetOnSpawn = false

-- ============================================
-- [[ LOADING SCREEN (shortened) ]]
-- ============================================
local LoadingFrame = Instance.new("Frame", ScreenGui)
LoadingFrame.Size = UDim2.new(0, 300, 0, 100)
LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(200, 230, 255)
LoadingFrame.BackgroundTransparency = 1
Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 12)
local LoadingStroke = Instance.new("UIStroke", LoadingFrame)
LoadingStroke.Thickness = 2; LoadingStroke.Color = Color3.fromRGB(135, 206, 235)

local LoadingTitle = Instance.new("TextLabel", LoadingFrame)
LoadingTitle.Text = "❄️ AXER BOSS SPAMMER V3 ❄️"
LoadingTitle.Size = UDim2.new(1, 0, 0, 30); LoadingTitle.Position = UDim2.new(0, 0, 0.08, 0)
LoadingTitle.TextColor3 = Color3.new(0,0,0); LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.TextSize = 16; LoadingTitle.BackgroundTransparency = 1
LoadingTitle.TextTransparency = 1

local WelcomeLabel = Instance.new("TextLabel", LoadingFrame)
WelcomeLabel.Text = "Welcome, " .. lp.Name
WelcomeLabel.Size = UDim2.new(1, 0, 0, 20); WelcomeLabel.Position = UDim2.new(0, 0, 0.36, 0)
WelcomeLabel.TextColor3 = Color3.fromRGB(30,30,30); WelcomeLabel.Font = Enum.Font.GothamMedium
WelcomeLabel.TextSize = 12; WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.TextTransparency = 1

local ProgressBarBack = Instance.new("Frame", LoadingFrame)
ProgressBarBack.Size = UDim2.new(0.8, 0, 0, 6); ProgressBarBack.Position = UDim2.new(0.1, 0, 0.62, 0)
ProgressBarBack.BackgroundColor3 = Color3.fromRGB(180, 210, 230)
ProgressBarBack.BackgroundTransparency = 1
Instance.new("UICorner", ProgressBarBack)

local ProgressBarFill = Instance.new("Frame", ProgressBarBack)
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = Color3.fromRGB(135, 206, 235)
Instance.new("UICorner", ProgressBarFill)

local LoadingPercent = Instance.new("TextLabel", LoadingFrame)
LoadingPercent.Text = "0%"; LoadingPercent.Size = UDim2.new(1, 0, 0, 18)
LoadingPercent.Position = UDim2.new(0, 0, 0.77, 0); LoadingPercent.TextColor3 = Color3.new(0,0,0)
LoadingPercent.Font = Enum.Font.GothamBold; LoadingPercent.TextSize = 12
LoadingPercent.BackgroundTransparency = 1; LoadingPercent.TextTransparency = 1

TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {BackgroundTransparency = 0}):Play()
TweenService:Create(LoadingTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {TextTransparency = 0}):Play()
TweenService:Create(WelcomeLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {TextTransparency = 0}):Play()
TweenService:Create(ProgressBarBack, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {BackgroundTransparency = 0}):Play()
TweenService:Create(LoadingPercent, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {TextTransparency = 0}):Play()

-- ============================================
-- [[ MAIN FRAME ]]
-- ============================================
local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0, 380, 0, 330)
frame.Position = UDim2.new(0.5, -190, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(200, 230, 255)
frame.BackgroundTransparency = 0.15
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
local mainStroke = Instance.new("UIStroke", frame)
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(135, 206, 235)

-- [[ OPEN / CLOSE & MINIMIZE ]]
local animating = false
local function OpenGUI()
    if animating then return end
    animating = true
    playSfx(OPEN_SFX, 0.7)
    frame.Visible = true
    frame.Size = UDim2.new(0, 380, 0, 0)
    frame.Position = UDim2.new(0.5, -190, 0.5, 0)
    frame.BackgroundTransparency = 0.8
    TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 330),
        Position = UDim2.new(0.5, -190, 0.5, -165),
        BackgroundTransparency = 0.15
    }):Play()
    task.wait(0.45)
    animating = false
    guiOpen = true
end

local function CloseGUI()
    if animating then return end
    animating = true
    playSfx(CLOSE_SFX, 0.6)
    TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 380, 0, 0),
        Position = UDim2.new(0.5, -190, 0.5, 0),
        BackgroundTransparency = 0.8
    }):Play()
    task.wait(0.35)
    frame.Visible = false
    animating = false
    guiOpen = false
    minimized = false
end

local function ToggleMinimize()
    if minimized then
        minimized = false
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 380, 0, 330),
            Position = UDim2.new(0.5, -190, 0.5, -165)
        }):Play()
        TabBar.Visible = true
        Pages.Visible = true
        minBtn.Text = "🗕"
    else
        minimized = true
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 380, 0, 38),
            Position = UDim2.new(0.5, -190, 0.5, -19)
        }):Play()
        TabBar.Visible = false
        Pages.Visible = false
        minBtn.Text = "🗖"
    end
end

-- [[ TITLE BAR ]]
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 32)
title.Text = "❄️ AXER SPAMMER V3 ❄️"
title.TextColor3 = Color3.new(0,0,0)
title.BackgroundColor3 = Color3.fromRGB(180, 210, 230)
title.BackgroundTransparency = 0.3
title.Font = Enum.Font.GothamBold
title.TextSize = 13
Instance.new("UICorner", title)
makeDraggable(title, frame)

-- Minimize button
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -34, 0.5, -14)
minBtn.Text = "🗕"
minBtn.TextColor3 = Color3.new(0,0,0)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 220, 240)
minBtn.BackgroundTransparency = 0.5
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
minBtn.MouseButton1Click:Connect(ToggleMinimize)

-- [[ TAB BAR ]]
local TabBar = Instance.new("Frame", frame)
TabBar.Size = UDim2.new(1, 0, 0, 26)
TabBar.Position = UDim2.new(0, 0, 0, 32)
TabBar.BackgroundColor3 = Color3.fromRGB(190, 215, 235)
TabBar.BackgroundTransparency = 0.2
TabBar.BorderSizePixel = 0

local tabIndicator = Instance.new("Frame", TabBar)
tabIndicator.Size = UDim2.new(0.2, 0, 0, 2)
tabIndicator.Position = UDim2.new(0, 0, 1, -2)
tabIndicator.BackgroundColor3 = Color3.fromRGB(135, 206, 235)
tabIndicator.BorderSizePixel = 0
Instance.new("UICorner", tabIndicator)

local function CreateTab(name, xPos, w)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(w, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.Text = name; btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(40,40,40); btn.TextSize = 10; btn.BackgroundTransparency = 1
    return btn
end

local AttackTabBtn = CreateTab("ATTACK",  0,    0.25)
local SetTabBtn    = CreateTab("SETTINGS",0.25, 0.25)
local ThemeTabBtn  = CreateTab("THEMES",  0.50, 0.25)
local InfoTabBtn   = CreateTab("INFO",    0.75, 0.25)
AttackTabBtn.TextColor3 = Color3.new(0,0,0)

-- [[ PAGES ]]
local Pages = Instance.new("Frame", frame)
Pages.Size = UDim2.new(1, 0, 1, 0)
Pages.Position = UDim2.new(0, 0, 0, 58) -- 32 title + 26 tab
Pages.BackgroundTransparency = 1
Pages.ClipsDescendants = true

local function CreatePage()
    local p = Instance.new("Frame", Pages) -- Use Frame instead of CanvasGroup for simpler handling
    p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false
    return p
end

local AttackPage  = CreatePage(); AttackPage.Visible = true
local SettingPage = CreatePage()
local ThemePage   = CreatePage()
local InfoPage    = CreatePage()
local currentPage = AttackPage

local tabBtns = {AttackTabBtn, SetTabBtn, ThemeTabBtn, InfoTabBtn}
local tabXPos  = {0, 0.25, 0.50, 0.75}

local function SwitchPage(newPage, btn, xPos)
    if newPage == currentPage then return end
    playSfx(CLICK_SFX, 0.4)
    TweenService:Create(tabIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(xPos, 0, 1, -2)
    }):Play()
    for _, b in ipairs(tabBtns) do b.TextColor3 = Color3.fromRGB(40,40,40) end
    btn.TextColor3 = Color3.new(0,0,0)
    local old = currentPage; currentPage = newPage
    newPage.Position = UDim2.new(1, 0, 0, 0); newPage.Visible = true
    TweenService:Create(old, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(-1,0,0,0)}):Play()
    TweenService:Create(newPage, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()
    task.wait(0.35); old.Visible = false; old.Position = UDim2.new(0,0,0,0)
end

AttackTabBtn.MouseButton1Click:Connect(function() SwitchPage(AttackPage,  AttackTabBtn, 0)    end)
SetTabBtn.MouseButton1Click:Connect(function()    SwitchPage(SettingPage, SetTabBtn,    0.25) end)
ThemeTabBtn.MouseButton1Click:Connect(function()  SwitchPage(ThemePage,   ThemeTabBtn,  0.50) end)
InfoTabBtn.MouseButton1Click:Connect(function()   SwitchPage(InfoPage,    InfoTabBtn,   0.75) end)

-- ============================================
-- [[ HELPER FUNCTIONS (adjusted sizes) ]]
-- ============================================
local function MakeBox(parent, placeholder, yPos)
    local b = Instance.new("TextBox", parent)
    b.Size = UDim2.new(0.9, 0, 0, 24)
    b.Position = UDim2.new(0.05, 0, 0, yPos)
    b.PlaceholderText = placeholder
    b.BackgroundColor3 = Color3.fromRGB(220, 240, 255)
    b.TextColor3 = Color3.new(0,0,0)
    b.Font = Enum.Font.GothamMedium; b.TextSize = 11
    Instance.new("UICorner", b)
    return b
end

local function MakeBtn(parent, text, yPos, bgColor, h)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.9, 0, 0, h or 26)
    b.Position = UDim2.new(0.05, 0, 0, yPos)
    b.Text = text; b.BackgroundColor3 = bgColor
    b.TextColor3 = Color3.new(0,0,0); b.Font = Enum.Font.GothamBold; b.TextSize = 11
    Instance.new("UICorner", b)
    b.MouseButton1Down:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0.87, 0, 0, (h or 26) - 3)
        }):Play()
        playSfx(CLICK_SFX, 0.35)
    end)
    b.MouseButton1Up:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.9, 0, 0, h or 26)
        }):Play()
    end)
    return b
end

local function MakeToggle(parent, text, yPos, callback, defaultValue)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Text = text; lbl.Size = UDim2.new(0.6, 0, 0, 22)
    lbl.Position = UDim2.new(0.05, 0, 0, yPos); lbl.TextColor3 = Color3.new(0,0,0)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10; lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local tog = Instance.new("TextButton", parent)
    tog.Text = "OFF"; tog.Size = UDim2.new(0, 40, 0, 18)
    tog.Position = UDim2.new(1, -48, 0, yPos + 2)
    tog.BackgroundColor3 = Color3.fromRGB(180, 0, 0); tog.TextColor3 = Color3.new(1,1,1)
    tog.Font = Enum.Font.GothamBold; tog.TextSize = 10
    Instance.new("UICorner", tog)

    local state = defaultValue or false
    if state then
        tog.Text = "ON"
        tog.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    end
    
    tog.MouseButton1Down:Connect(function()
        TweenService:Create(tog, TweenInfo.new(0.07, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 36, 0, 15)
        }):Play()
        playSfx(TOGGLE_SFX, 0.5)
    end)
    tog.MouseButton1Up:Connect(function()
        TweenService:Create(tog, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 40, 0, 18)
        }):Play()
    end)
    tog.MouseButton1Click:Connect(function()
        state = not state
        tog.Text = state and "ON" or "OFF"
        TweenService:Create(tog, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        }):Play()
        callback(state)
    end)
    return function() return state end
end

-- ============================================
-- [[ ATTACK PAGE (unscrollable, all fit) ]]
-- ============================================
-- AttackPage height = 330 - 58 = 272
local attackContainer = Instance.new("Frame", AttackPage)
attackContainer.Size = UDim2.new(1, 0, 1, 0)
attackContainer.BackgroundTransparency = 1

local nameBox  = MakeBox(attackContainer, "Target Name...", 4)
local delayBox = MakeBox(attackContainer, "Delay seconds (default: 2)", 32)

local attackStart = MakeBtn(attackContainer, "START ATTACK 🔥", 60, Color3.fromRGB(135, 206, 235), 26)
local attackStop  = MakeBtn(attackContainer, "STOP ATTACK",     90, Color3.fromRGB(200, 80, 80), 26)

local customModeToggle = MakeToggle(attackContainer, "CUSTOM SPAM MODE", 120, function(v) 
    spamMode = v and "custom" or "default"
    customMessageBox.Visible = v
    customMessageList.Visible = v
    addCustomBtn.Visible = v
    clearCustomBtn.Visible = v
end, false)

local customMessageBox = MakeBox(attackContainer, "Enter custom message...", 146)
customMessageBox.Visible = false

local addCustomBtn = MakeBtn(attackContainer, "➕ ADD MESSAGE", 174, Color3.fromRGB(100, 150, 220), 24)
addCustomBtn.Visible = false

local customMessageList = Instance.new("TextLabel", attackContainer)
customMessageList.Size = UDim2.new(0.9, 0, 0, 24)
customMessageList.Position = UDim2.new(0.05, 0, 0, 202)
customMessageList.BackgroundColor3 = Color3.fromRGB(220, 240, 255)
customMessageList.BackgroundTransparency = 0.4
customMessageList.TextColor3 = Color3.fromRGB(0,0,0)
customMessageList.Font = Enum.Font.GothamMedium
customMessageList.TextSize = 10
customMessageList.TextWrapped = true
customMessageList.TextXAlignment = Enum.TextXAlignment.Left
customMessageList.TextYAlignment = Enum.TextYAlignment.Top
customMessageList.Text = "Custom Messages:\n(Click + to add, press CLEAR to remove all)"
customMessageList.Visible = false
Instance.new("UICorner", customMessageList)

local clearCustomBtn = MakeBtn(attackContainer, "🗑️ CLEAR ALL", 230, Color3.fromRGB(200, 120, 80), 24)
clearCustomBtn.Visible = false

-- Footer branding (always visible at bottom)
local footerLabel = Instance.new("TextLabel", attackContainer)
footerLabel.Size = UDim2.new(1, 0, 0, 22)
footerLabel.Position = UDim2.new(0, 0, 0, 250) -- 272-22
footerLabel.Text = "❄️ Axer Spammer V3 | Powered by WR4ITH ❄️"
footerLabel.TextColor3 = Color3.fromRGB(50, 50, 80)
footerLabel.Font = Enum.Font.GothamBold
footerLabel.TextSize = 11
footerLabel.BackgroundTransparency = 1
footerLabel.TextWrapped = true
footerLabel.ZIndex = 10

local function updateCustomMessageDisplay()
    if #customMessages == 0 then
        customMessageList.Text = "Custom Messages:\n(Click + to add, press CLEAR to remove all)"
    else
        local displayText = "Custom Messages:\n"
        for i, msg in ipairs(customMessages) do
            local shortMsg = #msg > 25 and msg:sub(1, 22) .. "..." or msg
            displayText = displayText .. i .. ". " .. shortMsg .. "\n"
        end
        customMessageList.Text = displayText
    end
end

addCustomBtn.MouseButton1Click:Connect(function()
    local newMsg = customMessageBox.Text
    if newMsg and newMsg ~= "" and newMsg ~= "Enter custom message..." then
        table.insert(customMessages, newMsg)
        customMessageBox.Text = ""
        updateCustomMessageDisplay()
        playSfx(CLICK_SFX, 0.4)
    end
end)

clearCustomBtn.MouseButton1Click:Connect(function()
    customMessages = {}
    updateCustomMessageDisplay()
    playSfx(CLICK_SFX, 0.5)
end)

-- ============================================
-- [[ SETTINGS PAGE (scrollable) ]]
-- ============================================
local SettingScroll = Instance.new("ScrollingFrame", SettingPage)
SettingScroll.Size = UDim2.new(1, 0, 1, 0); SettingScroll.BackgroundTransparency = 1
SettingScroll.ScrollBarThickness = 2; SettingScroll.CanvasSize = UDim2.new(0,0,0,300)

local function CreateSettingRow(text, yPos, callback)
    local lbl = Instance.new("TextLabel", SettingScroll)
    lbl.Text = text; lbl.Size = UDim2.new(0.6, 0, 0, 24)
    lbl.Position = UDim2.new(0.05, 0, 0, yPos); lbl.TextColor3 = Color3.new(0,0,0)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10; lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local tog = Instance.new("TextButton", SettingScroll)
    tog.Text = "OFF"; tog.Size = UDim2.new(0, 40, 0, 18)
    tog.Position = UDim2.new(1, -48, 0, yPos + 3)
    tog.BackgroundColor3 = Color3.fromRGB(180, 0, 0); tog.TextColor3 = Color3.new(1,1,1)
    tog.Font = Enum.Font.GothamBold; tog.TextSize = 10
    Instance.new("UICorner", tog)

    local state = false
    tog.MouseButton1Down:Connect(function()
        TweenService:Create(tog, TweenInfo.new(0.07, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 36, 0, 15)
        }):Play()
        playSfx(TOGGLE_SFX, 0.5)
    end)
    tog.MouseButton1Up:Connect(function()
        TweenService:Create(tog, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 40, 0, 18)
        }):Play()
    end)
    tog.MouseButton1Click:Connect(function()
        state = not state
        tog.Text = state and "ON" or "OFF"
        TweenService:Create(tog, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        }):Play()
        callback(state)
    end)
end

CreateSettingRow("ANTI-AFK",    2,  function(v) antiAfkEnabled = v end)
CreateSettingRow("SPEED BOOST", 30,  function(v) speedEnabled   = v end)
CreateSettingRow("JUMP BOOST",  58, function(v) jumpEnabled    = v end)
CreateSettingRow("NOCLIP",      86, function(v) noclipEnabled  = v end)
CreateSettingRow("NOSIT",       114, function(v) nositEnabled   = v end)
CreateSettingRow("🛡️ ANTI-COPY (BH)", 142, function(v) 
    antiCopyEnabled = v
    if v then setupAntiCopy() end
end)
CreateSettingRow("🌀 ANTI-FLING", 170, function(v) 
    antiFlingEnabled = v
    if v then setupAntiFling() end
end)
CreateSettingRow("🚫 ANTI-TAG (always ON)", 198, function(v) end)

-- [[ SETTINGS LOGIC ]]
lp.Idled:Connect(function()
    if antiAfkEnabled then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

RunService.RenderStepped:Connect(function()
    if lp.Character then
        local hum = lp.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = speedEnabled and 100 or 16
            hum.JumpPower = jumpEnabled and 150 or 50
            if nositEnabled then hum.Sit = false end
        end
        if noclipEnabled then
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- ============================================
-- [[ THEME PAGE (scrollable, fixed overflow) ]]
-- ============================================
local ThemeContainer = Instance.new("ScrollingFrame", ThemePage)
ThemeContainer.Size = UDim2.new(1, 0, 1, 0)
ThemeContainer.BackgroundTransparency = 1
ThemeContainer.ScrollBarThickness = 2
-- Calculate canvas: each theme button 32 + 4 padding ≈ 36, 12 themes => 432
ThemeContainer.CanvasSize = UDim2.new(0, 0, 0, 450)

local ThemeLayout = Instance.new("UIListLayout", ThemeContainer)
ThemeLayout.Padding = UDim.new(0, 4)
ThemeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function applyThemeSmooth(backColor, strokeColor, titleColor, tabColor)
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = backColor
    }):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Color = strokeColor
    }):Play()
    TweenService:Create(title, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = titleColor or backColor:Lerp(Color3.new(1,1,1), 0.2)
    }):Play()
    TweenService:Create(TabBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = tabColor or backColor:Lerp(Color3.new(1,1,1), 0.1)
    }):Play()
    TweenService:Create(floatStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Color = strokeColor
    }):Play()
end

local themeList = {
    {name = "❄️ Frosty Ice",  color = Color3.fromRGB(200, 230, 255), stroke = Color3.fromRGB(135, 206, 235)},
    {name = "💎 Royal Navy",    color = Color3.fromRGB(10, 20, 55), stroke = Color3.fromRGB(70, 130, 180)},
    {name = "🔥 Crimson Flame", color = Color3.fromRGB(55, 10, 15), stroke = Color3.fromRGB(200, 50, 50)},
    {name = "🌙 Midnight Black",color = Color3.fromRGB(8, 8, 12), stroke = Color3.fromRGB(100, 100, 100)},
    {name = "🍃 Emerald Mist",  color = Color3.fromRGB(15, 40, 20), stroke = Color3.fromRGB(60, 180, 60)},
    {name = "💜 Royal Purple",  color = Color3.fromRGB(45, 10, 55), stroke = Color3.fromRGB(150, 80, 200)},
    {name = "⭐ Golden Glory",  color = Color3.fromRGB(55, 45, 10), stroke = Color3.fromRGB(255, 215, 0)},
    {name = "🌊 Ocean Depth",   color = Color3.fromRGB(10, 35, 70), stroke = Color3.fromRGB(0, 150, 200)},
    {name = "🎨 Rose Gold",     color = Color3.fromRGB(75, 45, 55), stroke = Color3.fromRGB(200, 150, 160)},
    {name = "❄️ Frost White",   color = Color3.fromRGB(220, 230, 240), stroke = Color3.fromRGB(180, 200, 220)},
    {name = "🍊 Sunset Orange", color = Color3.fromRGB(70, 35, 15), stroke = Color3.fromRGB(255, 100, 50)},
    {name = "💚 Neon Mint",     color = Color3.fromRGB(20, 65, 45), stroke = Color3.fromRGB(0, 255, 100)},
}

for _, t in ipairs(themeList) do
    local tBtn = Instance.new("TextButton", ThemeContainer)
    tBtn.Size = UDim2.new(0.9, 0, 0, 30)
    tBtn.Text = t.name
    tBtn.BackgroundColor3 = t.color
    tBtn.TextColor3 = (t.color.R + t.color.G + t.color.B) / 3 > 0.5 and Color3.new(0,0,0) or Color3.new(1,1,1)
    tBtn.Font = Enum.Font.GothamBold
    tBtn.TextSize = 12
    tBtn.AutoButtonColor = false
    Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 8)
    
    tBtn.MouseEnter:Connect(function()
        TweenService:Create(tBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0.95, 0, 0, 34)
        }):Play()
    end)
    tBtn.MouseLeave:Connect(function()
        TweenService:Create(tBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0.9, 0, 0, 30)
        }):Play()
    end)
    tBtn.MouseButton1Down:Connect(function()
        TweenService:Create(tBtn, TweenInfo.new(0.07, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0.88, 0, 0, 26)
        }):Play()
        playSfx(CLICK_SFX, 0.3)
    end)
    tBtn.MouseButton1Up:Connect(function()
        TweenService:Create(tBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.9, 0, 0, 30)
        }):Play()
    end)
    tBtn.MouseButton1Click:Connect(function()
        applyThemeSmooth(t.color, t.stroke)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🎨 Theme Applied",
                Text = t.name .. " theme activated!",
                Duration = 2
            })
        end)
    end)
end

-- ============================================
-- [[ INFO PAGE (scrollable) ]]
-- ============================================
local InfoScroll = Instance.new("ScrollingFrame", InfoPage)
InfoScroll.Size = UDim2.new(1,0,1,0); InfoScroll.BackgroundTransparency = 1
InfoScroll.ScrollBarThickness = 2; InfoScroll.CanvasSize = UDim2.new(0,0,0,300)

local function MakeInfoLabel(parent, text, yPos, col)
    local l = Instance.new("TextLabel", parent)
    l.Text = text; l.Size = UDim2.new(0.9, 0, 0, 22)
    l.Position = UDim2.new(0.05, 0, 0, yPos)
    l.TextColor3 = col or Color3.new(0,0,0)
    l.Font = Enum.Font.GothamMedium; l.TextSize = 11; l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

MakeInfoLabel(InfoScroll, "👑 Developer: Axer", 4, Color3.fromRGB(0,0,0))
MakeInfoLabel(InfoScroll, "🤝 Co-Developer: Xdemic", 28, Color3.fromRGB(40,40,40))
MakeInfoLabel(InfoScroll, "💬 Discord: Mickeyyy009", 52, Color3.fromRGB(0, 100, 200))
MakeInfoLabel(InfoScroll, "🎮 Roblox: erennn0779", 76, Color3.fromRGB(200, 50, 50))
MakeInfoLabel(InfoScroll, "📦 Version: V3 Ultimate", 100, Color3.fromRGB(0, 150, 0))
MakeInfoLabel(InfoScroll, "🛡️ Features:", 124, Color3.fromRGB(0,0,0))
MakeInfoLabel(InfoScroll, "   - Anti-Lag (Always ON)", 148, Color3.fromRGB(50,50,50))
MakeInfoLabel(InfoScroll, "   - Anti-Tag Spam (Always ON)", 172, Color3.fromRGB(50,50,50))
MakeInfoLabel(InfoScroll, "   - Anti-Fling", 196, Color3.fromRGB(50,50,50))
MakeInfoLabel(InfoScroll, "   - Anti-Copy (Brookhaven)", 220, Color3.fromRGB(50,50,50))
MakeInfoLabel(InfoScroll, "   - Speed / Jump / Noclip", 244, Color3.fromRGB(50,50,50))
MakeInfoLabel(InfoScroll, "   - Custom Themes", 268, Color3.fromRGB(50,50,50))

-- ============================================
-- [[ FLOAT BUTTON (X) ]]
-- ============================================
local float = Instance.new("TextButton", ScreenGui)
float.Size = UDim2.new(0, 42, 0, 42)
float.Position = UDim2.new(0.02, 0, 0.45, 0)
float.Text = "X"; float.Font = Enum.Font.GothamBold
float.TextColor3 = Color3.new(0,0,0); float.TextSize = 20
float.BackgroundColor3 = Color3.fromRGB(200, 230, 255)
Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
local floatStroke = Instance.new("UIStroke", float)
floatStroke.Thickness = 2
floatStroke.Color = Color3.fromRGB(135, 206, 235)
makeDraggable(float, float)

float.MouseButton1Down:Connect(function()
    TweenService:Create(float, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 36, 0, 36)
    }):Play()
end)
float.MouseButton1Up:Connect(function()
    TweenService:Create(float, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 42, 0, 42)
    }):Play()
end)
float.MouseButton1Click:Connect(function()
    if guiOpen then CloseGUI() else OpenGUI() end
end)

-- ============================================
-- [[ RGB ENGINE ]]
-- ============================================
task.spawn(function()
    local h = 0
    while true do
        h = (h + 0.005) % 1
        local c = Color3.fromHSV(h, 1, 1)
        pcall(function() floatStroke.Color = c end)
        pcall(function() float.TextColor3 = c end)
        task.wait(0.05)
    end
end)

-- [[ RP NAME + BIO ]]
task.spawn(function()
    task.wait(2)
    pcall(function()
        local RE = ReplicatedStorage:FindFirstChild("RE")
        if RE and RE:FindFirstChild("1RPNam1eTex1t") then
            RE["1RPNam1eTex1t"]:FireServer("RolePlayName", "❄️ Axer Spammer V3 ❄️")
            task.wait(0.5)
            RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "Welcome " .. lp.Name .. " | Axer ❄️")
        end
    end)
end)

-- ============================================
-- [[ ADMIN COMMANDS ]]
-- ============================================
local Admins = {
    ["VENUS_EDIT"] = true,
    ["AX3RKABOT"] = true
}

local function processAdminCommand(sender, message)
    local msg = message:lower()
    local args = string.split(message, " ")
    if msg:sub(1,9) == "!addadmin" then
        if args[2] then Admins[args[2]] = true end
    elseif msg:sub(1,12) == "!removeadmin" then
        if args[2] then Admins[args[2]] = nil end
    elseif msg == "!admins" then
        local adminList = ""
        for k,v in pairs(Admins) do adminList = adminList .. k .. " " end
        print("Admins: " .. adminList)
    elseif msg:sub(1,8) == "!target " then
        local target = message:sub(9)
        nameBox.Text = target
    elseif msg == "!cleartarget" then
        nameBox.Text = ""
    elseif msg == "!start" then
        attackStart.MouseButton1Click:Fire()
    elseif msg == "!stop" then
        attackStop.MouseButton1Click:Fire()
    elseif msg:sub(1,7) == "!delay " then
        local d = tonumber(args[2])
        if d then delayBox.Text = tostring(d); delayTime = d end
    elseif msg:sub(1,5) == "!say " then
        local txt = message:sub(6)
        SendChatMessage(txt)
    elseif msg:sub(1,6) == "!spam " then
        local txt = message:sub(7)
        nameBox.Text = txt
    elseif msg == "!hidegui" then
        frame.Visible = false
    elseif msg == "!showgui" then
        frame.Visible = true
    elseif msg == "!toggleui" then
        frame.Visible = not frame.Visible
    elseif msg == "!rejoin" then
        game:GetService("TeleportService"):Teleport(game.PlaceId, sender)
    elseif msg == "!kickme" then
        sender:Kick("Kicked by admin")
    elseif msg == "!reset" then
        sender.Character:BreakJoints()
    elseif msg == "!antilag" then
        applyAntiLag()
    elseif msg == "!fpsboost" then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    elseif msg == "!info" then
        print("AXER SPAMMER V3 | Admin:", sender.Name)
    elseif msg == "!help" then
        print("!start / !stop\n!target NAME\n!delay NUM\n!say TEXT\n!spam TEXT\n!hidegui / !showgui\n!rejoin\n!kickme\n!reset\n!admins")
    end
end

for _, plr in pairs(Players:GetPlayers()) do
    plr.Chatted:Connect(function(msg)
        if Admins[plr.Name] then processAdminCommand(plr, msg) end
    end)
end
Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        if Admins[plr.Name] then processAdminCommand(plr, msg) end
    end)
end)

-- ============================================
-- [[ ATTACK LOGIC ]]
-- ============================================
local currentSpamCoroutine = nil

attackStart.MouseButton1Click:Connect(function()
    if attackEnabled then return end
    playSfx(START_SFX, 0.8)
    attackEnabled = true
    attackStart.Text = "🔥 ACTIVE 🔥"
    TweenService:Create(attackStart, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        BackgroundColor3 = Color3.fromRGB(180, 130, 0)
    }):Play()
    
    local target = nameBox.Text
    local d = tonumber(delayBox.Text) or 2
    
    if currentSpamCoroutine then task.cancel(currentSpamCoroutine) end
    
    currentSpamCoroutine = task.spawn(function()
        while attackEnabled do
            if spamMode == "custom" and #customMessages > 0 then
                for _, msg in ipairs(customMessages) do
                    if not attackEnabled then break end
                    local finalMsg = target .. " " .. msg
                    SendChatMessage(finalMsg)
                    task.wait(d)
                end
            else
                for _, m in ipairs(slangs) do
                    if not attackEnabled then break end
                    local finalMsg = target .. " " .. m
                    SendChatMessage(finalMsg)
                    task.wait(d)
                end
            end
        end
    end)
end)

attackStop.MouseButton1Click:Connect(function()
    attackEnabled = false
    if currentSpamCoroutine then
        task.cancel(currentSpamCoroutine)
        currentSpamCoroutine = nil
    end
    attackStart.Text = "START ATTACK 🔥"
    TweenService:Create(attackStart, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        BackgroundColor3 = Color3.fromRGB(135, 206, 235)
    }):Play()
end)

-- ============================================
-- [[ LOADING SEQUENCE ]]
-- ============================================
task.spawn(function()
    task.wait(0.5)
    for i = 0, 100, 2 do
        task.wait(0.04)
        if ProgressBarFill then ProgressBarFill.Size = UDim2.new(i/100, 0, 1, 0) end
        if LoadingPercent then LoadingPercent.Text = i .. "%" end
    end
    task.wait(0.3)
    TweenService:Create(LoadingFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -150, 0.4, -50)
    }):Play()
    TweenService:Create(LoadingTitle,   TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(WelcomeLabel,   TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(LoadingPercent, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    task.wait(0.4)
    if LoadingFrame then LoadingFrame:Destroy() end
    pcall(function() playSfx(LOAD_SFX, 0.9) end)
    OpenGUI()
    task.wait(0.5)
    SendChatMessage("AXER SPAMMER V3 LOADED!")
end)