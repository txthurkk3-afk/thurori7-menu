-- WEBHOOK PRO (LOG EXECUÇÃO) [FIXADO]
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

        -- ⚙️ EXECUTOR
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

        -- 📱 PLATAFORMA
        local platform = "Desconhecido"
        pcall(function()
            platform = UserInputService:GetPlatform().Name
        end)

        -- 📆 IDADE DA CONTA
        local accountAge = player.AccountAge

        -- 🚨 ALT
        local altStatus = accountAge < 30 and "⚠️ POSSÍVEL ALT" or "OK"

        -- 👤 AVATAR
        local avatar = nil
        pcall(function()
            local response = game:HttpGet("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
                .. player.UserId ..
                "&size=420x420&format=Png&isCircular=false")

            local data = HttpService:JSONDecode(response)
            if data and data.data and data.data[1] then
                avatar = data.data[1].imageUrl
            end
        end)

        -- 🎮 ÍCONE DO JOGO
        local gameIcon = nil
        pcall(function()
            local response = game:HttpGet("https://thumbnails.roblox.com/v1/games/icons?universeIds="
                .. game.GameId ..
                "&size=512x512&format=Png")

            local data = HttpService:JSONDecode(response)
            if data and data.data and data.data[1] then
                gameIcon = data.data[1].imageUrl
            end
        end)

        -- 🖼️ BANNER DO JOGO
        local gameBanner = nil
        pcall(function()
            local response = game:HttpGet("https://thumbnails.roblox.com/v1/games/multiget/thumbnails?universeIds="
                .. game.GameId ..
                "&size=768x432&format=Png")

            local data = HttpService:JSONDecode(response)
            if data and data.data and data.data[1] and data.data[1].thumbnails and data.data[1].thumbnails[1] then
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

                    author = {
                        name = player.Name,
                        icon_url = avatar or ""
                    },

                    thumbnail = {
                        url = gameIcon or avatar or ""
                    },

                    image = {
                        url = gameBanner or avatar or ""
                    },

                    fields = {
                        {name = "👤 Player", value = "```" .. player.Name .. "```", inline = true},
                        {name = "🆔 UserId", value = "```" .. player.UserId .. "```", inline = true},
                        {name = "🎮 Jogo", value = "```" .. gameName .. "```", inline = false},
                        {name = "🌎 Servidor", value = "```" .. jobId .. "```", inline = false},
                        {name = "🕒 Horário", value = "```" .. os.date("%d/%m/%Y %H:%M:%S") .. "```", inline = false},
                        {name = "⚙️ Executor", value = "```" .. executor .. "```", inline = false},
                        {name = "📱 Plataforma", value = "```" .. platform .. "```", inline = true},
                        {name = "📆 Idade da conta", value = "```" .. accountAge .. " dias```", inline = true},
                        {name = "🚨 Status", value = "```" .. altStatus .. "```", inline = false}
                    },

                    footer = {
                        text = "Xeninho Hub • Sistema de Logs"
                    }
                }}
            })
        })
    end)
end)

getgenv().auto = false

-- GUI (igual seu)
local ScreenGui = Instance.new("ScreenGui")
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.7, 0, 0.15, 0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
pcall(function() Main.Draggable = true end)

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

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
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1,-80,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.Text = "Xeninho Hub ☯️"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-35,0,5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(80,0,0)
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Minimize = Instance.new("TextButton", TopBar)
Minimize.Size = UDim2.new(0,30,0,30)
Minimize.Position = UDim2.new(1,-70,0,5)
Minimize.Text = "-"
Minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
Minimize.TextColor3 = Color3.fromRGB(255,255,255)

-- CONTAINER
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1,0,1,-75)
Container.Position = UDim2.new(0,0,0,45)
Container.BackgroundTransparency = 1

local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    Container.Visible = not minimized
    Main.Size = minimized and UDim2.new(0,320,0,50) or UDim2.new(0,320,0,400)
    Minimize.Text = minimized and "+" or "-"
end)

-- LISTA
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0,6)

local function makeButton(text, color, desc)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-20,0,36)
    frame.BackgroundTransparency = 1
    frame.Parent = Container

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.6,0,1,0)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = text
    btn.Parent = frame

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4,0,1,0)
    label.Position = UDim2.new(0.6,5,0,0)
    label.Text = desc
    label.TextColor3 = Color3.fromRGB(140,140,140)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    return btn
end

-- BOTÕES
local LagButton = makeButton("Lag: OFF", Color3.fromRGB(30,30,30), "Forçar lag")
local TPButton = makeButton("TP Roof", Color3.fromRGB(0,120,60), "Sobe / Volta")
local FPSButton = makeButton("FPS Boost", Color3.fromRGB(0,80,120), "Melhorar desempenho")
local ESPButton = makeButton("ESP: OFF", Color3.fromRGB(30,30,30), "Ver jogadores")
local ScriptButton = makeButton("Script OP", Color3.fromRGB(120,0,0), "Script OP / Kill All")
local AimbotButton = makeButton("Aimbot", Color3.fromRGB(30,30,30), "Mira automática")
local JumpButton = makeButton("Jump: OFF", Color3.fromRGB(120,60,0), "Auto pulo")

-- VARS
local esp = false
local jump = false
local isUp = false
local savedPosition

-- LAG
local function startLag()
    for i = 1,10 do
        task.spawn(function()
            while getgenv().auto do task.wait()
                local player = game.Players.LocalPlayer
                local char = player.Character

                if char and char:FindFirstChild("Head") then
                    for _,tool in pairs(player.Backpack:GetChildren()) do
                        if tool:FindFirstChild("Throw") then
                            tool.Throw:FireServer(
                                CFrame.new(char.Head.Position),
                                Vector3.new(0,0,0)
                            )
                        end
                    end
                end
            end
        end)
    end
end

LagButton.MouseButton1Click:Connect(function()
    getgenv().auto = not getgenv().auto
    LagButton.Text = "Lag: " .. (getgenv().auto and "ON" or "OFF")

    if getgenv().auto then
        startLag()
        game.Players.LocalPlayer.CharacterAdded:Connect(function()
            if getgenv().auto then
                task.wait(1)
                startLag()
            end
        end)
    end
end)

-- TP
TPButton.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")

    if not isUp then
        savedPosition = root.CFrame
        root.CFrame += Vector3.new(0,100,0)
        isUp = true
    else
        if savedPosition then root.CFrame = savedPosition end
        isUp = false
    end
end)

-- JUMP
JumpButton.MouseButton1Click:Connect(function()
    jump = not jump
    JumpButton.Text = "Jump: " .. (jump and "ON" or "OFF")

    if jump then
        task.spawn(function()
            while jump do
                task.wait(0.15)
                local char = game.Players.LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.FloorMaterial ~= Enum.Material.Air then
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
Footer.Text = "dc ; 7tzzyy"

task.spawn(function()
    local colors = {
        Color3.fromRGB(0,0,0),
        Color3.fromRGB(255,0,0),
        Color3.fromRGB(255,255,255)
    }
    local i = 1
    while Footer.Parent do
        Footer.TextColor3 = colors[i]
        i += 1
        if i > #colors then i = 1 end
        task.wait(0.4)
    end
end)