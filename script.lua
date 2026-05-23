--[[ 
    PROJECT: JnUo Advanced Menu - FIXED VERSION
    MADE BY: JnUo
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Config = {
    MonsterESP = false, PlayerESP = false, InfStamina = false, NoThirst = false, 
    NoHunger = false, InfHealth = false, InfAmmo = false, NoiseSuppress = false,
    InfCloth = false, InfGlass = false, InfGunpowder = false, InfMetal = false, InfStick = false
}

-- GUI (Daha önce yaptığımızın aynısı)
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")); ScreenGui.DisplayOrder = 999999
local Frame = Instance.new("Frame", ScreenGui); Frame.Size = UDim2.new(0, 220, 0, 450); Frame.Position = UDim2.new(0.5, -110, 0.5, -225)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Frame.Visible = false; Frame.Draggable = true

local Scroll = Instance.new("ScrollingFrame", Frame); Scroll.Size = UDim2.new(1, 0, 0.9, 0); Scroll.CanvasSize = UDim2.new(0, 0, 8, 0)

local function createToggle(text, key, desc)
    local btn = Instance.new("TextButton", Scroll); btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Text = text
    btn.Position = UDim2.new(0.05, 0, 0, #Scroll:GetChildren() * 40)
    if desc then btn.Text = text .. " (i)" btn.MouseButton1Down:Connect(function() print(desc) end) end
    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        btn.BackgroundColor3 = Config[key] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    end)
end

-- Butonlar
createToggle("Monster ESP", "MonsterESP"); createToggle("Player ESP", "PlayerESP")
createToggle("Inf Stamina", "InfStamina"); createToggle("No Thirst", "NoThirst"); createToggle("No Hunger", "NoHunger")
createToggle("Inf Health", "InfHealth"); createToggle("Inf Ammo", "InfAmmo", "It only sets the ammo value to 100 of the ammos you have")
createToggle("Inf Cloth", "InfCloth", "Sets Cloth to 100"); createToggle("Inf Glass", "InfGlass", "Sets Glass to 100")
createToggle("Inf Gunpowder", "InfGunpowder", "Sets Gunpowder to 100"); createToggle("Inf Metal", "InfMetal", "Sets Metal to 100")
createToggle("Inf Stick", "InfStick", "Sets Stick to 100")
createToggle("Noise Suppress", "NoiseSuppress")

-- Düzeltilmiş Tool Giver (Aç-Kapa)
local toolGiver = nil
local btnTool = Instance.new("TextButton", Scroll); btnTool.Size = UDim2.new(0.9, 0, 0, 35); btnTool.Text = "Tool Giver"
btnTool.Position = UDim2.new(0.05, 0, 0, #Scroll:GetChildren() * 40)
btnTool.MouseButton1Click:Connect(function()
    if not toolGiver then toolGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gametoolgiver.lua"))()
    else toolGiver = nil; print("Tool Giver Kapandı") end
end)

-- Düzeltilmiş Dex
local btnDex = Instance.new("TextButton", Scroll); btnDex.Size = UDim2.new(0.9, 0, 0, 35); btnDex.Text = "Dex Explorer"
btnDex.Position = UDim2.new(0.05, 0, 0, #Scroll:GetChildren() * 40)
btnDex.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://cdn.jsdelivr.net/gh/infyproton/openeris@main/main.lua"))() end)

-- Mantık (ESP Renkleri ve Can Göstergesi ile)
RunService.Heartbeat:Connect(function()
    if Config.InfStamina then local s = LocalPlayer:FindFirstChild("Stamina", true) if s then s.Value = 1000 end end
    -- (Diğer kaynak kodları aynı)
    
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name == "Pathfinding Monster" or Players:FindFirstChild(v.Name)) then
            local isMonster = (v.Name == "Pathfinding Monster")
            if (isMonster and Config.MonsterESP) or (not isMonster and Config.PlayerESP and v.Name ~= LocalPlayer.Name) then
                if not v:FindFirstChild("EspHighlight") then
                    local h = Instance.new("Highlight", v); h.Name = "EspHighlight"; h.FillColor = isMonster and Color3.new(1,0,0) or Color3.new(0,0,1)
                    local bg = Instance.new("BillboardGui", v); bg.Name = "EspGui"; bg.Size = UDim2.new(0,100,0,50); bg.AlwaysOnTop = true
                    local t = Instance.new("TextLabel", bg); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextScaled = true
                    RunService.Heartbeat:Connect(function() if v:FindFirstChild("Humanoid") then t.Text = math.floor(v.Humanoid.Health) .. " HP" end end)
                end
                v.EspHighlight.Enabled = true
            elseif v:FindFirstChild("EspHighlight") then v.EspHighlight.Enabled = false end
        end
    end
end)

UserInputService.InputBegan:Connect(function(io) if io.KeyCode == Enum.KeyCode.Delete then Frame.Visible = not Frame.Visible end end)
