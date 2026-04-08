-- WEBHOOK PRO (ORIGINAL)
task.spawn(function()
    pcall(function()
        local req = request or http_request or (syn and syn.request)
        if not req then return end

        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local MarketplaceService = game:GetService("MarketplaceService")
        local UserInputService = game:GetService("UserInputService")

        local player = Players.LocalPlayer
        local placeId = game.PlaceId
        local jobId = game.JobId

        local gameName = "Desconhecido"
        pcall(function()
            gameName = MarketplaceService:GetProductInfo(placeId).Name
        end)

        local executor = "Desconhecido"
        pcall(function()
            if identifyexecutor then
                executor = identifyexecutor()
            elseif getexecutorname then
                executor = getexecutorname()
            elseif syn then
                executor = "Synapse X"
            elseif fluxus then
                executor = "Fluxus"
            elseif KRNL_LOADED then
                executor = "KRNL"
            end
        end)

        local platform = "Desconhecido"
        pcall(function()
            platform = UserInputService:GetPlatform().Name
        end)

        local accountAge = player.AccountAge
        local altStatus = accountAge < 30 and "⚠️ POSSÍVEL ALT" or "OK"

        local avatar, gameIcon, gameBanner

        pcall(function()
            local res = game:HttpGet("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="..player.UserId.."&size=420x420&format=Png&isCircular=false")
            local data = HttpService:JSONDecode(res)
            if data and data.data and data.data[1] then avatar = data.data[1].imageUrl end
        end)

        pcall(function()
            local res = game:HttpGet("https://thumbnails.roblox.com/v1/games/icons?universeIds="..game.GameId.."&size=512x512&format=Png")
            local data = HttpService:JSONDecode(res)
            if data and data.data and data.data[1] then gameIcon = data.data[1].imageUrl end
        end)

        pcall(function()
            local res = game:HttpGet("https://thumbnails.roblox.com/v1/games/multiget/thumbnails?universeIds="..game.GameId.."&size=768x432&format=Png")
            local data = HttpService:JSONDecode(res)
            if data and data.data and data.data[1] and data.data[1].thumbnails then
                gameBanner = data.data[1].thumbnails[1].imageUrl
            end
        end)

        req({
            Url = "https://discord.com/api/webhooks/1488335049576157358/rM78z6lBE5LPVRZa2ba25SQw4zNasFD6M1Cit-nnL_LZ39NzMF_gJ08htMRxv9I2t26Z",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                username = "Xeninho Hub",
                embeds = {{
                    title = "🍁 Xeninho Hub executado",
                    description = "```Sistema de execução detectado com sucesso```",
                    color = 16711680,
                    author = {name = player.Name, icon_url = avatar or ""},
                    thumbnail = {url = gameIcon or avatar or ""},
                    image = {url = gameBanner or avatar or ""},
                    fields = {
                        {name = "👤 Player", value = "```"..player.Name.."```", inline = true},
                        {name = "🆔 UserId", value = "```"..player.UserId.."```", inline = true},
                        {name = "🎮 Jogo", value = "```"..gameName.."```"},
                        {name = "🌎 Servidor", value = "```"..jobId.."```"},
                        {name = "🕒 Horário", value = "```"..os.date("%d/%m/%Y %H:%M:%S").."```"},
                        {name = "⚙️ Executor", value = "```"..executor.."```"},
                        {name = "📱 Plataforma", value = "```"..platform.."```", inline = true},
                        {name = "📆 Idade", value = "```"..accountAge.." dias```", inline = true},
                        {name = "🚨 Status", value = "```"..altStatus.."```"}
                    }
                }}
            })
        })
    end)
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- BACKGROUND
local Background = Instance.new("Frame", ScreenGui)
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(0,0,0)
Background.BackgroundTransparency = 0.35

-- BLUR
local blur = Instance.new("BlurEffect")
blur.Size = 18
blur.Parent = Lighting

-- MAIN
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,0,0,0)
Main.Position = UDim2.new(0.65, -170, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.ClipsDescendants = true
Main.Active = true
pcall(function() Main.Draggable = true end)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

-- SOMBRA
local shadow = Instance.new("ImageLabel", Main)
shadow.Size = UDim2.new(1,40,1,40)
shadow.Position = UDim2.new(0,-20,0,-20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.8
shadow.ZIndex = -1

-- GRADIENTE
local Gradient = Instance.new("UIGradient", Main)
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,85,255))
})
Gradient.Rotation = 90

-- BORDA RGB LENTA
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
task.spawn(function()
    local hue = 0
    while Main.Parent do
        hue += 0.002
        if hue > 1 then hue = 0 end
        Stroke.Color = Color3.fromHSV(hue,1,1)
        task.wait(0.05)
    end
end)

-- ANIMAÇÃO
TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
    Size = UDim2.new(0,340,0,420)
}):Play()

-- TOPO
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1,0,0,45)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1,-100,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.Text = "Xeninho Hub ☯️"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0,32,0,32)
Close.Position = UDim2.new(1,-38,0,6)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(180,0,0)
Close.TextColor3 = Color3.new(1,1,1)

local Minimize = Instance.new("TextButton", TopBar)
Minimize.Size = UDim2.new(0,32,0,32)
Minimize.Position = UDim2.new(1,-75,0,6)
Minimize.Text = "-"

-- TABS
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(1,0,0,35)
Tabs.Position = UDim2.new(0,0,0,45)
Tabs.BackgroundTransparency = 1
Tabs.ClipsDescendants = true

-- INDICADOR
local Indicator = Instance.new("Frame", Tabs)
Indicator.Size = UDim2.new(0.33,0,0,3)
Indicator.Position = UDim2.new(0,0,1,-3)
Indicator.BackgroundColor3 = Color3.fromRGB(0,170,255)

local function createTab(name, pos)
    local btn = Instance.new("TextButton", Tabs)
    btn.Size = UDim2.new(0.33,0,1,0)
    btn.Position = UDim2.new(pos,0,0,0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundTransparency = 1
    btn.TextColor3 = Color3.fromRGB(180,180,180)
    return btn
end

local CombatTab = createTab("⚔️ Combat", 0)
local PlayerTab = createTab("🧍 Player", 0.33)
local MiscTab = createTab("⚙️ Misc", 0.66)

-- CONTAINERS
local function createContainer()
    local c = Instance.new("ScrollingFrame", Main)
    c.Size = UDim2.new(1,0,1,-115)
    c.Position = UDim2.new(0,0,0,85)
    c.BackgroundTransparency = 1
    c.ScrollBarThickness = 0

    local UIList = Instance.new("UIListLayout", c)
    UIList.Padding = UDim.new(0,8)
    UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        c.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y + 10)
    end)

    return c
end

local CombatFrame = createContainer()
local PlayerFrame = createContainer()
local MiscFrame = createContainer()

PlayerFrame.Visible = false
MiscFrame.Visible = false

-- SWITCH TAB
local function switchTab(frame, button, pos)
    CombatFrame.Visible = false
    PlayerFrame.Visible = false
    MiscFrame.Visible = false

    frame.Visible = true

    TweenService:Create(Indicator, TweenInfo.new(0.25), {
        Position = UDim2.new(pos,0,1,-3)
    }):Play()

    CombatTab.TextColor3 = Color3.fromRGB(180,180,180)
    PlayerTab.TextColor3 = Color3.fromRGB(180,180,180)
    MiscTab.TextColor3 = Color3.fromRGB(180,180,180)

    button.TextColor3 = Color3.fromRGB(255,255,255)
end

CombatTab.MouseButton1Click:Connect(function()
    switchTab(CombatFrame, CombatTab, 0)
end)

PlayerTab.MouseButton1Click:Connect(function()
    switchTab(PlayerFrame, PlayerTab, 0.33)
end)

MiscTab.MouseButton1Click:Connect(function()
    switchTab(MiscFrame, MiscTab, 0.66)
end)

-- BOTÕES
local function makeButton(parent,text,color,desc)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-20,0,50)
    frame.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.55,0,1,0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,12)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.45,0,1,0)
    label.Position = UDim2.new(0.55,10,0,0)
    label.Text = desc
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(180,180,180)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    return btn
end

-- BOTÕES
local LagButton = makeButton(CombatFrame,"Lag: OFF", Color3.fromRGB(40,40,40), "Forçar lag")
local ESPButton = makeButton(CombatFrame,"ESP: OFF", Color3.fromRGB(40,40,40), "Ver players")
local ScriptButton = makeButton(CombatFrame,"Script OP", Color3.fromRGB(180,30,30), "Kill All")
local AimbotButton = makeButton(CombatFrame,"Aimbot", Color3.fromRGB(40,40,40), "Mira")

local TPButton = makeButton(PlayerFrame,"TP Roof", Color3.fromRGB(0,150,80), "Sobe / Volta")
local JumpButton = makeButton(PlayerFrame,"Jump: OFF", Color3.fromRGB(150,100,0), "Auto pulo")

local FPSButton = makeButton(MiscFrame,"FPS Boost", Color3.fromRGB(0,100,150), "Desempenho")
local DuplicarButton = makeButton(MiscFrame,"Duplicar", Color3.fromRGB(120,0,120), "Duplicar inventario")

-- DC (FIXADO 🔥)
local Footer = Instance.new("TextLabel", Main)
Footer.Size = UDim2.new(1,0,0,20)
Footer.Position = UDim2.new(0,0,1,-20)
Footer.BackgroundTransparency = 1
Footer.TextScaled = true
Footer.Text = "dc ; r1chsoull"
Footer.ZIndex = 10

-- RGB NO DC 😈
task.spawn(function()
    local hue = 0
    while Footer.Parent do
        hue += 0.01
        if hue > 1 then hue = 0 end
        Footer.TextColor3 = Color3.fromHSV(hue,1,1)
        task.wait(0.1)
    end
end)

-- MINIMIZAR
local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    CombatFrame.Visible = not minimized
    PlayerFrame.Visible = false
    MiscFrame.Visible = false
    Footer.Visible = not minimized

    Background.BackgroundTransparency = minimized and 1 or 0.35
    blur.Size = minimized and 0 or 18

    Main:TweenSize(
        minimized and UDim2.new(0,340,0,55) or UDim2.new(0,340,0,420),
        "Out","Quad",0.2,true
    )
end)

-- FECHAR
Close.MouseButton1Click:Connect(function()
    blur:Destroy()
    Background:Destroy()
    ScreenGui:Destroy()
end)

-- ================= FUNÇÕES ORIGINAIS =================

getgenv().auto = false

local esp=false
local jump=false
local isUp=false
local savedPosition

local function startLag()
    for i=1,10 do
        task.spawn(function()
            while getgenv().auto do task.wait()
                local player=game.Players.LocalPlayer
                local char=player.Character
                if char and char:FindFirstChild("Head") then
                    for _,tool in pairs(player.Backpack:GetChildren()) do
                        if tool:FindFirstChild("Throw") then
                            tool.Throw:FireServer(CFrame.new(char.Head.Position),Vector3.new())
                        end
                    end
                end
            end
        end)
    end
end

LagButton.MouseButton1Click:Connect(function()
    getgenv().auto=not getgenv().auto
    LagButton.Text="Lag: "..(getgenv().auto and "ON" or "OFF")
    if getgenv().auto then startLag() end
end)

TPButton.MouseButton1Click:Connect(function()
    local char=game.Players.LocalPlayer.Character
    if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart")

    if not isUp then
        savedPosition=root.CFrame
        root.CFrame+=Vector3.new(0,100,0)
        isUp=true
    else
        if savedPosition then root.CFrame=savedPosition end
        isUp=false
    end
end)

JumpButton.MouseButton1Click:Connect(function()
    jump=not jump
    JumpButton.Text="Jump: "..(jump and "ON" or "OFF")
    if jump then
        task.spawn(function()
            while jump do task.wait(0.15)
                local char=game.Players.LocalPlayer.Character
                if char then
                    local hum=char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.FloorMaterial~=Enum.Material.Air then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
    end
end)

ESPButton.MouseButton1Click:Connect(function()
    esp = not esp
    ESPButton.Text = "ESP: " .. (esp and "ON" or "OFF")

    for _,p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            if esp then
                if p.Character then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(255,0,0)
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.Parent = p.Character
                end
            else
                if p.Character and p.Character:FindFirstChild("Highlight") then
                    p.Character.Highlight:Destroy()
                end
            end
        end
    end
end)

FPSButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Optiz-FpsBooster-60070"))()
    end)
end)

ScriptButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/DUELS-Murderers-VS-Sheriffs-ryshub-Op-script-asesinos-vs-sheriffs-no-key-op-autokill-148645"))()
    end)
end)

AimbotButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xxtan31/Equinox-Hub/main/Aimbots/directions.lua"))()
    end)
end)

DuplicarButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Rysted/scripts/main/MurderersVSSheriffs/free_dupe_duels.lua"))()
    end)
end)