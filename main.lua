-- === CONFIGURAÇÕES GERAIS ===
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

-- Estados dos Botões
local flyAtivo = false
local espAtivo = false
local autoFarmAtivo = false

-- === INTERFACE (GUI) ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MinerHub_V2"
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 280) -- Aumentei um pouco o tamanho
frame.Position = UDim2.new(0.1, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true 
frame.Parent = screenGui

local corner = Instance.new("UICorner") -- Cantos arredondados (estilo moderno)
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⛏️ MINER HUB PRO"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Função para criar botões rápido
local function criarBotao(texto, posicao)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = posicao
    btn.Text = texto .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    return btn
end

-- Criando os 3 Botões
local btnESP = criarBotao("ESP MINERIOS", UDim2.new(0.05, 0, 0.2, 0))
local btnFly = criarBotao("VOO (WASD)", UDim2.new(0.05, 0, 0.4, 0))
local btnFarm = criarBotao("AUTO FARM", UDim2.new(0.05, 0, 0.6, 0))

-- === LÓGICA DOS BOTÕES ===

btnESP.MouseButton1Click:Connect(function()
    espAtivo = not espAtivo
    btnESP.Text = espAtivo and "ESP MINERIOS: ON" or "ESP MINERIOS: OFF"
    btnESP.BackgroundColor3 = espAtivo and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
end)

btnFly.MouseButton1Click:Connect(function()
    flyAtivo = not flyAtivo
    btnFly.Text = flyAtivo and "VOO (WASD): ON" or "VOO (WASD): OFF"
    btnFly.BackgroundColor3 = flyAtivo and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
end)

btnFarm.MouseButton1Click:Connect(function()
    autoFarmAtivo = not autoFarmAtivo
    btnFarm.Text = autoFarmAtivo and "AUTO FARM: ON" or "AUTO FARM: OFF"
    btnFarm.BackgroundColor3 = autoFarmAtivo and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
end)

-- === LÓGICA DE BACKEND (LOOPS) ===

-- Loop do ESP e Auto-Farm
task.spawn(function()
    while true do
        local pasta = workspace:FindFirstChild("PlacedOre")
        local closestOre = nil
        local shortestDist = math.huge

        if pasta then
            for _, v in pairs(pasta:GetChildren()) do
                if v.Name == "OreMesh" or v:IsA("BasePart") then
                    -- Lógica do ESP
                    local hl = v:FindFirstChild("ESP_Ativo")
                    if espAtivo then
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "ESP_Ativo"
                            hl.FillColor = Color3.fromRGB(0, 255, 150)
                            hl.OutlineColor = Color3.new(1,1,1)
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = v
                        end
                        hl.Enabled = (root.Position - v.Position).Magnitude <= 400
                    elseif hl then
                        hl.Enabled =
