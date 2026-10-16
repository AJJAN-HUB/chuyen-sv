-- Nhat Khanh UtraFixLag - GUI ONLY
-- Giao dien thuan tuy: khong chua hack/gameplay functions va khong tai source ben ngoai.
-- Cac nut hien chi doi trang thai giao dien; can noi logic rieng neu muon chuc nang that.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
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
main.Size = UDim2.fromOffset(285, 300)
main.Position = UDim2.new(0.5, -142, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(14, 20, 34)
main.BorderSizePixel = 0
main.Active = true
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
local title = label(header, "NHAT KHANH", UDim2.new(1, -90, 0, 20), UDim2.fromOffset(43, 6), 14, Color3.fromRGB(245, 250, 255), Enum.Font.GothamBold)
local subtitle = label(header, "UTRA FIX LAG  •  BẢNG ĐIỀU KHIỂN", UDim2.new(1, -55, 0, 14), UDim2.fromOffset(43, 25), 8, Color3.fromRGB(145, 188, 220), Enum.Font.Gotham)
local hideBtn = button(header, "—", UDim2.fromOffset(28, 28), UDim2.new(1, -35, 0, 10), Color3.fromRGB(48, 70, 101))
hideBtn.TextSize = 18

label(main, "CHỨC NĂNG", UDim2.new(1, -28, 0, 18), UDim2.fromOffset(14, 64), 10, Color3.fromRGB(125, 170, 205), Enum.Font.GothamBold)

local fixBtn = button(main, "⚡  FIX LAG", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 87), Color3.fromRGB(29, 87, 133))
local superBtn = button(main, "🚀  SIÊU FIX LAG", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 132), Color3.fromRGB(78, 58, 135))
local muteBtn = button(main, "🔇  TẮT ÂM THANH  :  OFF", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 177), Color3.fromRGB(29, 105, 91))
local shaderBtn = button(main, "🎨  MỞ BẢNG SHADER", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 222), Color3.fromRGB(111, 61, 135))
local status = label(main, "Trạng thái: chỉ giao diện", UDim2.new(1, -28, 0, 18), UDim2.fromOffset(14, 266), 10, Color3.fromRGB(145, 188, 220), Enum.Font.Gotham)

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
        status.Text = "Đã chọn giao diện: " .. selectedPreset
    end)
end
local shNote = label(shader, "Ẩn bảng không tắt hiệu ứng.", UDim2.new(1, -20, 0, 20), UDim2.fromOffset(10, 239), 9, Color3.fromRGB(153, 166, 194), Enum.Font.Gotham)

-- Floating reopen button, draggable on touch/mouse
local float = button(gui, "N", UDim2.fromOffset(48, 48), UDim2.new(0, 18, 0.55, 0), Color3.fromRGB(25, 95, 145))
float.Name = "NhatKhanhFloatingButton"
float.TextSize = 22
float.Font = Enum.Font.GothamBlack
float.Visible = false
corner(float, 24)
stroke(float, Color3.fromRGB(98, 225, 255), 1.5, 0.05)

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

fixBtn.Activated:Connect(function()
    status.Text = "FIX LAG: nút giao diện (chưa nối chức năng)"
end)
superBtn.Activated:Connect(function()
    status.Text = "SIÊU FIX LAG: nút giao diện (chưa nối chức năng)"
end)
muteBtn.Activated:Connect(function()
    local on = muteBtn:GetAttribute("ToggleOn") ~= true
    muteBtn:SetAttribute("ToggleOn", on)
    muteBtn.Text = "🔇  TẮT ÂM THANH  :  " .. (on and "ON" or "OFF")
    muteBtn.BackgroundColor3 = on and Color3.fromRGB(20, 145, 105) or Color3.fromRGB(29, 105, 91)
    status.Text = "Mute: chỉ đổi trạng thái giao diện"
end)
shToggle.Activated:Connect(function()
    shaderOn = not shaderOn
    shToggle.Text = "HIỆU ỨNG: " .. (shaderOn and "ON" or "OFF")
    shToggle.BackgroundColor3 = shaderOn and Color3.fromRGB(105, 63, 150) or Color3.fromRGB(62, 67, 83)
    status.Text = shaderOn and ("Shader UI ON: " .. selectedPreset) or "Shader UI OFF"
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
