local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local MainEvent = ReplicatedStorage:FindFirstChild("MainEvent")
local newcframe = CFrame.new
local localplayer = LocalPlayer

local WHITELIST = {
    [2288992054] = true,
    [1192851317] = true,
    [83533259864] = true,
    [82441625510] = true,
    [7810695507] = true,
    [7952648434] = true,
    [8595084218] = true,
    [8074838771] = true
}
local KEY_FILE = "GHOSTED.json"
local WEBHOOK = "https://discord.com/api/webhooks/1405499432547520574/gCW8fMoAIDN6t0hF-iSzFHLXcbhm5V08TlDAViOpFR3GDGVSzJrw9IWghQRlFRzhwJBE"
local ENCRYPTION_KEY = "amirwasherenga1s"
-- XOR encryption with bit32 fallback
local function xorEncryptDecrypt(input, key)
    local bxor = bit32 and bit32.bxor or bit.bxor
    local output = {}
    for i = 1, #input do
        local inputByte = input:byte(i)
        local keyByte = key:byte(((i - 1) % #key) + 1)
        output[i] = string.char(bxor(inputByte, keyByte))
    end
    return table.concat(output)
end
local function genKey(len)
    local chars = "GH0STED"
    local str = ""
    for i = 1, len do
        str = str .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return str
end
local function sendWebhook(key, duration)
    local data = {
        ["content"] = "**Da hood ("..duration..") :** "..key.." at "..os.date("%c").." for "..LocalPlayer.Name.." ("..LocalPlayer.UserId..")"
    }
    local body = HttpService:JSONEncode(data)
    local req = (syn and syn.request) or http_request or request
    if req then
        pcall(function()
            local response = req({
                Url = WEBHOOK,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = body
            })
        end)
    end
end
local function writeEncryptedFile(file, data)
    local jsonData = HttpService:JSONEncode(data)
    local encrypted = xorEncryptDecrypt(jsonData, ENCRYPTION_KEY)
    writefile(file, encrypted)
end
local function readEncryptedFile(file)
    if not isfile(file) then return nil end
    local encrypted = readfile(file)
    local decrypted = xorEncryptDecrypt(encrypted, ENCRYPTION_KEY)
    local ok, decoded = pcall(function() return HttpService:JSONDecode(decrypted) end)
    if ok then return decoded end
    return nil
end
local function handleKey(duration, lifetime)
    local file = KEY_FILE:gsub(".json", "_"..duration..".json")
    local keyData, refresh = nil, false
    if isfile and readfile and writefile then
        keyData = readEncryptedFile(file)
        if keyData and keyData.userid == LocalPlayer.UserId then
            if os.time() - keyData.time > lifetime then
                refresh = true
            end
        else
            refresh = true
        end
        if refresh then
            local newKey = genKey(12)
            keyData = {key = newKey, time = os.time(), userid = LocalPlayer.UserId}
            writeEncryptedFile(file, keyData)
            sendWebhook(newKey, duration)
        end
    else
        local newKey = genKey(12)
        keyData = {key = newKey, time = os.time(), userid = LocalPlayer.UserId}
        sendWebhook(newKey, duration)
    end
    return keyData
end

-- Main Logic
local unlocked = WHITELIST[LocalPlayer.UserId] or false
local keyData1h, keyData1w, keyData1y
if not unlocked then
    keyData1h = handleKey("1h", 3600)
    keyData1w = handleKey("1w", 7*24*3600)
    keyData1y = handleKey("1y", math.huge)
    -- UI
    local keyGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
    keyGui.Name = "Gh0stedKeygui"
    keyGui.ResetOnSpawn = false
    local bg = Instance.new("Frame", keyGui)
    bg.Size = UDim2.new(0, 400, 0, 240)  -- Increased background size
    bg.Position = UDim2.new(0.5, -200, 0.5, -120)  -- Centered adjusted position
    bg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    bg.BorderSizePixel = 0
    bg.BackgroundTransparency = 0.5  -- Set transparency to 50%

    -- Exit Button (X)
    local exitButton = Instance.new("TextButton", bg)
    exitButton.Size = UDim2.new(0, 30, 0, 30)
    exitButton.Position = UDim2.new(1, -35, 0, 5)  -- Position it at the top-right
    exitButton.Text = "X"
    exitButton.Font = Enum.Font.GothamBold
    exitButton.TextSize = 20
    exitButton.TextColor3 = Color3.fromRGB(255, 80, 80)
    exitButton.BackgroundTransparency = 1

    exitButton.MouseButton1Click:Connect(function()
        keyGui:Destroy()  -- Close the GUI when clicked
    end)

    -- Key Type Label
    local keyTypeLabel = Instance.new("TextLabel", bg)
    keyTypeLabel.Text = "Key Type:"
    keyTypeLabel.Size = UDim2.new(0, 80, 0, 28)
    keyTypeLabel.Position = UDim2.new(0, 10, 0, 44)
    keyTypeLabel.TextColor3 = Color3.new(1, 1, 1)
    keyTypeLabel.BackgroundTransparency = 1
    keyTypeLabel.Font = Enum.Font.Gotham
    keyTypeLabel.TextSize = 15

    -- Button for Key Type 1 Hour
    local keyType = Instance.new("TextButton", bg)
    keyType.Size = UDim2.new(0, 90, 0, 28)
    keyType.Position = UDim2.new(0, 95, 0, 44)
    keyType.Text = "1 Hour"
    keyType.Font = Enum.Font.GothamBold
    keyType.TextSize = 15
    keyType.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
    keyType.TextColor3 = Color3.new(1, 1, 1)

    -- Button for Key Type 1 Week
    local keyType2 = Instance.new("TextButton", bg)
    keyType2.Size = UDim2.new(0, 90, 0, 28)
    keyType2.Position = UDim2.new(0, 190, 0, 44)
    keyType2.Text = "1 Week"
    keyType2.Font = Enum.Font.GothamBold
    keyType2.TextSize = 15
    keyType2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    keyType2.TextColor3 = Color3.new(1, 1, 1)

    -- Button for Key Type Permanent
    local keyType3 = Instance.new("TextButton", bg)
    keyType3.Size = UDim2.new(0, 90, 0, 28)
    keyType3.Position = UDim2.new(0, 285, 0, 44)
    keyType3.Text = "Permanent"
    keyType3.Font = Enum.Font.GothamBold
    keyType3.TextSize = 15
    keyType3.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    keyType3.TextColor3 = Color3.new(1, 1, 1)

    -- Key Input Textbox
    local input = Instance.new("TextBox", bg)
    input.Size = UDim2.new(1, -20, 0, 32)
    input.Position = UDim2.new(0, 10, 0, 84)
    input.PlaceholderText = "Paste key here"
    input.ClearTextOnFocus = false
    input.Font = Enum.Font.Code
    input.TextSize = 15
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    input.TextColor3 = Color3.new(1, 1, 1)

    -- Time Left Label
    local timeLeftLabel = Instance.new("TextLabel", bg)
    timeLeftLabel.Size = UDim2.new(1, -20, 0, 18)
    timeLeftLabel.Position = UDim2.new(0, 10, 0, 122)
    timeLeftLabel.BackgroundTransparency = 1
    timeLeftLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timeLeftLabel.Font = Enum.Font.Gotham
    timeLeftLabel.TextSize = 13
    timeLeftLabel.Text = ""

    -- Confirm Button
    local confirm = Instance.new("TextButton", bg)
    confirm.Size = UDim2.new(1, -20, 0, 28)
    confirm.Position = UDim2.new(0, 10, 0, 144)
    confirm.Text = "Unlock"
    confirm.Font = Enum.Font.GothamBold
    confirm.TextSize = 15
    confirm.BackgroundColor3 = Color3.fromRGB(0, 153, 255)
    confirm.TextColor3 = Color3.new(1, 1, 1)

    -- Message Label
    local msg = Instance.new("TextLabel", bg)
    msg.Size = UDim2.new(1, -20, 0, 18)
    msg.Position = UDim2.new(0, 10, 1, -20)
    msg.BackgroundTransparency = 1
    msg.TextColor3 = Color3.fromRGB(255, 80, 80)
    msg.Font = Enum.Font.Gotham
    msg.TextSize = 13
    msg.Text = ""

    -- Key Selection Logic
    local selectedType = "1h"
    local function selectKeyType(t)
        selectedType = t
        keyType.BackgroundColor3 = t == "1h" and Color3.fromRGB(60, 150, 255) or Color3.fromRGB(40, 40, 40)
        keyType2.BackgroundColor3 = t == "1w" and Color3.fromRGB(70, 200, 120) or Color3.fromRGB(40, 40, 40)
        keyType3.BackgroundColor3 = t == "1y" and Color3.fromRGB(200, 180, 80) or Color3.fromRGB(40, 40, 40)
    end
    keyType.MouseButton1Click:Connect(function() selectKeyType("1h") end)
    keyType2.MouseButton1Click:Connect(function() selectKeyType("1w") end)
    keyType3.MouseButton1Click:Connect(function() selectKeyType("1y") end)

    -- Time Left Update Logic
    local function updateTimeLeft()
        local kd = selectedType == "1h" and keyData1h or selectedType == "1w" and keyData1w or keyData1y
        local dur = selectedType == "1h" and 3600 or selectedType == "1w" and 7*24*3600 or math.huge
        local timePassed = os.time() - kd.time
        local timeLeft = math.max(0, dur - timePassed)
        if dur == math.huge then
            timeLeftLabel.Text = "Time left: Permanent"
        else
            local h = math.floor(timeLeft / 3600)
            local m = math.floor((timeLeft % 3600) / 60)
            local s = timeLeft % 60
            timeLeftLabel.Text = string.format("Time left: %02dh %02dm %02ds", h, m, s)
        end
    end

    -- Unlock Logic
    local function tryUnlock()
        local kd = selectedType == "1h" and keyData1h or selectedType == "1w" and keyData1w or selectedType == "1y"
        local inputKey = input.Text:match("^%s*(.-)%s*$")
        if inputKey == kd.key then
            unlocked = true
            keyGui:Destroy()
        else
            msg.Text = "Wrong key"
            input.Text = ""
        end
    end
    confirm.MouseButton1Click:Connect(tryUnlock)
    input.FocusLost:Connect(function(enter) if enter then tryUnlock() end end)

    -- Update Time Left Continuously
    RunService.RenderStepped:Connect(function()
        if not unlocked then updateTimeLeft() end
    end)
end

-- Wait until key is verified
while not unlocked do task.wait() end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

WindUI:Localization({
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = {
        ["ru"] = {
            ["WINDUI_EXAMPLE"] = "WindUI Пример",
            ["WELCOME"] = "Добро пожаловать в WindUI!",
            ["LIB_DESC"] = "Библиотека для создания красивых интерфейсов",
            ["SAVE_CONFIG"] = "Сохранить конфигурацию",
            ["LOAD_CONFIG"] = "Загрузить конфигурацию",
            ["MAIN"] = "Основной",
            ["VISUALS"] = "Визуальные эффекты",
            ["RAGE"] = "Ярость",
            ["LEGIT"] = "Легит",
            ["ESP_SETTINGS"] = "Настройки ESP",
            ["PREDICTION"] = "Предсказание",
            ["SILENT_AIM"] = "Тихий прицел",
            ["WHITELIST"] = "Белый список",
            ["ESP"] = "ESP",
            ["TOOL_TRACERS"] = "Трассировка инструментов",
            ["ESP_COLOR"] = "Цвет ESP",
            ["SHOW_NAMES"] = "Показать имена",
            ["SHOW_HEALTH"] = "Показать здоровье",
            ["DEATH_CHECK"] = "Проверка смерти",
            ["AUTO_FIRE"] = "Автострельба"
        },
        ["en"] = {
            ["WINDUI_EXAMPLE"] = "WindUI Example",
            ["WELCOME"] = "Welcome to WindUI!",
            ["LIB_DESC"] = "Beautiful UI library for Roblox",
            ["SAVE_CONFIG"] = "Save Configuration",
            ["LOAD_CONFIG"] = "Load Configuration",
            ["MAIN"] = "Main",
            ["VISUALS"] = "Visuals",
            ["RAGE"] = "Rage",
            ["LEGIT"] = "Legit",
            ["ESP_SETTINGS"] = "ESP Settings",
            ["PREDICTION"] = "Prediction",
            ["SILENT_AIM"] = "Silent Aim",
            ["WHITELIST"] = "Whitelist",
            ["ESP"] = "ESP",
            ["TOOL_TRACERS"] = "Tool Tracers",
            ["ESP_COLOR"] = "ESP Color",
            ["SHOW_NAMES"] = "Show Names",
            ["SHOW_HEALTH"] = "Show Health",
            ["DEATH_CHECK"] = "Death Check",
            ["AUTO_FIRE"] = "Auto Fire"
        }
    }
})

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

WindUI:Popup({
    Title = gradient("ghosted mobile", Color3.fromHex("#6A11CB"), Color3.fromHex("#2575FC")),
    Icon = "sparkles",
    Content = "loc:LIB_DESC",
    Buttons = {
        {
            Title = "Get Started",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function() end
        }
    }
})

WindUI:Notify({
    Title = "Loaded ghosted!!",
    Content = "Loaded ghosted!",
    Icon = "rbxassetid://4483345998",
    Duration = 5
})

local Window = WindUI:CreateWindow({
    Title = "loc:Ghosted",
    Icon = "palette",
    Author = "loc:WELCOME",
    Folder = "WindUI_Example",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            WindUI:Notify({
                Title = "User Profile",
                Content = "User profile clicked!",
                Duration = 3
            })
        end
    },
    SideBarWidth = 200,
})

Window:Tag({
    Title = "v1.6.4",
    Color = Color3.fromHex("#30ff6a")
})
Window:Tag({
    Title = "Beta",
    Color = Color3.fromHex("#315dff")
})
local TimeTag = Window:Tag({
    Title = "00:00",
    Color = Color3.fromHex("#000000")
})

local hue = 0
task.spawn(function()
    while true do
        local now = os.date("*t")
        local hours = string.format("%02d", now.hour)
        local minutes = string.format("%02d", now.min)
        hue = (hue + 0.01) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        TimeTag:SetTitle(hours .. ":" .. minutes)
        TimeTag:SetColor(color)
        task.wait(0.06)
    end
end)

-- Anti-cheat bypasser
local g = getinfo or debug.getinfo
local d = false
local h = {}
local x, y
setthreadidentity(2)
for i, v in getgc(true) do
    if typeof(v) == "table" then
        local a = rawget(v, "Detected")
        local b = rawget(v, "Kill")
        if typeof(a) == "function" and not x then
            x = a
            local o; o = hookfunction(x, function(c, f, n)
                if c ~= "_" then
                    if d then
                        warn("Adonis AntiCheat flagged\nMethod: {c}\nInfo: {f}")
                    end
                end
                return true
            end)
            table.insert(h, x)
        end
        if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) == "function" and not y then
            y = b
            local o; o = hookfunction(y, function(f)
                if d then
                    warn("Adonis AntiCheat tried to kill (fallback): {f}")
                end
            end)
            table.insert(h, y)
        end
    end
end
local o; o = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local a, f = ...
    if x and a == x then
        if d then
            warn("zins | adonis bypassed")
        end
        return coroutine.yield(coroutine.running())
    end
    return o(...)
end))
setthreadidentity(7)

local Tabs = {
    GameMain = Window:Section({ Title = "loc:MAIN", Opened = true }),
    Visuals = Window:Section({ Title = "loc:VISUALS", Opened = true }),
    Rage = Window:Section({ Title = "loc:RAGE", Opened = true }),
    Config = Window:Section({ Title = "loc:CONFIGURATION", Opened = true })
}

local TabHandles = {
    Legit = Tabs.GameMain:Tab({ Title = "loc:LEGIT", Icon = "rbxassetid://4483345998", Desc = "Legit Settings" }),
    ESPSettings = Tabs.Visuals:Tab({ Title = "loc:ESP_SETTINGS", Icon = "rbxassetid://4483345998", Desc = "ESP Settings" }),
    RageTab = Tabs.Rage:Tab({ Title = "loc:RAGE", Icon = "rbxassetid://4483345998", Desc = "Rage Settings" }),
    Config = Tabs.Config:Tab({ Title = "loc:CONFIGURATION", Icon = "settings", Desc = "Configuration Manager" })
}

-- Legit / Silent Aim Settings
local LegitSettings = {
    SilentAim = { Enabled = false, Prediction = 0.1 },
    Whitelist = "None"
}

TabHandles.Legit:Paragraph({
    Title = "loc:LEGIT",
    Desc = "Silent Aim Settings",
    Image = "rbxassetid://4483345998",
    ImageSize = 20,
    Color = Color3.fromHex("#ffffff")
})

local predictionSlider = TabHandles.Legit:Slider({
    Title = "loc:PREDICTION",
    Value = { Min = 0, Max = 20, Default = 5 },
    Step = 1,
    Callback = function(value)
        LegitSettings.SilentAim.Prediction = value / 10
    end
})

local silentAimToggle = TabHandles.Legit:Toggle({
    Title = "loc:SILENT_AIM",
    Value = false,
    Callback = function(value)
        LegitSettings.SilentAim.Enabled = value
        WindUI:Notify({
            Title = "loc:SILENT_AIM",
            Content = value and "Silent Aim Enabled" or "Silent Aim Disabled",
            Icon = value and "check" or "x",
            Duration = 2
        })
    end
})

local PlayersList = {"None"}
for _, player in pairs(game.Players:GetPlayers()) do
    table.insert(PlayersList, player.Name)
end

local whitelistDropdown = TabHandles.Legit:Dropdown({
    Title = "loc:WHITELIST",
    Values = PlayersList,
    Value = "None",
    Callback = function(value)
        LegitSettings.Whitelist = value
        WindUI:Notify({
            Title = "loc:WHITELIST",
            Content = "Whitelist target: "..value,
            Duration = 2
        })
    end
})

local function GetSilentAimTarget()
    local closestDist = math.huge
    local targetPlayer = nil
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local mouse = localPlayer:GetMouse()
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Name ~= LegitSettings.Whitelist then
                local hrp = player.Character.HumanoidRootPart
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (playerScreenPos - mousePos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        targetPlayer = hrp
                    end
                end
            end
        end
    end
    return targetPlayer
end

local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, key)
    if LegitSettings.SilentAim.Enabled and (key == "Hit" or key == "Target") then
        local target = GetSilentAimTarget()
        if target and target.Parent and target.Parent:FindFirstChild("HumanoidRootPart") then
            local predictedPos = target.Position + (target.Velocity * LegitSettings.SilentAim.Prediction)
            return key == "Hit" and CFrame.new(predictedPos) or target
        end
    end
    return oldIndex(self, key)
end)
setreadonly(mt, true)

-- Visuals / ESP Settings
local ESPEnabled = false
local ESPColor = Color3.fromRGB(0, 255, 0)
local ESPBoxes, ESPNames, ESPHealth = {}, {}, {}
local TracerEnabled = false
local NameEnabled = true
local HealthEnabled = true

TabHandles.ESPSettings:Paragraph({
    Title = "loc:ESP_SETTINGS",
    Desc = "Configure ESP features",
    Image = "rbxassetid://4483345998",
    ImageSize = 20,
    Color = Color3.fromHex("#ffffff")
})

local espToggle = TabHandles.ESPSettings:Toggle({
    Title = "loc:ESP",
    Value = false,
    Callback = function(value)
        ESPEnabled = value
        if not value then
            for _, obj in pairs(ESPBoxes) do obj:Remove() end
            for _, obj in pairs(ESPNames) do obj:Remove() end
            for _, obj in pairs(ESPHealth) do obj:Remove() end
            ESPBoxes, ESPNames, ESPHealth = {}, {}, {}
        end
    end
})

local tracerToggle = TabHandles.ESPSettings:Toggle({
    Title = "loc:TOOL_TRACERS",
    Value = false,
    Callback = function(value)
        TracerEnabled = value
    end
})

local espColorPicker = TabHandles.ESPSettings:Colorpicker({
    Title = "loc:ESP_COLOR",
    Default = ESPColor,
    Callback = function(color)
        ESPColor = color
    end
})

local nameToggle = TabHandles.ESPSettings:Toggle({
    Title = "loc:SHOW_NAMES",
    Value = true,
    Callback = function(value)
        NameEnabled = value
    end
})

local healthToggle = TabHandles.ESPSettings:Toggle({
    Title = "loc:SHOW_HEALTH",
    Value = true,
    Callback = function(value)
        HealthEnabled = value
    end
})

local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, obj in pairs(ESPBoxes) do obj:Remove() end
        for _, obj in pairs(ESPNames) do obj:Remove() end
        for _, obj in pairs(ESPHealth) do obj:Remove() end
        ESPBoxes, ESPNames, ESPHealth = {}, {}, {}
        local camera = workspace.CurrentCamera
        local localPlayer = game.Players.LocalPlayer
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local box = Drawing.new("Square")
                    box.Size = Vector2.new(40, 40)
                    box.Position = Vector2.new(pos.X - 20, pos.Y - 20)
                    box.Color = ESPColor
                    box.Thickness = 2
                    box.Visible = true
                    table.insert(ESPBoxes, box)
                    if NameEnabled then
                        local nameText = Drawing.new("Text")
                        nameText.Text = player.Name
                        nameText.Position = Vector2.new(pos.X, pos.Y - 30)
                        nameText.Color = ESPColor
                        nameText.Size = 16
                        nameText.Center = true
                        nameText.Visible = true
                        table.insert(ESPNames, nameText)
                    end
                    if HealthEnabled and player.Character:FindFirstChild("Humanoid") then
                        local hum = player.Character.Humanoid
                        local healthText = Drawing.new("Text")
                        healthText.Text = math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
                        healthText.Position = Vector2.new(pos.X, pos.Y + 25)
                        healthText.Color = ESPColor
                        healthText.Size = 16
                        healthText.Center = true
                        healthText.Visible = true
                        table.insert(ESPHealth, healthText)
                    end
                    if TracerEnabled then
                        local tool = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            local startPos, _ = camera:WorldToViewportPoint(tool.Handle.Position)
                            local tracer = Drawing.new("Line")
                            tracer.From = Vector2.new(startPos.X, startPos.Y)
                            tracer.To = Vector2.new(pos.X, pos.Y)
                            tracer.Color = ESPColor
                            tracer.Thickness = 1
                            tracer.Visible = true
                            table.insert(ESPBoxes, tracer)
                        end
                    end
                end
            end
        end
    end
end)

-- Rage Tab / Auto Fire & Death Check
local RageSettings = { AutoFire = false, DeathCheck = false }
local firing = false
local delay = 0.05
local uis = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

TabHandles.RageTab:Paragraph({
    Title = "loc:RAGE",
    Desc = "Rage Settings",
    Image = "rbxassetid://4483345998",
    ImageSize = 20,
    Color = Color3.fromHex("#ffffff")
})

local deathCheckToggle = TabHandles.RageTab:Toggle({
    Title = "loc:DEATH_CHECK",
    Value = false,
    Callback = function(value)
        RageSettings.DeathCheck = value
        WindUI:Notify({
            Title = "loc:DEATH_CHECK",
            Content = value and "Death Check Enabled" or "Death Check Disabled",
            Icon = value and "check" or "x",
            Duration = 2
        })
    end
})

local autoFireToggle = TabHandles.RageTab:Toggle({
    Title = "loc:RAPID_FIRE",
    Value = false,
    Callback = function(value)
        RageSettings.AutoFire = value
    end
})

local function isPlayerStuckOrDead()
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    return hum.Health <= 1 and root.Velocity.Magnitude < 0.1
end

RunService.RenderStepped:Connect(function()
    if RageSettings.AutoFire and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not firing then
        firing = true
        task.spawn(function()
            while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                if RageSettings.DeathCheck and isPlayerStuckOrDead() then
                    task.wait(0.1)
                else
                    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                    task.wait(delay)
                end
            end
            firing = false
        end)
    end
end)

-- Configuration Tab
local configName = "default"
local configFile = nil

TabHandles.Config:Paragraph({
    Title = "Configuration Manager",
    Desc = "Save and load your settings",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

TabHandles.Config:Input({
    Title = "Config Name",
    Value = configName,
    Callback = function(value)
        configName = value or "default"
    end
})

local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)
    TabHandles.Config:Button({
        Title = "loc:SAVE_CONFIG",
        Icon = "save",
        Variant = "Primary",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            configFile:Register("predictionSlider", predictionSlider)
            configFile:Register("silentAimToggle", silentAimToggle)
            configFile:Register("whitelistDropdown", whitelistDropdown)
            configFile:Register("espToggle", espToggle)
            configFile:Register("tracerToggle", tracerToggle)
            configFile:Register("espColorPicker", espColorPicker)
            configFile:Register("nameToggle", nameToggle)
            configFile:Register("healthToggle", healthToggle)
            configFile:Register("deathCheckToggle", deathCheckToggle)
            configFile:Register("autoFireToggle", autoFireToggle)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            if configFile:Save() then
                WindUI:Notify({ 
                    Title = "loc:SAVE_CONFIG", 
                    Content = "Saved as: "..configName,
                    Icon = "check",
                    Duration = 3
                })
            else
                WindUI:Notify({ 
                    Title = "Error", 
                    Content = "Failed to save config",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })
    TabHandles.Config:Button({
        Title = "loc:LOAD_CONFIG",
        Icon = "folder",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            local loadedData = configFile:Load()
            if loadedData then
                local lastSave = loadedData.lastSave or "Unknown"
                WindUI:Notify({ 
                    Title = "loc:LOAD_CONFIG", 
                    Content = "Loaded: "..configName.."\nLast save: "..lastSave,
                    Icon = "refresh-cw",
                    Duration = 5
                })
            else
                WindUI:Notify({ 
                    Title = "Error", 
                    Content = "Failed to load config",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })
else
    TabHandles.Config:Paragraph({
        Title = "Config Manager Not Available",
        Desc = "This feature requires ConfigManager",
        Image = "alert-triangle",
        ImageSize = 20,
        Color = "White"
    })
end

Window:OnClose(function()
    print("Window closed")
    if ConfigManager and configFile then
        configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
        configFile:Save()
        print("Config auto-saved on close")
    end
end)

Window:OnDestroy(function()
    print("Window destroyed")
end)
