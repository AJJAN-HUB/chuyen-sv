-- Utra FixLag - Standalone Performance Panel
-- Tach rieng, khong nap hub hack trung / khong can source ben ngoai.
-- Toi uu do hoa local, mute local, shader hau ky; khong xoa object game.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
    local old = playerGui:FindFirstChild("NhatKhanhUtraFixLag_GUI")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "NhatKhanhUtraFixLag_GUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = parent
    return c
end
local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(75, 190, 255)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.15
    s.Parent = parent
    return s
end
local function label(parent, text, size, pos, fontSize, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.Size = size
    l.Position = pos
    l.Font = font or Enum.Font.GothamMedium
    l.TextSize = fontSize or 13
    l.TextColor3 = color or Color3.fromRGB(240, 247, 255)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end
local function button(parent, text, size, pos, color)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = color or Color3.fromRGB(34, 54, 82)
    b.BorderSizePixel = 0
    b.AutoButtonColor = true
    b.Text = text
    b.TextColor3 = Color3.fromRGB(245, 250, 255)
    b.TextSize = 12
    b.Font = Enum.Font.GothamSemibold
    b.Parent = parent
    corner(b, 10)
    return b
end

-- Main panel
local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.fromOffset(285, 350)
main.Position = UDim2.new(0.5, -142, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(14, 20, 34)
main.BorderSizePixel = 0
main.Active = true
main.Visible = true -- Vao game hien menu day du ngay
main.Parent = gui
corner(main, 16)
stroke(main, Color3.fromRGB(73, 190, 255), 1.4, 0.08)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 39, 65)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 19, 32))
})
gradient.Rotation = 90
gradient.Parent = main

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, -14, 0, 48)
header.Position = UDim2.fromOffset(7, 7)
header.BackgroundColor3 = Color3.fromRGB(25, 44, 72)
header.BorderSizePixel = 0
header.Active = true
header.Parent = main
corner(header, 12)

local logo = label(header, "N", UDim2.fromOffset(30, 32), UDim2.fromOffset(10, 7), 22, Color3.fromRGB(83, 220, 255), Enum.Font.GothamBlack)
local title = label(header, "UTRA FIXLAG", UDim2.new(1, -90, 0, 20), UDim2.fromOffset(43, 6), 14, Color3.fromRGB(245, 250, 255), Enum.Font.GothamBold)
local subtitle = label(header, "REAL-TIME PERFORMANCE", UDim2.new(1, -55, 0, 14), UDim2.fromOffset(43, 25), 8, Color3.fromRGB(145, 188, 220), Enum.Font.Gotham)
local hideBtn = button(header, "—", UDim2.fromOffset(28, 28), UDim2.new(1, -35, 0, 10), Color3.fromRGB(48, 70, 101))
hideBtn.TextSize = 18

label(main, "CHỨC NĂNG", UDim2.new(1, -28, 0, 18), UDim2.fromOffset(14, 64), 10, Color3.fromRGB(125, 170, 205), Enum.Font.GothamBold)

local fixBtn = button(main, "⚡  FIX LAG", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 87), Color3.fromRGB(29, 87, 133))
local superBtn = button(main, "🚀  SIÊU FIX LAG", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 132), Color3.fromRGB(78, 58, 135))
local capBtn = button(main, "🎯  BỎ GIỚI HẠN FPS: OFF", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 177), Color3.fromRGB(105, 83, 39))
local muteBtn = button(main, "🔇  TẮT ÂM THANH  :  OFF", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 222), Color3.fromRGB(29, 105, 91))
local shaderBtn = button(main, "🎨  MỞ BẢNG SHADER", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 267), Color3.fromRGB(111, 61, 135))
local status = label(main, "Trạng thái: menu sẵn sàng", UDim2.new(1, -28, 0, 18), UDim2.fromOffset(14, 311), 10, Color3.fromRGB(145, 188, 220), Enum.Font.Gotham)

-- Shader mini panel
local shader = Instance.new("Frame")
shader.Name = "ShaderPanel"
shader.Size = UDim2.fromOffset(235, 268)
shader.Position = UDim2.new(0.5, 150, 0.5, -134)
shader.BackgroundColor3 = Color3.fromRGB(15, 21, 36)
shader.BorderSizePixel = 0
shader.Visible = false
shader.Active = true
shader.Parent = gui
corner(shader, 15)
stroke(shader, Color3.fromRGB(195, 115, 255), 1.3, 0.08)
local shHead = Instance.new("Frame")
shHead.Size = UDim2.new(1, -12, 0, 42)
shHead.Position = UDim2.fromOffset(6, 6)
shHead.BackgroundColor3 = Color3.fromRGB(42, 33, 70)
shHead.BorderSizePixel = 0
shHead.Active = true
shHead.Parent = shader
corner(shHead, 10)
label(shHead, "🎨  CHỌN MÀU SHADER", UDim2.new(1, -48, 1, 0), UDim2.fromOffset(10, 0), 12, Color3.fromRGB(248, 242, 255), Enum.Font.GothamBold)
local shHide = button(shHead, "×", UDim2.fromOffset(26, 26), UDim2.new(1, -32, 0, 8), Color3.fromRGB(76, 53, 102))
shHide.TextSize = 18
local shToggle = button(shader, "HIỆU ỨNG: OFF", UDim2.new(1, -20, 0, 32), UDim2.fromOffset(10, 56), Color3.fromRGB(62, 67, 83))
local presetNames = {"Tự nhiên", "Rực rỡ", "Điện ảnh", "Ấm áp", "Xanh lạnh", "Sáng rõ"}
local presetColors = {
    Color3.fromRGB(76, 126, 83), Color3.fromRGB(23, 153, 144),
    Color3.fromRGB(113, 78, 163), Color3.fromRGB(177, 111, 48),
    Color3.fromRGB(53, 112, 173), Color3.fromRGB(174, 148, 57)
}
local selectedPreset = "Rực rỡ"
local shaderOn = false
local presetButtons = {}
local applyShader -- forward declaration for preset callbacks
for i, name in ipairs(presetNames) do
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    local b = button(shader, name, UDim2.fromOffset(101, 38), UDim2.fromOffset(11 + col * 111, 98 + row * 45), presetColors[i])
    b.Name = "Preset_" .. name
    presetButtons[name] = b
    b.Activated:Connect(function()
        selectedPreset = name
        for preset, btn in pairs(presetButtons) do
            btn.Text = (preset == selectedPreset and "✓ " or "") .. preset
            btn.BackgroundTransparency = (preset == selectedPreset) and 0 or 0.22
        end
        if shaderOn then
            applyShader()
            status.Text = "Đã áp dụng shader: " .. selectedPreset
        else
            status.Text = "Đã chọn preset: " .. selectedPreset .. " • bấm HIỆU ỨNG để bật"
        end
    end)
end
local shNote = label(shader, "Ẩn bảng không tắt hiệu ứng.", UDim2.new(1, -20, 0, 20), UDim2.fromOffset(10, 239), 9, Color3.fromRGB(153, 166, 194), Enum.Font.Gotham)

-- Floating reopen button, draggable on touch/mouse
local float = button(gui, "♥", UDim2.fromOffset(94, 88), UDim2.new(0, 14, 0.55, 0), Color3.fromRGB(8, 20, 36))
float.Name = "NhatKhanhFloatingButton"
float.TextSize = 28
float.Font = Enum.Font.GothamBlack
float.TextColor3 = Color3.fromRGB(66, 224, 255)
float.TextYAlignment = Enum.TextYAlignment.Top
float.Visible = false -- Menu mo san; nut trai tim hien khi thu nho
float.ZIndex = 4
corner(float, 18)
local floatStroke = stroke(float, Color3.fromRGB(66, 224, 255), 1.6, 0.02)
local floatGradient = Instance.new("UIGradient")
floatGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 49, 72)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 16, 32))
})
floatGradient.Rotation = 45
floatGradient.Parent = float
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "LiveFPS"
fpsLabel.AnchorPoint = Vector2.new(0.5, 1)
fpsLabel.Position = UDim2.new(0.5, 0, 1, -5)
fpsLabel.Size = UDim2.new(1, -8, 0, 39)
fpsLabel.BackgroundColor3 = Color3.fromRGB(4, 12, 22)
fpsLabel.BackgroundTransparency = 0.08
fpsLabel.BorderSizePixel = 0
fpsLabel.Text = "FPS --  |  PING --\nPIN --"
fpsLabel.TextWrapped = true
fpsLabel.TextYAlignment = Enum.TextYAlignment.Center
fpsLabel.TextColor3 = Color3.fromRGB(130, 255, 200)
fpsLabel.TextSize = 10
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.ZIndex = 6
fpsLabel.Parent = float
corner(fpsLabel, 6)
local fpsLabelStroke = stroke(fpsLabel, Color3.fromRGB(44, 171, 190), 0.8, 0.3)

-- Live monitor: FPS from rendered frames, ping from Stats if exposed, battery if API is supported.
local function readPingMs()
    local ok, value = pcall(function()
        local network = Stats:FindFirstChild("Network")
        local serverStats = network and network:FindFirstChild("ServerStatsItem")
        local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
        if not dataPing then return nil end
        local raw = dataPing:GetValue()
        if type(raw) == "number" then return math.floor(raw + 0.5) end
        local textValue = dataPing:GetValueString()
        local number = tonumber(string.match(textValue, "[%d%.]+"))
        return number and math.floor(number + 0.5) or nil
    end)
    if ok then return value end
    return nil
end

local function readBatteryPercent()
    local candidates = {}
    pcall(function()
        if type(getdevicebattery) == "function" then table.insert(candidates, getdevicebattery) end
    end)
    pcall(function()
        if type(getbattery) == "function" then table.insert(candidates, getbattery) end
    end)
    for _, fn in ipairs(candidates) do
        local ok, value = pcall(fn)
        if ok and type(value) == "number" then
            if value <= 1 then value = value * 100 end
            if value >= 0 and value <= 100 then return math.floor(value + 0.5) end
        end
    end
    local ok, value = pcall(function()
        return UserInputService:GetDeviceBatteryLevel()
    end)
    if ok and type(value) == "number" and value >= 0 and value <= 1 then
        return math.floor(value * 100 + 0.5)
    end
    return nil
end

local fpsFrames, fpsElapsed = 0, 0
local fpsConnection = RunService.RenderStepped:Connect(function(dt)
    fpsFrames = fpsFrames + 1
    fpsElapsed = fpsElapsed + dt
    if fpsElapsed >= 0.5 then
        local fps = math.floor((fpsFrames / math.max(fpsElapsed, 0.001)) + 0.5)
        local ping = readPingMs()
        local battery = readBatteryPercent()
        local pingText = ping and (tostring(ping) .. " ms") or "N/A"
        local batteryText = battery and (tostring(battery) .. "%") or "N/A"
        fpsLabel.Text = "FPS " .. tostring(fps) .. "  |  " .. pingText .. "\nPIN " .. batteryText
        if fps < 25 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 105, 125)
            floatStroke.Color = Color3.fromRGB(255, 82, 115)
        elseif fps < 45 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 205, 90)
            floatStroke.Color = Color3.fromRGB(255, 180, 70)
        else
            fpsLabel.TextColor3 = Color3.fromRGB(130, 255, 200)
            floatStroke.Color = Color3.fromRGB(66, 224, 255)
        end
        fpsFrames, fpsElapsed = 0, 0
    end
end)

local function setMainVisible(visible)
    main.Visible = visible
    if not visible then
        shader.Visible = false
        float.Visible = true
    else
        float.Visible = false
    end
end
hideBtn.Activated:Connect(function() setMainVisible(false) end)
float.Activated:Connect(function() setMainVisible(true) end)
shaderBtn.Activated:Connect(function()
    shader.Visible = not shader.Visible
end)
shHide.Activated:Connect(function() shader.Visible = false end)

-- Standalone functions: only client-side visual/audio settings; no egg-hub dependency.
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local optimizationLevel = 0 -- 0=normal, 1=Fix Lag, 2=Super Fix Lag
local savedProps = setmetatable({}, {__mode = "k"})
local savedLighting = {}
local savedTerrain = {}
local soundSaved = setmetatable({}, {__mode = "k"})
local muted = false
local soundAddedConnection
local shaderObjects = {}

local function saveProperty(obj, prop)
    if not obj then return end
    savedProps[obj] = savedProps[obj] or {}
    if savedProps[obj][prop] == nil then
        local ok, value = pcall(function() return obj[prop] end)
        if ok then savedProps[obj][prop] = value end
    end
end
local function setSaved(obj, prop, value)
    saveProperty(obj, prop)
    pcall(function() obj[prop] = value end)
end
local function saveLightingProp(prop)
    if savedLighting[prop] == nil then
        local ok, value = pcall(function() return Lighting[prop] end)
        if ok then savedLighting[prop] = value end
    end
end
local function optimizeVisuals(level)
    if level == 0 then
        -- Trung hòa modifier FPSBoost của LightingController nếu game hỗ trợ.
        pcall(function()
            local controller = require(game:GetService("ReplicatedStorage").Client.LightingsController)
            controller:SetModifier("FPSBoost", function(original) return original end, 100, 0)
        end)
        for obj, props in pairs(savedProps) do
            if obj and obj.Parent then
                for prop, value in pairs(props) do pcall(function() obj[prop] = value end) end
            end
        end
        table.clear(savedProps)
        for prop, value in pairs(savedLighting) do
            if prop == "__quality" then pcall(function() settings().Rendering.QualityLevel = value end)
            elseif prop == "__physics" then pcall(function() settings().Physics.PhysicsEnvironmentalThrottle = value end)
            elseif prop == "__savedQuality" then pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = value end)
            else pcall(function() Lighting[prop] = value end) end
        end
        table.clear(savedLighting)
        for prop, value in pairs(savedTerrain) do if Terrain then pcall(function() Terrain[prop] = value end) end end
        table.clear(savedTerrain)
        optimizationLevel = 0
        return
    end
    saveLightingProp("GlobalShadows")
    saveLightingProp("FogEnd")
    saveLightingProp("Brightness")
    saveLightingProp("Technology")
    saveLightingProp("Ambient")
    saveLightingProp("OutdoorAmbient")
    pcall(function()
        if savedLighting.__quality == nil then savedLighting.__quality = settings().Rendering.QualityLevel end
        if savedLighting.__physics == nil then savedLighting.__physics = settings().Physics.PhysicsEnvironmentalThrottle end
        if savedLighting.__savedQuality == nil then savedLighting.__savedQuality = UserSettings():GetService("UserGameSettings").SavedQualityLevel end
    end)
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function() settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Always end)
    pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 end)
    pcall(function() Lighting.Technology = Enum.Technology.Compatibility end)
    pcall(function() Lighting.GlobalShadows = false end)
    pcall(function() Lighting.FogEnd = 100000 end)
    if level >= 2 then pcall(function() Lighting.Brightness = math.max(Lighting.Brightness, 2) end) end
    if Terrain then
        for _, prop in ipairs({"WaterWaveSize", "WaterWaveSpeed", "WaterReflectance", "WaterTransparency", "Decoration"}) do
            if savedTerrain[prop] == nil then pcall(function() savedTerrain[prop] = Terrain[prop] end) end
        end
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
        pcall(function() Terrain.WaterTransparency = 1 end)
        if level >= 2 then pcall(function() Terrain.Decoration = false end) end
    end
    for _, obj in ipairs(Lighting:GetDescendants()) do
        if obj:IsA("PostEffect") then setSaved(obj, "Enabled", false) end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            setSaved(obj, "Enabled", false)
        elseif level >= 2 and (obj:IsA("Decal") or obj:IsA("Texture")) then
            setSaved(obj, "Transparency", 1)
        elseif level >= 2 and obj:IsA("BasePart") then
            setSaved(obj, "CastShadow", false)
            if obj.Material ~= Enum.Material.Plastic and obj.Material ~= Enum.Material.SmoothPlastic then
                setSaved(obj, "Material", Enum.Material.Plastic)
            end
        end
    end
    optimizationLevel = level
end

-- Source gốc thứ 3: v4720(p1045), đổi giới hạn FPS 240/60 nếu môi trường có helper.
local fpsCapEnabled = false
-- Source gốc thứ 2: lõi v489() của Tăng FPS, tách khỏi các helper riêng của hub.
-- Không gọi các hàm ẩn plot/pet/egg của hub vì chúng phụ thuộc module nội bộ.
local function sourceFPSBoost()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 end)
    pcall(function()
        local lightingController = require(game:GetService("ReplicatedStorage").Client.LightingsController)
        lightingController:SetModifier("FPSBoost", function(original)
            local modified = table.clone(original)
            modified.Bloom = nil
            modified.ColorCorrection = nil
            modified.SunRays = nil
            modified.DepthOfField = nil
            modified.Blur = nil
            modified.Clouds = nil
            modified.Atmosphere = nil
            modified.ShadowSoftness = 1
            return modified
        end, 100, 0)
    end)
    saveLightingProp("GlobalShadows")
    saveLightingProp("Technology")
    saveLightingProp("FogEnd")
    saveLightingProp("Brightness")
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.Technology = Enum.Technology.Compatibility
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 2
    end)
    if Terrain then
        for _, prop in ipairs({"WaterWaveSize", "WaterWaveSpeed", "WaterReflectance", "WaterTransparency", "Decoration"}) do
            if savedTerrain[prop] == nil then pcall(function() savedTerrain[prop] = Terrain[prop] end) end
        end
        pcall(function()
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
            Terrain.Decoration = false
        end)
    end
    pcall(function()
        local debris = Workspace:FindFirstChild("__DEBRIS")
        if debris then
            for _, child in ipairs(debris:GetChildren()) do
                if child.Name == "PlayerTrap" then child:Destroy() end
            end
        end
    end)
end

local function setFpsCap(enabled)
    fpsCapEnabled = enabled == true
    local ok = false
    pcall(function()
        local env = (getgenv and getgenv()) or _G
        local cap = env.__SenaV4SetCapFps
        if type(cap) == "function" then
            cap(fpsCapEnabled and 240 or 60)
            ok = true
        end
    end)
    -- Delta/executor may expose its own FPS cap function instead of the hub helper.
    if not ok then
        pcall(function()
            if type(setfpscap) == "function" then
                setfpscap(fpsCapEnabled and 240 or 60)
                ok = true
            end
        end)
    end
    capBtn.Text = fpsCapEnabled and "🎯  BỎ GIỚI HẠN FPS: ON" or "🎯  BỎ GIỚI HẠN FPS: OFF"
    capBtn.BackgroundColor3 = fpsCapEnabled and Color3.fromRGB(153, 111, 43) or Color3.fromRGB(105, 83, 39)
    return ok
end

local function muteSound(sound)
    if not sound:IsA("Sound") then return end
    if soundSaved[sound] == nil then soundSaved[sound] = sound.Volume end
    pcall(function() sound.Volume = 0 end)
end
local function setMuted(on)
    muted = on
    if on then
        for _, obj in ipairs(game:GetDescendants()) do if obj:IsA("Sound") then muteSound(obj) end end
        if soundAddedConnection then soundAddedConnection:Disconnect() end
        soundAddedConnection = game.DescendantAdded:Connect(function(obj)
            if muted and obj:IsA("Sound") then task.defer(function() if muted and obj.Parent then muteSound(obj) end end) end
        end)
        muteBtn.Text = "🔇  TẮT ÂM THANH  :  ON"
        muteBtn.BackgroundColor3 = Color3.fromRGB(158, 58, 77)
        status.Text = "Đã tắt âm thanh local"
    else
        if soundAddedConnection then soundAddedConnection:Disconnect(); soundAddedConnection = nil end
        for sound, volume in pairs(soundSaved) do if sound and sound.Parent then pcall(function() sound.Volume = volume end) end end
        table.clear(soundSaved)
        muteBtn.Text = "🔇  TẮT ÂM THANH  :  OFF"
        muteBtn.BackgroundColor3 = Color3.fromRGB(29, 105, 91)
        status.Text = "Đã khôi phục âm lượng"
    end
end

local shaderPresets = {
    ["Tự nhiên"] = {tint=Color3.fromRGB(245,255,238), sat=0.04, con=0.01, bright=0},
    ["Rực rỡ"] = {tint=Color3.fromRGB(226,255,246), sat=0.20, con=0.05, bright=0},
    ["Điện ảnh"] = {tint=Color3.fromRGB(226,220,255), sat=0.10, con=0.10, bright=-0.01},
    ["Ấm áp"] = {tint=Color3.fromRGB(255,232,204), sat=0.12, con=0.04, bright=0.01},
    ["Xanh lạnh"] = {tint=Color3.fromRGB(215,237,255), sat=0.08, con=0.06, bright=0},
    ["Sáng rõ"] = {tint=Color3.fromRGB(255,255,238), sat=0.03, con=0.02, bright=0.02}
}
local function clearShader()
    for _, obj in ipairs(shaderObjects) do pcall(function() obj:Destroy() end) end
    table.clear(shaderObjects)
end
applyShader = function()
    clearShader()
    if not shaderOn then return end
    local camera = Workspace.CurrentCamera
    if not camera then
        status.Text = "Shader lỗi: chưa có CurrentCamera"
        return
    end
    local preset = shaderPresets[selectedPreset] or shaderPresets["Rực rỡ"]
    -- Low-heat mode: color correction only; no Bloom/SunRays post-processing.
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "NK_UtraFixLag_Color"
    cc.Enabled = true
    cc.TintColor, cc.Saturation, cc.Contrast, cc.Brightness = preset.tint, preset.sat, preset.con, preset.bright
    cc.Parent = camera
    table.insert(shaderObjects, cc)
end

-- Source gốc thứ 1: v390() = Tăng tốc khi khởi chạy, đổi tên thành Fix Lag.
-- Tắt mặc định; chỉ chạy khi người dùng bấm. Standalone dùng phần tối ưu đồ họa tương ứng
-- vì v390 nguyên bản gọi thêm v412/v416/v396/v401/v406/v417 và t15 của hub.
fixBtn.Activated:Connect(function()
    if optimizationLevel == 1 then
        optimizeVisuals(0)
        fixBtn.Text = "⚡  FIX LAG"
        status.Text = "Fix Lag đã tắt • đã khôi phục đồ họa"
    else
        optimizeVisuals(2)
        optimizationLevel = 1
        fixBtn.Text = "⚡  FIX LAG: ON"
        superBtn.Text = "🚀  SIÊU FIX LAG"
        status.Text = "Fix Lag bật • tối ưu kiểu v390()"
    end
end)

-- Siêu Fix Lag: lõi FPS của v489(), chỉ chạy theo nút bấm.
superBtn.Activated:Connect(function()
    if optimizationLevel == 2 then
        optimizeVisuals(0)
        optimizationLevel = 0
        fixBtn.Text = "⚡  FIX LAG"
        superBtn.Text = "🚀  SIÊU FIX LAG"
        status.Text = "Siêu Fix Lag đã tắt • đã khôi phục đồ họa"
    else
        if optimizationLevel ~= 0 then optimizeVisuals(0) end
        optimizeVisuals(1)
        sourceFPSBoost()
        optimizationLevel = 2
        fixBtn.Text = "⚡  FIX LAG"
        superBtn.Text = "🚀  SIÊU FIX LAG: ON"
        status.Text = "Siêu Fix Lag bật • lõi tăng FPS v489() đã áp dụng"
    end
end)

capBtn.Activated:Connect(function()
    local ok = setFpsCap(not fpsCapEnabled)
    status.Text = ok and (fpsCapEnabled and "Đã đặt FPS cap 240" or "Đã đặt FPS cap 60") or "Executor không hỗ trợ helper đặt FPS cap này"
end)

muteBtn.Activated:Connect(function() setMuted(not muted) end)

shToggle.Activated:Connect(function()
    shaderOn = not shaderOn
    shToggle.Text = "HIỆU ỨNG: " .. (shaderOn and "ON" or "OFF")
    shToggle.BackgroundColor3 = shaderOn and Color3.fromRGB(105, 63, 150) or Color3.fromRGB(62, 67, 83)
    applyShader()
    status.Text = shaderOn and ("Shader bật: " .. selectedPreset) or "Shader đã tắt"
end)


-- Drag support: header and floating button, mouse + touch
local function makeDraggable(handle, target, ignoreButton)
    local dragging = false
    local dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if ignoreButton and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local p = input.Position
                if hideBtn.Visible and p.X >= hideBtn.AbsolutePosition.X and p.X <= hideBtn.AbsolutePosition.X + hideBtn.AbsoluteSize.X and p.Y >= hideBtn.AbsolutePosition.Y and p.Y <= hideBtn.AbsolutePosition.Y + hideBtn.AbsoluteSize.Y then return end
            end
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(header, main, true)
makeDraggable(shHead, shader, false)
makeDraggable(float, float, false)

-- Initial labels
for preset, btn in pairs(presetButtons) do
    btn.Text = (preset == selectedPreset and "✓ " or "") .. preset
end


Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if shaderOn then
        task.defer(function()
            if shaderOn then applyShader() end
        end)
    end
end)

-- Cleanup local visual effects when this GUI is destroyed.
gui.Destroying:Connect(function()
    if fpsConnection then fpsConnection:Disconnect() end
    pcall(clearShader)
    if muted then pcall(function() setMuted(false) end) end
    if optimizationLevel > 0 then pcall(function() optimizeVisuals(0) end) end
    if fpsCapEnabled then pcall(function() setFpsCap(false) end) end
end)
