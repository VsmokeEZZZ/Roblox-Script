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

VisualTab:CreateToggle({
    Name = "Esp Box",
    Default = false,
    Callback = function(State)
        isEspEnabled = State

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
local autoFarmConnection

PlayerTab:CreateToggle({
    Name = "Auto Farm Coins",
    Default = false,
    Callback = function(State)
        isAutoFarmEnabled = State

        if isAutoFarmEnabled then
            autoFarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local nearestCoin
                    local shortestDistance = math.huge

                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("Part") and obj.Name == "Coin_Server" then
                            local distance = (character.HumanoidRootPart.Position - obj.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestCoin = obj
                            end
                        end
                    end

                    if nearestCoin then
                        local tweenService = game:GetService("TweenService")
                        local targetPosition = nearestCoin.Position + Vector3.new(0, 3, 0)
                        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        local tween = tweenService:Create(character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})

                        tween:Play()
                        tween.Completed:Wait()
                        nearestCoin:Destroy()
                    end
                end
            end)
        else
            if autoFarmConnection then
                autoFarmConnection:Disconnect()
                autoFarmConnection = nil
            end
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
