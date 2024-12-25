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

local isEspEnabled = false
local espConnection

VisualTab:CreateButton({
    Name = "Esp Box",
    Callback = function()
        isEspEnabled = not isEspEnabled

        if isEspEnabled then
            espConnection = game:GetService("RunService").Heartbeat:Connect(function()
                for _, childrik in ipairs(workspace:GetDescendants()) do
                    if childrik:FindFirstChild("Humanoid") then
                        if not childrik:FindFirstChild("EspBox") and childrik ~= game.Players.LocalPlayer.Character then
                            local esp = Instance.new("BoxHandleAdornment")
                            esp.Adornee = childrik
                            esp.Size = Vector3.new(4, 5, 1)
                            esp.Transparency = 0.65
                            esp.Color3 = Color3.fromRGB(255, 255, 255)
                            esp.AlwaysOnTop = true
                            esp.Name = "EspBox"
                            esp.Parent = childrik
                        end
                    end
                end
            end)
        else
            if espConnection then
                espConnection:Disconnect()
            end
            for _, childrik in ipairs(workspace:GetDescendants()) do
                if childrik:FindFirstChild("EspBox") then
                    childrik.EspBox:Destroy()
                end
            end
        end
    end,
})

local isAutoFarmEnabled = false

PlayerTab:CreateButton({
    Name = "Auto Farm Coins",
    Callback = function()
        isAutoFarmEnabled = not isAutoFarmEnabled

        if isAutoFarmEnabled then
            local function getNearestCoin()
                local nearestCoin = nil
                local shortestDistance = math.huge
                local player = game.Players.LocalPlayer

                for _, obj in ipairs(game.Workspace:GetDescendants()) do
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
                while isAutoFarmEnabled do
                    local player = game.Players.LocalPlayer
                    local targetCoin = getNearestCoin()

                    if targetCoin and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local humanoidRootPart = player.Character.HumanoidRootPart
                        local tweenService = game:GetService("TweenService")
                        local targetPosition = targetCoin.Position + Vector3.new(0, 3, 0)
                        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})

                        tween:Play()
                        tween.Completed:Wait()
                        targetCoin:Destroy()
                    else
                        wait(1)
                    end
                end
            end

            spawn(collectCoins)
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {10, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 10,
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
    CurrentValue = 10,
    Flag = "Slider3",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
})
