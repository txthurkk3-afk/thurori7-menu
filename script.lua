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

getgenv().auto = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

-- ANIMAÇÃO
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local Intro = Instance.new("Frame", ScreenGui)
Intro.Size = UDim2.new(1,0,1,0)
Intro.BackgroundColor3 = Color3.fromRGB(0,0,0)

-- 🔊 SOM DE VENTO (FUNCIONANDO)
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://"
sound.Volume = 3
sound.Parent = SoundService

task.spawn(function()
    pcall(function()
        sound:Play()
    end)
end)

local vignette = Instance.new("ImageLabel", Intro)
vignette.Size = UDim2.new(1,0,1,0)
vignette.BackgroundTransparency = 1
vignette.Image = "rbxassetid://4576475446"
vignette.ImageTransparency = 1

local txt = Instance.new("TextLabel", Intro)
txt.Size = UDim2.new(1,0,0,70)
txt.Position = UDim2.new(0.5,0,0.5,0)
txt.AnchorPoint = Vector2.new(0.5,0.5)
txt.Text = "Xeninho Hub"
txt.Font = Enum.Font.GothamBlack
txt.TextScaled = true
txt.TextColor3 = Color3.fromRGB(255,255,255)
txt.BackgroundTransparency = 1
txt.TextTransparency = 1

local stroke = Instance.new("UIStroke", txt)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Transparency = 1

TweenService:Create(blur, TweenInfo.new(0.6), {Size = 30}):Play()
TweenService:Create(vignette, TweenInfo.new(0.6), {ImageTransparency = 0.3}):Play()

TweenService:Create(txt, TweenInfo.new(0.7), {
    TextTransparency = 0,
    Position = UDim2.new(0.5,0,0.45,0)
}):Play()

TweenService:Create(stroke, TweenInfo.new(0.7), {
    Transparency = 0.2
}):Play()

task.wait(1)

TweenService:Create(txt, TweenInfo.new(0.35), {
    Size = UDim2.new(1.2,0,0,80)
}):Play()

for i = 1,3 do
    txt.Position = UDim2.new(0.5,math.random(-5,5),0.45,math.random(-3,3))
    task.wait(0.03)
end

txt.Position = UDim2.new(0.5,0,0.45,0)

task.wait(0.5)

TweenService:Create(Intro, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
TweenService:Create(txt, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(blur, TweenInfo.new(0.6), {Size = 0}):Play()
TweenService:Create(vignette, TweenInfo.new(0.6), {ImageTransparency = 1}):Play()

task.wait(0.7)
Intro:Destroy()
blur:Destroy()

-- MAIN
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,340,0,420)
Main.Position = UDim2.new(0.68,0,0.15,0)
Main.BackgroundColor3 = Color3.fromRGB(255,255,255)
Main.Active = true
pcall(function() Main.Draggable = true end)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

-- GRADIENTE ARGENTINA 🇦🇷 (COR CERTA)
local Gradient = Instance.new("UIGradient", Main)
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(116, 172, 223)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(116, 172, 223))
})
Gradient.Rotation = 90

-- BORDA RGB
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
task.spawn(function()
    local hue = 0
    while Main.Parent do
        hue += 0.01
        if hue > 1 then hue = 0 end
        Stroke.Color = Color3.fromHSV(hue,1,1)
        task.wait(0.03)
    end
end)

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
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Minimize = Instance.new("TextButton", TopBar)
Minimize.Size = UDim2.new(0,32,0,32)
Minimize.Position = UDim2.new(1,-75,0,6)
Minimize.Text = "-"

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1,0,1,-80)
Container.Position = UDim2.new(0,0,0,50)
Container.BackgroundTransparency = 1

local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    Container.Visible = not minimized
    Main.Size = minimized and UDim2.new(0,340,0,55) or UDim2.new(0,340,0,420)
end)

local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0,8)

local function makeButton(text,color,desc)
    local frame = Instance.new("Frame", Container)
    frame.Size = UDim2.new(1,-20,0,42)
    frame.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.6,0,1,0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(235,235,235)
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.4,0,1,0)
    label.Position = UDim2.new(0.6,6,0,0)
    label.Text = desc
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(160,160,160)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    return btn
end

-- BOTÕES
local LagButton = makeButton("Lag: OFF", Color3.fromRGB(40,40,40), "Forçar lag")
local TPButton = makeButton("TP Roof", Color3.fromRGB(0,150,80), "Sobe / Volta")
local FPSButton = makeButton("FPS Boost", Color3.fromRGB(0,100,150), "Desempenho")
local ESPButton = makeButton("ESP: OFF", Color3.fromRGB(40,40,40), "Ver players")
local ScriptButton = makeButton("Script OP", Color3.fromRGB(180,30,30), "Kill All")
local AimbotButton = makeButton("Aimbot", Color3.fromRGB(40,40,40), "Mira")
local JumpButton = makeButton("Jump: OFF", Color3.fromRGB(150,100,0), "Auto pulo")

-- VARS
local esp=false
local jump=false
local isUp=false
local savedPosition

-- LAG
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

-- TP
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

-- JUMP
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

-- ESP
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

-- FPS
FPSButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Optiz-FpsBooster-60070"))()
    end)
end)

-- SCRIPT OP
ScriptButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/DUELS-Murderers-VS-Sheriffs-ryshub-Op-script-asesinos-vs-sheriffs-no-key-op-autokill-148645"))()
    end)
end)

-- AIMBOT
AimbotButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xxtan31/Equinox-Hub/main/Aimbots/directions.lua"))()
    end)
end)

-- DC
local Footer = Instance.new("TextLabel", Main)
Footer.Size = UDim2.new(1,0,0,22)
Footer.Position = UDim2.new(0,0,1,-24)
Footer.BackgroundTransparency = 1
Footer.TextScaled = true
Footer.Text = "dc ; r1chsoull"

task.spawn(function()
    local colors = {
        Color3.fromRGB(255,0,0),
        Color3.fromRGB(255,255,255)
    }
    local i = 1
    while Footer.Parent do
        Footer.TextColor3 = colors[i]
        i = i % #colors + 1
        task.wait(0.4)
    end
end)