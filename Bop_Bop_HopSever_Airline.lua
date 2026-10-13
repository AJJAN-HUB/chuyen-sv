--==================================================
-- BOP BOP HOPSERVER - AIRLINE NEON EDITION
-- Delta Mobile / Roblox
--==================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local GUI_NAME = "BopBopHopServer"

local old = playerGui:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

local alive, hopping, audioWaiting = true, false, false
local connections = {}

local function connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(connections, c)
    return c
end

local function cleanup()
    alive = false
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(connections)
end

local function round(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
end

local function addStroke(object, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Parent = object
    return stroke
end

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = playerGui
connect(gui.Destroying, cleanup)

-- Main panel
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(430, 245)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(8, 19, 42)
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui
round(main, 20)

local panelStroke = addStroke(main, Color3.fromRGB(100, 220, 255), 3)
local panelGradient = Instance.new("UIGradient")
panelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 65, 125)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 35, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 100, 155))
})
panelGradient.Parent = main

-- Responsive sizing for phone screens
local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    local scale = math.min(1, (viewport.X - 24) / 430, (viewport.Y - 24) / 245)
    main.Size = UDim2.fromOffset(430, 245)
    local uiScale = main:FindFirstChildOfClass("UIScale")
    if not uiScale then
        uiScale = Instance.new("UIScale")
        uiScale.Parent = main
    end
    uiScale.Scale = math.max(0.55, scale)
end
updateScale()

-- Asset loader: executor file APIs are optional
local function getAsset(url, filename)
    if type(isfile) ~= "function"
        or type(writefile) ~= "function"
        or type(getcustomasset) ~= "function" then
        return nil
    end
    local ok, result = pcall(function()
        if not isfile(filename) then
            local data = game:HttpGet(url)
            writefile(filename, data)
        end
        return getcustomasset(filename)
    end)
    if ok then return result end
    warn("[BOP HOP] Asset error: " .. tostring(result))
    return nil
end

-- Full image (Fit prevents cropping)
local image = Instance.new("ImageLabel")
image.Name = "CharacterImage"
image.Position = UDim2.fromOffset(12, 45)
image.Size = UDim2.fromOffset(132, 185)
image.BackgroundColor3 = Color3.fromRGB(15, 35, 65)
image.ScaleType = Enum.ScaleType.Fit
image.ZIndex = 3
image.Parent = main
round(image, 14)
local imageStroke = addStroke(image, Color3.fromRGB(100, 220, 255), 2)

local imageUrl = "https://raw.githubusercontent.com/khanhdep41-tech/Nam-Khanh/refs/heads/main/IMG_8231.jpeg"
task.spawn(function()
    local asset = getAsset(imageUrl, "bop_bop_hopserver_image.jpeg")
    if alive and asset then image.Image = asset end
end)

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(152, 10)
title.Size = UDim2.new(1, -164, 0, 40)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.Text = "✈ AIRLINE HOP ✈"
title.TextSize = 22
title.TextWrapped = true
title.TextColor3 = Color3.fromRGB(170, 235, 255)
title.ZIndex = 4
title.Parent = main

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 190, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 220, 255))
})
titleGradient.Parent = title

local planeIcon = Instance.new("TextLabel")
planeIcon.Name = "PlaneIcon"
planeIcon.Position = UDim2.new(1, -42, 0, 7)
planeIcon.Size = UDim2.fromOffset(34, 34)
planeIcon.BackgroundTransparency = 1
planeIcon.Text = "✈"
planeIcon.TextSize = 27
planeIcon.TextColor3 = Color3.fromRGB(150, 225, 255)
planeIcon.ZIndex = 5
planeIcon.Parent = main

-- Player count
local count = Instance.new("TextLabel")
count.Name = "PlayerCount"
count.Position = UDim2.fromOffset(152, 54)
count.Size = UDim2.new(1, -164, 0, 34)
count.BackgroundColor3 = Color3.fromRGB(12, 65, 110)
count.BackgroundTransparency = 0.1
count.Font = Enum.Font.GothamBold
count.Text = "✈ SERVER HIỆN TẠI: ..."
count.TextSize = 13
count.TextWrapped = true
count.TextColor3 = Color3.fromRGB(210, 245, 255)
count.ZIndex = 4
count.Parent = main
round(count, 9)
local countStroke = addStroke(count, Color3.fromRGB(70, 180, 255), 1)

-- Hop button
local button = Instance.new("TextButton")
button.Name = "HopButton"
button.Position = UDim2.fromOffset(152, 98)
button.Size = UDim2.new(1, -164, 0, 130)
button.BackgroundColor3 = Color3.fromRGB(10, 100, 185)
button.BorderSizePixel = 0
button.Font = Enum.Font.GothamBlack
button.Text = "✈ TÌM SERVER 1 NGƯỜI CHO BỐ ✈"
button.TextSize = 19
button.TextWrapped = true
button.TextColor3 = Color3.new(1, 1, 1)
button.AutoButtonColor = true
button.ZIndex = 4
button.Parent = main
round(button, 15)
local buttonStroke = addStroke(button, Color3.fromRGB(160, 235, 255), 2)

local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 110, 210)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 185, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 75, 170))
})
buttonGradient.Parent = button

-- Sparkles
local sparkleLayer = Instance.new("Frame")
sparkleLayer.Name = "SparkleLayer"
sparkleLayer.Size = UDim2.fromScale(1, 1)
sparkleLayer.BackgroundTransparency = 1
sparkleLayer.ClipsDescendants = true
sparkleLayer.ZIndex = 6
sparkleLayer.Parent = main

local sparkles = {}
local sparkleSymbols = {"✦", "✧", "⋆", "✦", "·"}
for i = 1, 16 do
    local star = Instance.new("TextLabel")
    star.Name = "Sparkle" .. i
    star.Size = UDim2.fromOffset(18, 18)
    star.Position = UDim2.new(((i * 37) % 95) / 100, 0, ((i * 23) % 90) / 100, 0)
    star.BackgroundTransparency = 1
    star.Text = sparkleSymbols[(i - 1) % #sparkleSymbols + 1]
    star.TextColor3 = i % 2 == 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 220, 255)
    star.TextSize = i % 3 == 0 and 18 or 13
    star.TextTransparency = 0.15
    star.ZIndex = 6
    star.Parent = sparkleLayer
    table.insert(sparkles, star)
end

local trail = Instance.new("TextLabel")
trail.Name = "PlaneTrail"
trail.Size = UDim2.fromOffset(75, 24)
trail.Position = UDim2.new(0, -80, 0, 8)
trail.BackgroundTransparency = 1
trail.Text = "· · · ✈"
trail.TextColor3 = Color3.fromRGB(170, 235, 255)
trail.TextSize = 19
trail.ZIndex = 7
trail.Parent = main

-- Drag panel by title
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
connect(title.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        dragInput = input
    end
end)

connect(UserInputService.InputChanged, function(input)
    if not dragging then return end
    local moving = input.UserInputType == Enum.UserInputType.MouseMovement
        or (input.UserInputType == Enum.UserInputType.Touch and input == dragInput)
    if moving then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

connect(UserInputService.InputEnded, function(input)
    if input == dragInput then
        dragging = false
        dragInput = nil
    end
end)

-- Player count
local function updateCount()
    if alive then
        count.Text = "✈ SERVER HIỆN TẠI: " .. tostring(#Players:GetPlayers()) .. " NGƯỜI"
    end
end
updateCount()
connect(Players.PlayerAdded, updateCount)
connect(Players.PlayerRemoving, updateCount)

-- Audio announcement
local soundUrl = "https://raw.githubusercontent.com/khanhdep41-tech/Nam-Khanh/refs/heads/main/chao_mung_chuyen_bay_vietnam.mp3"
local announcement = Instance.new("Sound")
announcement.Name = "HopAnnouncement"
announcement.Volume = 1
announcement.Looped = false
announcement.Parent = SoundService

task.spawn(function()
    local asset = getAsset(soundUrl, "chao_mung_chuyen_bay_vietnam.mp3")
    if alive and asset then
        announcement.SoundId = asset
        pcall(function()
            if not announcement.IsLoaded then announcement.Loaded:Wait() end
        end)
    else
        warn("[BOP HOP] Không tải được MP3 hoặc executor không hỗ trợ asset API.")
    end
end)

-- Find a public server with exactly one player
local function findServer()
    local cursor
    local seen = {}

    for page = 1, 8 do
        if not alive then return nil end

        local url = "https://games.roblox.com/v1/games/"
            .. game.PlaceId
            .. "/servers/Public?sortOrder=Asc&limit=100"

        if cursor then
            url = url .. "&cursor=" .. HttpService:UrlEncode(cursor)
        end

        local ok, raw = pcall(function()
            return game:HttpGet(url)
        end)
        if not ok then
            warn("[BOP HOP] Lỗi lấy server: " .. tostring(raw))
            return nil
        end

        local decoded, data = pcall(function()
            return HttpService:JSONDecode(raw)
        end)
        if not decoded or type(data) ~= "table" or type(data.data) ~= "table" then
            return nil
        end

        local candidates = {}
        for _, server in ipairs(data.data) do
            if type(server.id) == "string"
                and server.id ~= game.JobId
                and not seen[server.id]
                and tonumber(server.playing) == 1
                and tonumber(server.maxPlayers)
                and server.maxPlayers > server.playing then
                seen[server.id] = true
                table.insert(candidates, server.id)
            end
        end

        if #candidates > 0 then
            return candidates[Random.new():NextInteger(1, #candidates)]
        end

        cursor = data.nextPageCursor
        if not cursor then break end
        task.wait(0.25)
    end

    return nil
end

local function hopNow()
    if not alive or hopping then return end
    hopping = true
    button.Text = "✈ ĐANG TÌM CHUYẾN BAY..."
    button.AutoButtonColor = false

    task.spawn(function()
        local serverId = findServer()
        if alive and serverId then
            button.Text = "✈ ĐANG CHUYỂN SERVER..."
            local ok, err = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, player)
            end)
            if not ok then
                warn("[BOP HOP] Teleport lỗi: " .. tostring(err))
                button.Text = "LỖI TELEPORT - THỬ LẠI"
                hopping = false
                button.AutoButtonColor = true
            end
        elseif alive then
            button.Text = "KHÔNG TÌM THẤY SERVER - BẤM LẠI"
            hopping = false
            button.AutoButtonColor = true
        end
    end)
end

-- Button: play audio, then hop
connect(button.Activated, function()
    if not alive or hopping or audioWaiting then return end

    audioWaiting = true
    button.Text = "✈ ĐANG CHUẨN BỊ CHUYẾN BAY..."
    button.AutoButtonColor = false

    task.spawn(function()
        local waited = 0
        while alive and announcement.SoundId == "" and waited < 8 do
            task.wait(0.2)
            waited += 0.2
        end

        if alive and announcement.SoundId ~= "" then
            button.Text = "✈ ĐANG PHÁT THÔNG BÁO..."
            pcall(function()
                announcement:Stop()
                announcement.TimePosition = 0
                announcement:Play()
                if not announcement.IsLoaded then announcement.Loaded:Wait() end
                announcement.Ended:Wait()
            end)
        end

        audioWaiting = false
        if alive and not hopping then hopNow() end
    end)
end)

-- Animated sky-blue neon and sparkle effects
task.spawn(function()
    local angle, trailX = 0, -80
    while alive and gui.Parent do
        angle = (angle + 2) % 360
        panelGradient.Rotation = angle
        titleGradient.Rotation = -angle
        buttonGradient.Rotation = angle
        planeIcon.Rotation = math.sin(math.rad(angle * 3)) * 12

        for i, star in ipairs(sparkles) do
            star.TextTransparency = 0.1 + (math.sin(math.rad(angle * 2 + i * 35)) + 1) * 0.4
            star.Rotation = angle + i * 17
        end

        trailX += 2
        if trailX > 450 then trailX = -80 end
        trail.Position = UDim2.new(0, trailX, 0, 8)

        task.wait(0.04)
    end
end)

-- Re-execute after teleport if executor supports queue_on_teleport
local queueFn = queue_on_teleport or queueonteleport or queueteleport
if type(queueFn) == "function" then
    pcall(function()
        queueFn('loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhdep41-tech/chuyen-sv/refs/heads/main/Bop_Bop_HopSever_Airline.lua"))()')
    end)
end

print("[BOP HOP] Airline HopServer GUI loaded.")
