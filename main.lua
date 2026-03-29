local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- === CRIAÇÃO DA INTERFACE (GUI) ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeuHubMineracao"
screenGui.Parent = game.CoreGui -- Protege a GUI para não sumir ao morrer

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(0.1, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true -- Você pode arrastar o menu com o mouse!
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "MINER HUB v1.0"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Parent = frame

-- === BOTÃO 1: ESP DE MINÉRIOS ===
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.9, 0, 0, 40)
espButton.Position = UDim2.new(0.05, 0, 0.25, 0)
espButton.Text = "ESP: DESLIGADO"
espButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
espButton.Parent = frame

local espAtivo = false
espButton.MouseButton1Click:Connect(function()
    espAtivo = not espAtivo
    espButton.Text = espAtivo and "ESP: LIGADO" or "ESP: DESLIGADO"
    espButton.BackgroundColor3 = espAtivo and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- === BOTÃO 2: VOO (WASD) ===
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, 40)
flyButton.Position = UDim2.new(0.05, 0, 0.45, 0)
flyButton.Text = "VOO: DESLIGADO"
flyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
flyButton.Parent = frame

local flyAtivo = false
flyButton.MouseButton1Click:Connect(function()
    flyAtivo = not flyAtivo
    flyButton.Text = flyAtivo and "VOO: LIGADO" or "VOO: DESLIGADO"
    flyButton.BackgroundColor3 = flyAtivo and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- === LOGICA DO ESP (RODANDO EM BACKGROUND) ===
task.spawn(function()
    while true do
        local pasta = workspace:FindFirstChild("PlacedOre")
        if pasta then
            for _, v in pairs(pasta:GetChildren()) do
                if v.Name == "OreMesh" then
                    local hl = v:FindFirstChild("ESP_Ativo")
                    if espAtivo then
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "ESP_Ativo"
                            hl.FillColor = Color3.fromRGB(0, 255, 144)
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = v
                        end
                        hl.Enabled = (root.Position - v.Position).Magnitude <= 400
                    else
                        if hl then hl.Enabled = false end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- === LOGICA DO VOO (RODANDO EM BACKGROUND) ===
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Parent = root

local UIS = game:GetService("UserInputService")
task.spawn(function()
    while true do
        if flyAtivo then
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            local dir = Vector3.new(0, 0, 0)
            local cam = workspace.CurrentCamera
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            bv.Velocity = dir.Unit * 70
            if dir.Magnitude == 0 then bv.Velocity = Vector3.new(0,0,0) end
        else
            bv.MaxForce = Vector3.new(0, 0, 0)
        end
        task.wait(0.03)
    end
end)

print("Seu Hub foi carregado com sucesso!")
