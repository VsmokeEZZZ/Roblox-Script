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
local farmSpeed = 25
local isAutoFarmEnabled = false
local isAntiAfkEnabled = false
local autoFarmMode = "Basic"
local antiAfkLabel

PlayerTab:CreateDropdown({
    Name = "Farm Mode",
    Options = {"Basic", "Safe"},
    CurrentOption = "Basic",
    Callback = function(Option)
        autoFarmMode = Option
    end,
})

PlayerTab:CreateButton({
    Name = "Toggle Auto Farm",
    Callback = function()
        isAutoFarmEnabled = not isAutoFarmEnabled

        if isAutoFarmEnabled then
            player.Character.Humanoid.Health = 0
            wait(5)

            coroutine.wrap(function()
                while isAutoFarmEnabled do
                    if autoFarmMode == "Basic" then
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

                        if nearestCoin then
                            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                            if humanoidRootPart then
                                local targetPosition = nearestCoin.Position + Vector3.new(0, 3, 0)
                                local tweenInfo = TweenInfo.new((humanoidRootPart.Position - targetPosition).Magnitude / farmSpeed, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
                                tween:Play()
                                tween.Completed:Wait()
                                nearestCoin:Destroy()
                            end
                        end
                    elseif autoFarmMode == "Safe" then
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if obj:IsA("Part") and obj.Name == "Coin_Server" then
                                obj.CFrame = player.Character.HumanoidRootPart.CFrame
                                wait(0.1)
                            end
                        end
                    end

                    wait(0.1)
                end
            end)()
        end
    end,
})

PlayerTab:CreateButton({
    Name = "Anti AFK",
    Callback = function()
        isAntiAfkEnabled = not isAntiAfkEnabled

        if isAntiAfkEnabled then
            for _, connection in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
                connection:Disable()
            end

            if not antiAfkLabel then
                local screenGui = Instance.new("ScreenGui")
                screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                antiAfkLabel = Instance.new("TextLabel")
                antiAfkLabel.Parent = screenGui
                antiAfkLabel.Size = UDim2.new(0, 200, 0, 50)
                antiAfkLabel.Position = UDim2.new(0.5, -100, 0.05, 0)
                antiAfkLabel.BackgroundTransparency = 0.5
                antiAfkLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                antiAfkLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                antiAfkLabel.Text = "Anti AFK: Active"
                antiAfkLabel.TextScaled = true
                antiAfkLabel.Font = Enum.Font.SourceSansBold
            end
        else
            for _, connection in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
                connection:Enable()
            end

            if antiAfkLabel then
                antiAfkLabel:Destroy()
                antiAfkLabel = nil
            end
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
