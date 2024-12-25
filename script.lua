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

local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

local isFarmingEnabled = false
local isEspEnabled = false

local function getNearestCoin()
    local nearestCoin = nil
    local shortestDistance = math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == "Coin_Server" then
            local distance = (player.Character.HumanoidRootPart.Position - obj.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestCoin = obj
            end
        end
    end

    return nearestCoin
end

local function collectCoins()
    while isFarmingEnabled do
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
            end
        end

        wait(1)
    end
end

local function enableESP()
    while isEspEnabled do
        for _, childrik in ipairs(workspace:GetDescendants()) do
            if childrik:FindFirstChild("Humanoid") then
                if not childrik:FindFirstChild("EspBox") then
                    if childrik ~= game.Players.LocalPlayer.Character then
                        local esp = Instance.new("BoxHandleAdornment", childrik)
                        esp.Adornee = childrik
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
        wait(0.5)
    end
end

PlayerTab:CreateButton({
    Name = "Toggle Auto-Farm",
    Callback = function()
        isFarmingEnabled = not isFarmingEnabled
        if isFarmingEnabled then
            collectCoins()
        end
    end,
})

VisualTab:CreateButton({
    Name = "Toggle ESP",
    Callback = function()
        isEspEnabled = not isEspEnabled
        if isEspEnabled then
            enableESP()
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {10, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Slider1",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

PlayerTab:CreateSlider({
    Name = "Jump Height",
    Range = {10, 500},
    Increment = 1,
    Suffix = "Height",
    CurrentValue = 50,
    Flag = "Slider3",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
})

while game:GetService("RunService").RenderStepped:wait() do
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 25
        player.Character.Humanoid.JumpPower = 30
    end
end
