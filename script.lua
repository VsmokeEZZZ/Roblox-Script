local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Anonsperma Script",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "Big Hub"
    },
    KeySystem = false
})

local VisualTab = Window:CreateTab("Visual", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)

local isAutoFarmEnabled = false
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")

local function getNearestCoin()
    local nearestCoin = nil
    local shortestDistance = math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == "Coin_Server" then
            local distance = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestCoin = obj
            end
        end
    end

    return nearestCoin
end

local function collectCoins()
    while isAutoFarmEnabled do
        local targetCoin = getNearestCoin()

        if targetCoin then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                local targetPosition = targetCoin.Position + Vector3.new(0, 3, 0)
                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})

                tween:Play()

                local function del()
                    targetCoin:Destroy()
                end

                wait(0.1)
                targetCoin.Touched:Connect(del)
            else
                warn("HumanoidRootPart не найден")
            end
        else
            warn("Нет доступного Coin_Server")
        end

        wait(1)
    end
end

local function toggleAutoFarm()
    isAutoFarmEnabled = not isAutoFarmEnabled

    if isAutoFarmEnabled then
        collectCoins()
    end
end

PlayerTab:CreateButton({
    Name = "Auto-Farm",
    Position = UDim2.new(0, 0, 0, 0),  -- Размещение кнопки вверху
    Callback = function()
        toggleAutoFarm()
    end,
})

local function createESP()
    while wait(0.5) do
        for _, child in ipairs(workspace:GetDescendants()) do
            if child:FindFirstChild("Humanoid") and not child:FindFirstChild("EspBox") then
                if child ~= game.Players.LocalPlayer.Character then
                    local esp = Instance.new("BoxHandleAdornment", child)
                    esp.Adornee = child
                    esp.ZIndex = 0
                    esp.Size = Vector3.new(4, 5, 1)
                    esp.Transparency = 0.65
                    esp.Color3 = Color3.fromRGB(255, 48, 48)
                    esp.AlwaysOnTop = true
                    esp.Name = "EspBox"
                end
            end
        end
    end
end

PlayerTab:CreateToggle({
    Name = "ESP",
    Default = true,
    Callback = function(value)
        if value then
            createESP()
        else
            for _, child in ipairs(workspace:GetDescendants()) do
                if child:FindFirstChild("EspBox") then
                    child.EspBox:Destroy()
                end
            end
        end
    end
})

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {10, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 25,
    Flag = "Slider1",
    Callback = function(Value)
        player.Character.Humanoid.WalkSpeed = Value
    end,
})

PlayerTab:CreateSlider({
    Name = "Jump Height",
    Range = {10, 100},
    Increment = 1,
    Suffix = "Height",
    CurrentValue = 30,
    Flag = "Slider2",
    Callback = function(Value)
        player.Character.Humanoid.JumpPower = Value
    end,
})

while game:GetService("RunService").RenderStepped:wait() do
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = player.Character.Humanoid.WalkSpeed
        player.Character.Humanoid.JumpPower = player.Character.Humanoid.JumpPower
    end
end
