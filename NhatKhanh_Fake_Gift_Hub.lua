-- NhatKhanh Fake Gift Hub - Steal an Egg
-- Demo GUI only. Does not send gifts, call game remotes, or modify inventory.
-- Run in a Roblox Lua environment for a standalone UI preview.
-- Pet names are demo placeholders unless you replace them with names you can verify.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("NhatKhanhFakeGiftHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "NhatKhanhFakeGiftHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local purple = Color3.fromRGB(113, 61, 174)
local dark = Color3.fromRGB(24, 18, 34)
local panel = Color3.fromRGB(38, 29, 52)
local cardColor = Color3.fromRGB(49, 37, 67)
local pale = Color3.fromRGB(239, 220, 255)
local muted = Color3.fromRGB(180, 164, 199)
local gold = Color3.fromRGB(255, 218, 115)

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or purple
    s.Thickness = thickness or 1
    s.Parent = parent
end

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local mutationNames = {
    "Rainbow", "Fractured", "Golden", "Scrambled",
    "Enchanted", "Nitro", "Parasite", "Spirit Bloom"
}

-- Demo list of 200 distinct display cards.
-- Replace these placeholders with verified inventory names when building a legitimate
-- UI for your own game. The script deliberately does not inspect or alter game inventory.
local baseNames = {
    "Kitsune", "Dragon", "Phoenix", "Fox", "Shadow Beast",
    "Crystal Serpent", "Moon Cat", "Spirit Wolf", "Celestial Bird", "Void Dragon",
    "Golden Lynx", "Frost Kitsune", "Ember Fox", "Storm Drake", "Mystic Hare",
    "Star Phoenix", "Night Panther", "Solar Tiger", "Dream Whale", "Ancient Turtle"
}

local rng = Random.new()
local pets = {}
for i = 1, 200 do
    local baseName = baseNames[((i - 1) % #baseNames) + 1]
    local weight = rng:NextInteger(500000, 50000000)
    -- Synthetic demo rate only; no game price formula is claimed.
    local demoRate = rng:NextNumber(1, 5)
    pets[i] = {
        name = baseName .. (i > #baseNames and (" #" .. tostring(i)) or ""),
        weight = weight,
        rate = math.floor(demoRate * 10 + 0.5) / 10,
        mutations = mutationNames,
    }
end

local main = make("Frame", {
    Name = "Main", Size = UDim2.fromScale(0.76, 0.82),
    Position = UDim2.fromScale(0.12, 0.09),
    BackgroundColor3 = dark, BorderSizePixel = 0,
}, gui)
corner(main, 14)
stroke(main, purple, 2)

local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = purple,
    BorderSizePixel = 0,
}, main)
corner(top, 14)
local topMask = make("Frame", {
    Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = purple, BorderSizePixel = 0,
}, top)

make("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 14, 0, 0),
    Size = UDim2.new(1, -100, 1, 0), Font = Enum.Font.GothamBold,
    Text = "NhatKhanh • Fake Gift Hub", TextColor3 = Color3.new(1,1,1),
    TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local close = make("TextButton", {
    Size = UDim2.fromOffset(34, 30), Position = UDim2.new(1, -42, 0, 9),
    BackgroundColor3 = Color3.fromRGB(83, 43, 112), Text = "×",
    TextColor3 = Color3.new(1,1,1), TextSize = 22, Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
}, top)
corner(close, 8)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local recipient = make("TextBox", {
    Name = "Recipient", Position = UDim2.new(0, 12, 0, 60),
    Size = UDim2.new(0.43, -8, 0, 34), BackgroundColor3 = panel,
    Text = "", PlaceholderText = "Gift to @username (demo)",
    TextColor3 = pale, PlaceholderColor3 = muted, TextSize = 13,
    Font = Enum.Font.Gotham, ClearTextOnFocus = false, BorderSizePixel = 0,
}, main)
corner(recipient, 8)
stroke(recipient, Color3.fromRGB(82, 61, 108), 1)

local search = make("TextBox", {
    Name = "Search", Position = UDim2.new(0.43, 4, 0, 60),
    Size = UDim2.new(0.57, -16, 0, 34), BackgroundColor3 = panel,
    Text = "", PlaceholderText = "Search pet...",
    TextColor3 = pale, PlaceholderColor3 = muted, TextSize = 13,
    Font = Enum.Font.Gotham, ClearTextOnFocus = false, BorderSizePixel = 0,
}, main)
corner(search, 8)
stroke(search, Color3.fromRGB(82, 61, 108), 1)

local scroll = make("ScrollingFrame", {
    Name = "PetList", Position = UDim2.new(0, 12, 0, 104),
    Size = UDim2.new(1, -24, 1, -164), BackgroundColor3 = panel,
    BorderSizePixel = 0, ScrollBarThickness = 6,
    ScrollBarImageColor3 = Color3.fromRGB(176, 120, 235),
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, main)
corner(scroll, 10)

local grid = make("UIGridLayout", {
    CellSize = UDim2.new(0, 150, 0, 205),
    CellPadding = UDim2.fromOffset(8, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, scroll)
make("UIPadding", {
    PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
}, scroll)

local selectedCard = nil
local selectedCount = 0
local giftButton = make("TextButton", {
    Name = "FakeGiftButton", Position = UDim2.new(0, 12, 1, -50),
    Size = UDim2.new(1, -24, 0, 38), BackgroundColor3 = purple,
    Text = "FAKE GIFT (0)", TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold, TextSize = 15, BorderSizePixel = 0,
}, main)
corner(giftButton, 9)

local status = make("TextLabel", {
    Name = "Status", Position = UDim2.new(0, 12, 1, -74),
    Size = UDim2.new(1, -24, 0, 18), BackgroundTransparency = 1,
    Text = "Demo only • No real pet transfer", TextColor3 = muted,
    Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center,
}, main)

local cards = {}
local function makeCard(pet, index)
    local card = make("TextButton", {
        Name = "PetCard" .. index, BackgroundColor3 = cardColor,
        Text = "", BorderSizePixel = 0, LayoutOrder = index,
        AutoButtonColor = false,
    }, scroll)
    corner(card, 9)
    stroke(card, Color3.fromRGB(82, 61, 108), 1)

    local muts = make("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 5, 0, 4),
        Size = UDim2.new(1, -10, 0, 42), Font = Enum.Font.Gotham,
        Text = table.concat(pet.mutations, " · "), TextColor3 = pale,
        TextSize = 8, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
    }, card)

    local icon = make("Frame", {
        Position = UDim2.new(0.5, -37, 0, 49), Size = UDim2.fromOffset(74, 68),
        BackgroundColor3 = Color3.fromRGB(69, 48, 90), BorderSizePixel = 0,
    }, card)
    corner(icon, 9)
    make("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
        Text = "🐾", TextSize = 35, Font = Enum.Font.Gotham,
    }, icon)

    make("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 4, 0, 120),
        Size = UDim2.new(1, -8, 0, 22), Font = Enum.Font.GothamBold,
        Text = pet.name, TextColor3 = Color3.new(1,1,1),
        TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd,
    }, card)

    make("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 4, 0, 143),
        Size = UDim2.new(1, -8, 0, 25), Font = Enum.Font.GothamBold,
        Text = string.format("%.1fT/s", pet.rate), TextColor3 = gold,
        TextSize = 18,
    }, card)

    make("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 4, 0, 170),
        Size = UDim2.new(1, -8, 0, 17), Font = Enum.Font.Gotham,
        Text = string.format("Weight: %s kg", string.format("%d", pet.weight)),
        TextColor3 = muted, TextSize = 9,
    }, card)

    local mark = make("TextLabel", {
        Name = "SelectedMark", BackgroundColor3 = purple,
        Position = UDim2.new(1, -25, 1, -25), Size = UDim2.fromOffset(20, 20),
        Text = "✓", TextColor3 = Color3.new(1,1,1), TextSize = 13,
        Font = Enum.Font.GothamBold, Visible = false, BorderSizePixel = 0,
    }, card)
    corner(mark, 10)

    card.MouseButton1Click:Connect(function()
        if selectedCard and selectedCard ~= card then
            selectedCard.BackgroundColor3 = cardColor
            selectedCard:FindFirstChild("SelectedMark").Visible = false
        end
        if selectedCard == card then
            selectedCard = nil
            mark.Visible = false
            card.BackgroundColor3 = cardColor
        else
            selectedCard = card
            mark.Visible = true
            card.BackgroundColor3 = Color3.fromRGB(75, 48, 103)
        end
        selectedCount = selectedCard and 1 or 0
        giftButton.Text = "FAKE GIFT (" .. selectedCount .. ")"
    end)
    cards[#cards + 1] = {card = card, pet = pet}
end

for i, pet in ipairs(pets) do makeCard(pet, i) end

local function applySearch()
    local query = string.lower(search.Text or "")
    for _, entry in ipairs(cards) do
        entry.card.Visible = query == "" or string.find(string.lower(entry.pet.name), query, 1, true) ~= nil
    end
end
search:GetPropertyChangedSignal("Text"):Connect(applySearch)

giftButton.MouseButton1Click:Connect(function()
    if not selectedCard then
        status.Text = "Select one demo pet first."
        return
    end
    local name = recipient.Text
    if name == "" then name = "@username" end
    status.Text = "Fake gift success to " .. name .. " • no game data changed."
end)

-- Drag window by the top bar.
local dragging, dragInput, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
top.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("NhatKhanh Fake Gift Hub loaded. Demo only; no real gifting or inventory changes.")
