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
