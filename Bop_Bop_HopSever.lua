-- Bop Bop HopSever
-- Delta/executor Lua: light sea-blue GUI, announcement audio, then server hop.
-- Note: raw GitHub images/audio must be downloaded locally and converted to executor assets.

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

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function cleanup()
    alive = false
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    table.clear(connections)
end
connect(gui.Destroying, cleanup)

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(310, 166)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(173, 225, 245)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(76, 175, 215)
stroke.Thickness = 2
stroke.Parent = main

local scale = Instance.new("UIScale")
scale.Scale = 0.85
scale.Parent = main

-- Decorative image: loaded from the user's raw GitHub file when executor file APIs exist.
local imageUrl = "https://raw.githubusercontent.com/khanhdep41-tech/Nam-Khanh/refs/heads/main/IMG_8231.jpeg"
local imageFile = "bop_bop_hopserver_image.jpeg"
local image = Instance.new("ImageLabel")
image.Name = "BackgroundImage"
image.Size = UDim2.new(1, 0, 1, 0)
image.Position = UDim2.fromOffset(0, 0)
image.BackgroundTransparency = 1
image.ImageTransparency = 0.45
image.ScaleType = Enum.ScaleType.Crop
image.ZIndex = 1
image.Parent = main
Instance.new("UICorner", image).CornerRadius = UDim.new(0, 16)

local function getAsset(url, filename)
    if type(isfile) ~= "function" or type(writefile) ~= "function"
        or type(getcustomasset) ~= "function" then
        return nil
    end
    local ok, asset = pcall(function()
        if not isfile(filename) then
            local data = game:HttpGet(url)
            writefile(filename, data)
        end
        return getcustomasset(filename)
    end)
    if ok then return asset end
    warn("[Bop Bop HopSever] Không tải được asset: " .. tostring(asset))
    return nil
end

task.spawn(function()
    local asset = getAsset(imageUrl, imageFile)
    if asset and alive then image.Image = asset end
end)

local function round(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
end

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(10, 7)
title.Size = UDim2.new(1, -20, 0, 30)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Bop Bop HopSever"
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(18, 73, 100)
title.ZIndex = 3
title.Parent = main

local count = Instance.new("TextLabel")
count.Name = "PlayerCount"
count.Position = UDim2.fromOffset(12, 42)
count.Size = UDim2.new(1, -24, 0, 28)
count.BackgroundColor3 = Color3.fromRGB(126, 205, 232)
count.BackgroundTransparency = 0.12
count.Font = Enum.Font.GothamBold
count.Text = "MÁY CHỦ HIỆN TẠI: 0 NGƯỜI"
count.TextSize = 12
count.TextColor3 = Color3.fromRGB(18, 73, 100)
count.ZIndex = 3
count.Parent = main
round(count, 9)

local button = Instance.new("TextButton")
button.Name = "HopButton"
button.Position = UDim2.fromOffset(12, 78)
button.Size = UDim2.new(1, -24, 0, 72)
button.BackgroundColor3 = Color3.fromRGB(95, 185, 225)
button.BorderSizePixel = 0
button.Font = Enum.Font.GothamBold
button.Text = "Chan Bố Mày Đê"
button.TextSize = 18
button.TextWrapped = true
button.TextColor3 = Color3.new(1, 1, 1)
button.AutoButtonColor = true
button.ZIndex = 3
button.Parent = main
round(button, 12)

local function updateCount()
    if alive then
        count.Text = "MÁY CHỦ HIỆN TẠI: " .. tostring(#Players:GetPlayers()) .. " NGƯỜI"
    end
end
updateCount()
connect(Players.PlayerAdded, updateCount)
connect(Players.PlayerRemoving, updateCount)

-- Download the MP3 to a local executor asset. Roblox SoundId cannot use a raw GitHub URL directly.
local soundUrl = "https://raw.githubusercontent.com/khanhdep41-tech/Nam-Khanh/refs/heads/main/chao_mung_chuyen_bay_vietnam.mp3"
local soundFile = "chao_mung_chuyen_bay_vietnam.mp3"
local announcement = Instance.new("Sound")
announcement.Name = "HopAnnouncement"
announcement.Volume = 1
announcement.Parent = SoundService

task.spawn(function()
    local asset = getAsset(soundUrl, soundFile)
    if asset and alive then
        announcement.SoundId = asset
        pcall(function() announcement.Loaded:Wait() end)
    else
        warn("[Bop Bop HopSever] Không nạp được MP3; kiểm tra URL và quyền tải file.")
    end
end)

-- Drag the panel by dragging its title.
local dragging, dragInput, dragStart, startPos
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
    local moving = (input.UserInputType == Enum.UserInputType.MouseMovement)
        or (input.UserInputType == Enum.UserInputType.Touch and input == dragInput)
    if moving then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
connect(UserInputService.InputEnded, function(input)
    if input == dragInput then dragging = false; dragInput = nil end
end)

local function findServer()
    local cursor, seen = nil, {}
    for page = 1, 8 do
        if not alive then return nil end
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId
            .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor then url = url .. "&cursor=" .. HttpService:UrlEncode(cursor) end
        local ok, raw = pcall(function() return game:HttpGet(url) end)
        if not ok then
            warn("[Bop Bop HopSever] Lỗi lấy server: " .. tostring(raw))
            return nil
        end
        local decodedOk, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not decodedOk or type(data) ~= "table" or type(data.data) ~= "table" then
            return nil
        end
        local candidates = {}
        for _, server in ipairs(data.data) do
            if type(server.id) == "string" and server.id ~= game.JobId
                and not seen[server.id] and tonumber(server.playing) == 1
                and tonumber(server.maxPlayers) and server.maxPlayers > server.playing then
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
    button.Text = "ĐANG CHUYỂN SERVER..."
    button.AutoButtonColor = false
    task.spawn(function()
        local serverId = findServer()
        if alive and serverId then
            local ok, err = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, player)
            end)
            if not ok then warn("[Bop Bop HopSever] Teleport lỗi: " .. tostring(err)) end
        elseif alive then
            button.Text = "KHÔNG TÌM THẤY SERVER - BẤM LẠI"
            hopping = false
            button.AutoButtonColor = true
        end
    end)
end

connect(button.Activated, function()
    if not alive or hopping or audioWaiting then return end
    audioWaiting = true
    button.Text = "ĐANG TẢI ÂM THANH..."
    button.AutoButtonColor = false

    task.spawn(function()
        -- Give the startup asset loader time to finish.
        local waited = 0
        while alive and announcement.SoundId == "" and waited < 8 do
            task.wait(0.2)
            waited += 0.2
        end

        local played = false
        if alive and announcement.SoundId ~= "" then
            button.Text = "ĐANG PHÁT THÔNG BÁO..."
            local ok, err = pcall(function()
                announcement:Stop()
                announcement.TimePosition = 0
                announcement:Play()
                if not announcement.IsLoaded then
                    announcement.Loaded:Wait()
                end
                -- Wait for playback to finish before hopping.
                announcement.Ended:Wait()
            end)
            played = ok
            if not ok then
                warn("[Bop Bop HopSever] Lỗi phát MP3: " .. tostring(err))
            end
        else
            warn("[Bop Bop HopSever] MP3 chưa tải được; kiểm tra link và executor.")
        end

        audioWaiting = false
        if alive and not hopping then
            if not played then
                button.Text = "ĐANG CHUYỂN SERVER..."
            end
            hopNow()
        end
    end)
end)

-- Re-execute after teleport when supported by the executor.
local queueFn = queue_on_teleport or queueonteleport or queueteleport
if type(queueFn) == "function" then
    pcall(function()
        queueFn('loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhdep41-tech/chuyen-sv/refs/heads/main/Bop_Bop_HopSever.lua"))()')
    end)
end

print("[Bop Bop HopSever] GUI đã khởi động.")
