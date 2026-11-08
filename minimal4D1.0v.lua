--[[
    779 Minimal UI Library | Minimal 4D GUI v1.0.0
    Single-file client UI for supported Roblox client/executor environments.

    Run this entire file directly once in Solara v3. No ModuleScript,
    require(), LocalScript, or separate loader is needed.

    This is a visual UI framework only. It does not provide game cheats,
    remote-event abuse, anti-cheat bypasses, or exploit functionality.

    Hotkey: Ctrl+K (RightControl also toggles). Public API is exposed as getgenv().Minimal779 when
    the executor provides getgenv(). The demo window starts automatically.
]]

local Library = {}
Library.__index = Library

local function get4DEnvironment()
    local env
    pcall(function()
        if type(getgenv) == "function" then env = getgenv() end
    end)
    return env or _G
end
local M779_ENV = get4DEnvironment()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui
pcall(function()
    CoreGui = game:GetService("CoreGui")
end)

local LocalPlayer = Players.LocalPlayer

local ThemePresets = {
    Midnight = {
        Background = Color3.fromRGB(7, 8, 15),
        Surface = Color3.fromRGB(13, 14, 25),
        Surface2 = Color3.fromRGB(22, 21, 39),
        Surface3 = Color3.fromRGB(30, 27, 49),
        Text = Color3.fromRGB(247, 246, 255),
        Muted = Color3.fromRGB(184, 178, 211),
        Soft = Color3.fromRGB(125, 122, 158),
        Purple = Color3.fromRGB(164, 62, 255),
        Blue = Color3.fromRGB(64, 125, 255),
        Cyan = Color3.fromRGB(30, 220, 255),
        Stroke = Color3.fromRGB(83, 54, 132),
        Good = Color3.fromRGB(76, 231, 159),
        Danger = Color3.fromRGB(255, 88, 133),
        WindowTransparency = 0.035,
        PanelTransparency = 0.02,
        CardTransparency = 0.08,
        ButtonTransparency = 0.08,
        SidebarTransparency = 0.04,
        LoadingTintTransparency = 0.29,
    },
    White = {
        Background = Color3.fromRGB(245, 247, 253),
        Surface = Color3.fromRGB(255, 255, 255),
        Surface2 = Color3.fromRGB(235, 239, 249),
        Surface3 = Color3.fromRGB(226, 231, 244),
        Text = Color3.fromRGB(29, 31, 47),
        Muted = Color3.fromRGB(91, 98, 121),
        Soft = Color3.fromRGB(129, 136, 157),
        Purple = Color3.fromRGB(137, 69, 231),
        Blue = Color3.fromRGB(66, 116, 231),
        Cyan = Color3.fromRGB(0, 166, 206),
        Stroke = Color3.fromRGB(198, 203, 222),
        Good = Color3.fromRGB(28, 166, 111),
        Danger = Color3.fromRGB(220, 65, 100),
        WindowTransparency = 0.015,
        PanelTransparency = 0,
        CardTransparency = 0,
        ButtonTransparency = 0.02,
        SidebarTransparency = 0,
        LoadingTintTransparency = 0.43,
    },
    Glass = {
        Background = Color3.fromRGB(11, 13, 25),
        Surface = Color3.fromRGB(26, 28, 48),
        Surface2 = Color3.fromRGB(45, 43, 72),
        Surface3 = Color3.fromRGB(61, 56, 92),
        Text = Color3.fromRGB(250, 248, 255),
        Muted = Color3.fromRGB(194, 190, 218),
        Soft = Color3.fromRGB(145, 139, 178),
        Purple = Color3.fromRGB(173, 115, 255),
        Blue = Color3.fromRGB(91, 151, 255),
        Cyan = Color3.fromRGB(91, 226, 255),
        Stroke = Color3.fromRGB(174, 155, 240),
        Good = Color3.fromRGB(91, 232, 171),
        Danger = Color3.fromRGB(255, 115, 154),
        WindowTransparency = 0.24,
        PanelTransparency = 0.27,
        CardTransparency = 0.34,
        ButtonTransparency = 0.23,
        SidebarTransparency = 0.28,
        LoadingTintTransparency = 0.38,
    },
}

-- Additional complete palettes. Each preset contains the same semantic keys as Midnight.
local function extendPalette(name, values)
    local palette = table.clone(ThemePresets.Midnight)
    for key, value in pairs(values) do palette[key] = value end
    ThemePresets[name] = palette
end
extendPalette("Ocean", {
    Background=Color3.fromRGB(5,12,23), Surface=Color3.fromRGB(9,24,40),
    Surface2=Color3.fromRGB(15,43,62), Surface3=Color3.fromRGB(24,62,83),
    Text=Color3.fromRGB(231,249,255), Muted=Color3.fromRGB(157,199,215),
    Soft=Color3.fromRGB(106,158,181), Purple=Color3.fromRGB(35,160,210),
    Blue=Color3.fromRGB(35,112,220), Cyan=Color3.fromRGB(63,231,222),
    Stroke=Color3.fromRGB(38,112,143)
})
extendPalette("Sakura", {
    Background=Color3.fromRGB(22,10,20), Surface=Color3.fromRGB(34,16,31),
    Surface2=Color3.fromRGB(55,25,48), Surface3=Color3.fromRGB(76,35,65),
    Text=Color3.fromRGB(255,239,249), Muted=Color3.fromRGB(222,178,203),
    Soft=Color3.fromRGB(177,128,157), Purple=Color3.fromRGB(244,105,174),
    Blue=Color3.fromRGB(174,112,255), Cyan=Color3.fromRGB(255,170,210),
    Stroke=Color3.fromRGB(131,66,105)
})
extendPalette("Emerald", {
    Background=Color3.fromRGB(5,17,14), Surface=Color3.fromRGB(10,29,23),
    Surface2=Color3.fromRGB(17,47,36), Surface3=Color3.fromRGB(27,66,49),
    Text=Color3.fromRGB(235,255,244), Muted=Color3.fromRGB(167,211,184),
    Soft=Color3.fromRGB(111,163,132), Purple=Color3.fromRGB(48,202,130),
    Blue=Color3.fromRGB(40,150,120), Cyan=Color3.fromRGB(119,255,192),
    Stroke=Color3.fromRGB(54,126,91)
})
extendPalette("Sunset", {
    Background=Color3.fromRGB(22,10,12), Surface=Color3.fromRGB(39,17,20),
    Surface2=Color3.fromRGB(62,27,28), Surface3=Color3.fromRGB(83,39,35),
    Text=Color3.fromRGB(255,245,234), Muted=Color3.fromRGB(225,190,170),
    Soft=Color3.fromRGB(176,135,118), Purple=Color3.fromRGB(255,111,87),
    Blue=Color3.fromRGB(255,153,77), Cyan=Color3.fromRGB(255,207,113),
    Stroke=Color3.fromRGB(137,72,57)
})
extendPalette("Carbon", {
    Background=Color3.fromRGB(9,10,12), Surface=Color3.fromRGB(17,18,21),
    Surface2=Color3.fromRGB(29,30,34), Surface3=Color3.fromRGB(43,44,49),
    Text=Color3.fromRGB(246,247,249), Muted=Color3.fromRGB(174,177,184),
    Soft=Color3.fromRGB(121,125,134), Purple=Color3.fromRGB(185,190,201),
    Blue=Color3.fromRGB(120,151,190), Cyan=Color3.fromRGB(186,213,226),
    Stroke=Color3.fromRGB(80,84,94)
})
extendPalette("Aurora", {
    Background=Color3.fromRGB(6,12,22), Surface=Color3.fromRGB(12,22,36),
    Surface2=Color3.fromRGB(22,39,57), Surface3=Color3.fromRGB(31,57,73),
    Text=Color3.fromRGB(241,255,251), Muted=Color3.fromRGB(177,210,207),
    Soft=Color3.fromRGB(120,164,163), Purple=Color3.fromRGB(109,105,255),
    Blue=Color3.fromRGB(65,190,190), Cyan=Color3.fromRGB(121,255,198),
    Stroke=Color3.fromRGB(68,119,135)
})

-- Theme identity drives a coherent intro scene and matching copy.
local CUTSCENE_TEXT_PRESETS = {
    Minimal779 = {
        Title = "MINIMAL",
        Subtitle = "4D GUI",
        Caption = "PRESENT YOU",
    },
}
local THEME_PRESENTATIONS = {
    Midnight = {Emoji="🌌", Cutscene="Waterfall", TextPreset="Minimal779"},
    Sakura = {Emoji="🌸", Cutscene="Sakura", TextPreset="Minimal779"},
    Emerald = {Emoji="🌿", Cutscene="Starfall", TextPreset="Minimal779"},
}
local THEME_DISPLAY_NAMES = {}
for themeName, presentation in pairs(THEME_PRESENTATIONS) do
    THEME_DISPLAY_NAMES[presentation.Emoji .. " " .. themeName] = themeName
end
THEME_DISPLAY_NAMES["🎨 Custom"] = "Custom"

local DEFAULT_ART = "rbxassetid://5725566168"
local Theme = table.clone(ThemePresets.Midnight)
local CurrentThemeName = "Midnight"

local THEME_COLOR_TOKENS = {
    Background=true, Surface=true, Surface2=true, Surface3=true, Text=true,
    Muted=true, Soft=true, Purple=true, Blue=true, Cyan=true, Stroke=true,
    Good=true, Danger=true,
}
local THEME_NUMBER_TOKENS = {
    WindowTransparency=true, PanelTransparency=true, CardTransparency=true,
    ButtonTransparency=true, SidebarTransparency=true, LoadingTintTransparency=true,
}

-- Small preference store: executor environment first, optional JSON file fallback.
-- This stores appearance choices only; no game data is accessed.
local HttpService = game:GetService("HttpService")
local PREFS_FILE = "779_Minimal_Preferences.json"
local function load4DPreferences()
    -- Persistent file is the cross-session source; getgenv is the live-session
    -- override. Merge instead of choosing one source so an older partial env
    -- table cannot hide the last saved local theme.
    local prefs = {}
    pcall(function()
        if type(isfile) == "function" and isfile(PREFS_FILE) and type(readfile) == "function" then
            local decoded = HttpService:JSONDecode(readfile(PREFS_FILE))
            if type(decoded) == "table" then
                for key, value in pairs(decoded) do prefs[key] = value end
            end
        end
    end)
    pcall(function()
        if type(getgenv) == "function" then
            local env = getgenv()
            if type(env.M779_PREFERENCES) == "table" then
                for key, value in pairs(env.M779_PREFERENCES) do prefs[key] = value end
            end
        end
    end)
    return prefs
end
local M779_PREFERENCES = load4DPreferences()
local function save4DPreferences()
    pcall(function()
        if type(getgenv) == "function" then getgenv().M779_PREFERENCES = M779_PREFERENCES end
    end)
    pcall(function()
        if type(writefile) == "function" then
            local serializable = table.clone(M779_PREFERENCES)
            local function encodeTheme(theme)
                local stored = {}
                for key, value in pairs(theme or {}) do
                    if typeof(value) == "Color3" then
                        stored[key] = {value.R, value.G, value.B}
                    elseif type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
                        stored[key] = value
                    end
                end
                return stored
            end
            if type(serializable.CustomTheme) == "table" then
                serializable.CustomTheme = encodeTheme(serializable.CustomTheme)
            end
            if type(serializable.UserThemes) == "table" then
                local encodedThemes = {}
                for themeName, themeData in pairs(serializable.UserThemes) do
                    if type(themeName) == "string" and type(themeData) == "table" then
                        encodedThemes[themeName] = encodeTheme(themeData)
                    end
                end
                serializable.UserThemes = encodedThemes
            end
            writefile(PREFS_FILE, HttpService:JSONEncode(serializable))
        end
    end)
end
local function decodeStoredTheme(theme)
    if type(theme) ~= "table" then return {} end
    local decoded = {}
    for key, value in pairs(theme) do
        if type(value) == "table" and tonumber(value[1]) and tonumber(value[2]) and tonumber(value[3]) then
            decoded[key] = Color3.new(
                math.clamp(tonumber(value[1]), 0, 1),
                math.clamp(tonumber(value[2]), 0, 1),
                math.clamp(tonumber(value[3]), 0, 1))
        elseif typeof(value) == "Color3" or type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
            decoded[key] = value
        end
    end
    return decoded
end
if type(M779_PREFERENCES.CustomTheme) == "table" then
    M779_PREFERENCES.CustomTheme = decodeStoredTheme(M779_PREFERENCES.CustomTheme)
end
if type(M779_PREFERENCES.UserThemes) == "table" then
    for themeName, themeData in pairs(M779_PREFERENCES.UserThemes) do
        if type(themeName) == "string" and type(themeData) == "table" then
            M779_PREFERENCES.UserThemes[themeName] = decodeStoredTheme(themeData)
        end
    end
end

-- v5.1.1: Waterfall is the default only when the player has not selected a scene.
if M779_PREFERENCES.Intro ~= "Waterfall" and M779_PREFERENCES.Intro ~= "Starfall" and M779_PREFERENCES.Intro ~= "Sakura" then
    M779_PREFERENCES.Intro = "Waterfall"
end
-- A missing/invalid preference must never produce a half-resolved or random palette.
local savedThemeName = tostring(M779_PREFERENCES.Theme or "Midnight")
if THEME_PRESENTATIONS[savedThemeName] == nil then
    savedThemeName = "Midnight"
end
M779_PREFERENCES.Theme = savedThemeName
if M779_PREFERENCES.Style == nil or tostring(M779_PREFERENCES.Style) == "" then
    M779_PREFERENCES.Style = "Solid"
end

-- Edit these values before executing to customize the initial 4D window.
local M779_CONFIG = {
    Style = tostring(M779_PREFERENCES.Style or "Solid"), -- Glass, Solid, Neon, Minimal
    Intro = tostring(M779_PREFERENCES.Intro or "Waterfall"), -- Cinematic, Portal, Starfall, Aurora, Waterfall, Butterflies, Sakura, Midnight, Fade, Zoom, Minimal, None
    GradientColors = nil, -- derive accents from the active local theme
    BackgroundImage = "", -- image asset ID, e.g. "1234567890"; blank disables it
    BackgroundImageTransparency = 0.78,
    BackgroundMusic = tostring(M779_PREFERENCES.BackgroundMusic or ""), -- saved custom audio asset ID; blank disables music
    MusicVolume = 0.20,
    CutsceneSoundId = "1841647093", -- one-shot intro sound; stops when the scene ends
    NotificationSoundId = "131390520971848",
    FunctionClickSoundId = "88442833509532",
    CutsceneSoundVolume = 0.55,
}

local function resolveTheme(themeName, customTheme)
    local name = tostring(themeName or CurrentThemeName or "Midnight")
    local registered = Library.RegisteredThemes and Library.RegisteredThemes[name]
    local preset = ThemePresets[name] or registered or ThemePresets.Midnight
    local resolved = table.clone(preset)
    if name == "Custom" then
        resolved = table.clone(ThemePresets.Midnight)
    end

    if type(customTheme) == "table" then
        local aliases = { Accent = "Purple", Secondary = "Cyan", Panel = "Surface", PanelAlt = "Surface2" }
        for key, value in pairs(customTheme) do
            local target = aliases[key] or key
            if resolved[target] ~= nil then
                resolved[target] = value
            end
        end
    end

    CurrentThemeName = name
    return resolved
end

local function normalizeAssetId(value)
    if value == nil then return nil end
    local raw = tostring(value)
    if raw == "" then return nil end
    if string.match(raw, "^rbxassetid://%d+$") then return raw end
    local digits = string.match(raw, "%d+")
    if digits then return "rbxassetid://" .. digits end
    return raw
end

local function play779Sound(assetId, volume)
    local normalized = normalizeAssetId(assetId)
    if not normalized then return nil end
    local ok, sound = pcall(function()
        local instance = Instance.new("Sound")
        instance.Name = "779_UISound"
        instance.SoundId = normalized
        instance.Volume = math.clamp(tonumber(volume) or 0.45, 0, 1)
        instance.Looped = false
        instance.Parent = game:GetService("SoundService")
        instance:Play()
        task.delay(4, function() if instance and instance.Parent then instance:Destroy() end end)
        return instance
    end)
    return ok and sound or nil
end


local function normalizeGradientColors(colors, fallback)
    local result = {}
    if type(colors) == "table" then
        for _, color in ipairs(colors) do
            if typeof(color) == "Color3" then
                table.insert(result, color)
            elseif type(color) == "string" then
                local hex = string.gsub(color, "#", "")
                if #hex == 6 and string.match(hex, "^%x+$") then
                    local r = tonumber(string.sub(hex, 1, 2), 16)
                    local g = tonumber(string.sub(hex, 3, 4), 16)
                    local b = tonumber(string.sub(hex, 5, 6), 16)
                    table.insert(result, Color3.fromRGB(r, g, b))
                end
            end
        end
    end
    if #result < 2 then
        return table.clone(fallback or {Theme.Purple, Theme.Blue, Theme.Cyan})
    end
    return result
end

local function applyStyle(theme, styleName)
    local style = string.lower(tostring(styleName or "Glass"))
    theme.StyleName = style
    if style == "solid" then
        theme.WindowTransparency, theme.PanelTransparency = 0, 0
        theme.CardTransparency, theme.ButtonTransparency, theme.SidebarTransparency = 0, 0, 0
        theme.Stroke = theme.Text:Lerp(theme.Purple, 0.24)
        theme.Surface3 = theme.Surface3:Lerp(theme.Surface2, 0.16)
    elseif style == "neon" then
        theme.WindowTransparency, theme.PanelTransparency = 0.08, 0.12
        theme.CardTransparency, theme.ButtonTransparency, theme.SidebarTransparency = 0.18, 0.10, 0.10
        theme.Stroke = theme.Purple
        theme.Cyan = theme.Cyan:Lerp(Color3.new(1,1,1), 0.12)
    elseif style == "minimal" then
        theme.WindowTransparency, theme.PanelTransparency = 0.02, 0.02
        theme.CardTransparency, theme.ButtonTransparency, theme.SidebarTransparency = 0.03, 0.02, 0.02
        theme.Stroke = theme.Soft
        theme.Purple = theme.Purple:Lerp(theme.Text, 0.18)
    elseif style == "glass" then
        theme.WindowTransparency, theme.PanelTransparency = 0.24, 0.27
        theme.CardTransparency, theme.ButtonTransparency, theme.SidebarTransparency = 0.34, 0.23, 0.28
        theme.Stroke = theme.Stroke:Lerp(theme.Cyan, 0.18)
    end
    return theme
end

local function make(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        -- Visible is a strict boolean property. Normalize accidental 0/1 values
        -- rather than passing a number to Roblox's property setter.
        if property == "Visible" then
            value = value == true
        end

        local ok, err = pcall(function()
            object[property] = value
        end)
        if not ok then
            warn(string.format("[4D] Could not set %s.%s: %s", className, tostring(property), tostring(err)))
        end
    end

    if parent then
        local ok, err = pcall(function()
            object.Parent = parent
        end)
        if not ok then
            object:Destroy()
            error("[4D] Could not parent " .. tostring(className) .. ": " .. tostring(err))
        end
    end

    return object
end

local function normalizeControlConfig(config)
    local result = table.clone(config or {})
    result.Name = result.Name or result.Title or result.Label or result.Text or "Option"
    result.Description = result.Description or result.Desc
    result.Callback = result.Callback or result.Func or result.Function or result.Action
    result.ButtonText = result.ButtonText or result.ButtonLabel or result.TextOnButton
    if result.CurrentValue == nil then
        result.CurrentValue = result.Default
    end
    if result.CurrentValue == nil then
        result.CurrentValue = result.Value
    end
    if result.CurrentOption == nil then
        result.CurrentOption = result.DefaultOption or result.CurrentValue
    end
    if result.Range == nil and (result.Min ~= nil or result.Max ~= nil) then
        result.Range = { result.Min or 0, result.Max or 100 }
    end
    if result.Increment == nil then
        result.Increment = result.Step
    end
    return result
end

local function corner(parent, radius)
    return make("UICorner", { CornerRadius = UDim.new(0, radius or 10) }, parent)
end

local function stroke(parent, color, transparency, thickness)
    local resolvedColor = color or Theme.Stroke
    local outline = make("UIStroke", {
        Color = resolvedColor,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
    -- Distinguish semantic panel outlines from decorative accent strokes.
    -- Neon changes Theme.Stroke to Purple; this tag restores the true palette
    -- Stroke token when switching back to Glass / Solid / Minimal.
    if typeof(resolvedColor) == "Color3" and typeof(Theme.Stroke) == "Color3" then
        local delta = math.abs(resolvedColor.R-Theme.Stroke.R) + math.abs(resolvedColor.G-Theme.Stroke.G) + math.abs(resolvedColor.B-Theme.Stroke.B)
        if delta < 0.00001 then outline:SetAttribute("FourD_ThemeStroke", true) end
    end
    return outline
end

local function gradient(parent, colors, rotation)
    local sequence
    if #colors == 1 then
        sequence = ColorSequence.new(colors[1])
    else
        local keypoints = {}
        for index, color in ipairs(colors) do
            local time = (index - 1) / (#colors - 1)
            table.insert(keypoints, ColorSequenceKeypoint.new(time, color))
        end
        sequence = ColorSequence.new(keypoints)
    end

    return make("UIGradient", {
        Color = sequence,
        Rotation = rotation or 0,
    }, parent)
end

local ANIMATION_SPEED = 1 -- 0.4 = slower, 2.0 = faster
local SMOOTH_ANIMATIONS = true
local VISUAL_EFFECTS_ENABLED = true

local function tween(object, duration, properties, style, direction)
    local safeDuration = math.max(0.01, (tonumber(duration) or 0.25) / math.max(0.1, ANIMATION_SPEED))
    local easing = SMOOTH_ANIMATIONS and (style or Enum.EasingStyle.Quart) or Enum.EasingStyle.Linear
    local info = TweenInfo.new(safeDuration, easing, direction or Enum.EasingDirection.Out)
    local animation = TweenService:Create(object, info, properties)
    animation:Play()
    return animation
end

-- Central animation lifecycle. Every owned transition/cutscene tween can be
-- cancelled by group, preventing stale tweens from fighting newer UI states.
local AnimationManager = {}
AnimationManager.__index = AnimationManager

function AnimationManager.new(owner)
    return setmetatable({Owner = owner, Groups = {}, Destroyed = false}, AnimationManager)
end

function AnimationManager:Track(groupName, animation)
    if self.Destroyed or not animation then return nil end
    local group = tostring(groupName or "default")
    self.Groups[group] = self.Groups[group] or {}
    local list = self.Groups[group]
    list[#list + 1] = animation
    local connection
    connection = animation.Completed:Connect(function()
        for index = #list, 1, -1 do
            if list[index] == animation then table.remove(list, index); break end
        end
        if connection then connection:Disconnect(); connection = nil end
    end)
    return animation
end

function AnimationManager:Play(groupName, object, duration, properties, style, direction)
    if self.Destroyed or not object or not object.Parent then return nil end
    local ok, animation = pcall(function()
        return tween(object, duration, properties, style, direction)
    end)
    if not ok then
        warn("[4D] Animation creation failed: " .. tostring(animation))
        return nil
    end
    return self:Track(groupName, animation)
end

function AnimationManager:CancelGroup(groupName)
    local group = tostring(groupName or "default")
    local list = self.Groups[group] or {}
    local active = table.clone(list)
    self.Groups[group] = {}
    for _, animation in ipairs(active) do
        pcall(function() animation:Cancel() end)
    end
    return #active
end

function AnimationManager:CancelAll()
    self.Destroyed = true
    for groupName in pairs(self.Groups) do self:CancelGroup(groupName) end
    self.Groups = {}
end

local function guiParticleBurst(parent, center, count, radius)
    if not VISUAL_EFFECTS_ENABLED then return end
    local activePalette = Theme or ThemePresets.Midnight
    local palette = {
        activePalette.Purple or ThemePresets.Midnight.Purple,
        activePalette.Blue or ThemePresets.Midnight.Blue,
        activePalette.Cyan or ThemePresets.Midnight.Cyan,
        activePalette.Text or ThemePresets.Midnight.Text,
    }
    for index = 1, count do
        local angle = (math.pi * 2) * (index / count) + math.rad(math.random(-18, 18))
        local distance = math.random(math.floor(radius * 0.42), radius)
        local dx = math.cos(angle) * distance
        local dy = math.sin(angle) * distance
        local side = math.random(3, 7)
        local particle = make("Frame", {
            Name = "4DParticle",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = center,
            Size = UDim2.fromOffset(side, side),
            BackgroundColor3 = palette[math.random(1, #palette)],
            BackgroundTransparency = 0.04,
            BorderSizePixel = 0,
            Rotation = math.random(0, 180),
            ZIndex = 245,
        }, parent)
        if index % 3 == 0 then corner(particle, side) else corner(particle, 2) end
        local target = UDim2.new(center.X.Scale, center.X.Offset + dx, center.Y.Scale, center.Y.Offset + dy)
        local duration = math.random(42, 78) / 100
        tween(particle, duration, {
            Position = target,
            Size = UDim2.fromOffset(1, 1),
            BackgroundTransparency = 1,
            Rotation = particle.Rotation + math.random(90, 300),
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        task.delay(duration + 0.08, function()
            if particle and particle.Parent then particle:Destroy() end
        end)
    end
end

local function guiPulseRing(parent, center, maxSize, color)
    if not VISUAL_EFFECTS_ENABLED then return end
    local ring = make("Frame", {
        Name = "4DPulseRing",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = center,
        Size = UDim2.fromOffset(8, 8),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 244,
    }, parent)
    corner(ring, math.floor(maxSize * 0.5))
    local ringStroke = stroke(ring, color or Color3.new(1, 1, 1), 0.08, 2)
    tween(ring, 0.62, { Size = UDim2.fromOffset(maxSize, maxSize) }, Enum.EasingStyle.Quint)
    tween(ringStroke, 0.62, { Transparency = 1, Thickness = 0.5 }, Enum.EasingStyle.Quint)
    task.delay(0.7, function()
        if ring and ring.Parent then ring:Destroy() end
    end)
    return ring
end

local function addConnection(owner, connection)
    table.insert(owner._connections, connection)
    return connection
end

local function createLabel(parent, text, size, color, font, xAlignment)
    return make("TextLabel", {
        BackgroundTransparency = 1,
        Text = text or "",
        TextColor3 = color or Theme.Text,
        TextSize = math.max(10, tonumber(size) or 14),
        Font = font or Enum.Font.GothamMedium,
        TextXAlignment = xAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.fromScale(1, 1),
    }, parent)
end

local function safeGuiParent(screenGui)
    local candidates = {}

    -- Solara/executor UI containers are preferred when exposed.
    local gethuiFunction
    pcall(function() gethuiFunction = gethui end)
    if type(gethuiFunction) == "function" then
        local ok, hiddenGui = pcall(gethuiFunction)
        if ok and hiddenGui then table.insert(candidates, hiddenGui) end
    end

    -- CoreGui is the usual fallback for injected client-side interfaces.
    if CoreGui then table.insert(candidates, CoreGui) end

    -- PlayerGui remains a compatibility fallback for ordinary client contexts.
    if LocalPlayer then
        local ok, playerGui = pcall(function()
            return LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
        end)
        if ok and playerGui then table.insert(candidates, playerGui) end
    end

    for _, candidate in ipairs(candidates) do
        local ok = pcall(function()
            -- Remove an older copy from this same parent before attaching the new one.
            local old = candidate:FindFirstChild("4D_UI_Library")
            if old and old ~= screenGui then old:Destroy() end
            screenGui.Parent = candidate
        end)
        if ok and screenGui.Parent == candidate then return true end
    end
    return false
end
-- Creates a real 4D hypercube projection using 4D rotations and 4D -> 3D -> 2D perspective.
local function createTesseract(owner, parent, pixelSize, lineTransparency)
    local canvas = make("Frame", {
        Name = "Tesseract",
        BackgroundColor3 = Color3.fromRGB(8, 10, 18),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(pixelSize, pixelSize),
        ClipsDescendants = false,
        ZIndex = (parent.ZIndex or 1) + 1,
    }, parent)
    local baseZ = canvas.ZIndex
    -- Logo geometry is brand artwork, not a theme surface: keep it pure white.
    canvas:SetAttribute("4D_KeepWhiteLogo", true)

    -- Transparent logo canvas: only the animated white tesseract edges are drawn.

    local vertices = {}
    for index = 0, 15 do
        vertices[index + 1] = {
            (bit32.band(index, 1) ~= 0) and 1 or -1,
            (bit32.band(index, 2) ~= 0) and 1 or -1,
            (bit32.band(index, 4) ~= 0) and 1 or -1,
            (bit32.band(index, 8) ~= 0) and 1 or -1,
        }
    end

    local edges = {}
    for a = 0, 15 do
        for b = a + 1, 15 do
            local differentBits = bit32.bxor(a, b)
            if bit32.band(differentBits, differentBits - 1) == 0 then
                table.insert(edges, { a + 1, b + 1 })
            end
        end
    end

    local lines = {}
    for index = 1, #edges do
        local line = make("Frame", {
            Name = "Edge",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = lineTransparency or 0.12,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(10, math.max(1.25, pixelSize / 65)),
            ZIndex = baseZ + 3,
        }, canvas)
        line:SetAttribute("4D_KeepWhiteLogo", true)
        corner(line, 4)
        lines[index] = line
    end

    local centerDot = make("Frame", {
        Name = "CoreGlow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(math.max(2, pixelSize / 24), math.max(2, pixelSize / 24)),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ZIndex = baseZ + 4,
    }, canvas)
    centerDot:SetAttribute("4D_KeepWhiteLogo", true)
    corner(centerDot, 20)

    local function rotatePair(vector, axisA, axisB, angle)
        local cosine = math.cos(angle)
        local sine = math.sin(angle)
        local a = vector[axisA]
        local b = vector[axisB]
        vector[axisA] = a * cosine - b * sine
        vector[axisB] = a * sine + b * cosine
    end

    local phase = math.random() * 2
    local connection
    connection = RunService.RenderStepped:Connect(function(deltaTime)
        if not canvas.Parent then
            connection:Disconnect()
            return
        end

        phase += deltaTime
        local rotationValues = {
            { 1, 2, phase * 0.46 },
            { 1, 3, phase * 0.31 },
            { 1, 4, phase * 0.55 },
            { 2, 3, phase * 0.38 },
            { 2, 4, phase * 0.27 },
            { 3, 4, phase * 0.42 },
        }

        local projected = {}
        local scale = pixelSize * 0.175
        for index, source in ipairs(vertices) do
            local v = { source[1], source[2], source[3], source[4] }
            for _, rotation in ipairs(rotationValues) do
                rotatePair(v, rotation[1], rotation[2], rotation[3])
            end

            local perspective4D = 3.7 / (3.7 - v[4])
            local x3 = v[1] * perspective4D
            local y3 = v[2] * perspective4D
            local z3 = v[3] * perspective4D
            local perspective3D = 4.3 / (4.3 - z3)

            projected[index] = Vector2.new(
                pixelSize * 0.5 + x3 * perspective3D * scale,
                pixelSize * 0.5 + y3 * perspective3D * scale
            )
        end

        for edgeIndex, edge in ipairs(edges) do
            local pointA = projected[edge[1]]
            local pointB = projected[edge[2]]
            local difference = pointB - pointA
            local length = difference.Magnitude
            local line = lines[edgeIndex]
            line.Position = UDim2.fromOffset((pointA.X + pointB.X) * 0.5, (pointA.Y + pointB.Y) * 0.5)
            line.Size = UDim2.fromOffset(length, math.max(1.25, pixelSize / 65))
            line.Rotation = math.deg(math.atan2(difference.Y, difference.X))
        end

        centerDot.BackgroundTransparency = 0.18 + (math.sin(phase * 2) + 1) * 0.08
    end)

    addConnection(owner, connection)
    return canvas
end

local function createGradientAccent(parent, transparency)
    local accent = make("Frame", {
        Name = "GradientAccent",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = transparency or 0,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        ZIndex = (parent.ZIndex or 1) + 1,
    }, parent)
    local activePalette = Theme or ThemePresets.Midnight
    local shimmer = gradient(accent, {
        activePalette.Purple or ThemePresets.Midnight.Purple,
        activePalette.Blue or ThemePresets.Midnight.Blue,
        activePalette.Cyan or ThemePresets.Midnight.Cyan,
        activePalette.Purple or ThemePresets.Midnight.Purple,
    }, 0)
    shimmer.Offset = Vector2.new(-1, 0)
    local shimmerTween = TweenService:Create(
        shimmer,
        TweenInfo.new(5.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true),
        { Offset = Vector2.new(1, 0) }
    )
    shimmerTween:Play()
    return accent
end

local function create779HUD(owner, hudConfig)
    if hudConfig == false or (type(hudConfig) == "table" and hudConfig.Enabled == false) then return nil end
    local config = type(hudConfig) == "table" and hudConfig or {}
    local holder = make("Frame", {
        Name="779_TopStatusHUD", AnchorPoint=Vector2.new(0.5,0),
        Position=UDim2.new(0.5,0,0,10), Size=UDim2.fromOffset(610,44),
        BackgroundColor3=Theme.Surface, BackgroundTransparency=0.08,
        BorderSizePixel=0, Visible=false, ZIndex=480,
    }, owner.ScreenGui)
    corner(holder,12)
    local outline = stroke(holder,Theme.Stroke,0.18,1)
    gradient(holder,{Theme.Surface2,Theme.Surface,Theme.Background},0)
    local function metric(x, width, titleText, initial)
        local title = createLabel(holder,titleText,8,Theme.Soft,Enum.Font.GothamBold)
        title.Position=UDim2.fromOffset(x,6); title.Size=UDim2.fromOffset(width,10); title.ZIndex=482
        local value = createLabel(holder,initial,11,Theme.Text,Enum.Font.GothamSemibold)
        value.Position=UDim2.fromOffset(x,19); value.Size=UDim2.fromOffset(width,17); value.ZIndex=482
        return value
    end
    local scriptName = tostring(config.ScriptName or "779 MINIMAL")
    local title = createLabel(holder,scriptName,10,Theme.Cyan,Enum.Font.GothamBold)
    title.Position=UDim2.fromOffset(13,14); title.Size=UDim2.fromOffset(112,17); title.ZIndex=482
    local fpsLabel = metric(137,58,"FPS","--")
    local pingLabel = metric(218,72,"PING","-- ms")
    local serverLabel = metric(313,96,"SERVER",tostring(game.PlaceId))
    local nickLabel = metric(432,160,"PLAYER",LocalPlayer and (LocalPlayer.DisplayName or LocalPlayer.Name) or "Player")
    local divider = make("Frame",{Position=UDim2.fromOffset(126,9),Size=UDim2.fromOffset(1,26),BackgroundColor3=Theme.Stroke,BackgroundTransparency=0.2,BorderSizePixel=0,ZIndex=482},holder)
    local fpsFrames, fpsElapsed, lastPing = 0,0,0
    local statsService = game:GetService("Stats")
    addConnection(owner,RunService.RenderStepped:Connect(function(dt)
        if owner._destroyed or not holder.Parent then return end
        fpsFrames=fpsFrames+1; fpsElapsed=fpsElapsed+(dt or 0)
        if fpsElapsed>=0.5 then
            fpsLabel.Text=tostring(math.floor(fpsFrames/math.max(fpsElapsed,0.001)+0.5))
            fpsFrames=0; fpsElapsed=0
            local pingText="-- ms"
            pcall(function()
                local item=statsService.Network.ServerStatsItem["Data Ping"]
                local value=item and item:GetValue()
                if type(value)=="number" then pingText=tostring(math.floor(value+0.5)).." ms" end
            end)
            pingLabel.Text=pingText
            local job=tostring(game.JobId or "")
            serverLabel.Text=job~="" and string.sub(job,1,8) or tostring(game.PlaceId)
            nickLabel.Text=LocalPlayer and (LocalPlayer.DisplayName or LocalPlayer.Name) or "Player"
        end
    end))
    owner._hud=holder
    owner._hudStroke=outline
    return holder
end

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

function Library.CreateWindow(selfOrConfig, maybeConfig)
    local config
    if selfOrConfig == Library then
        config = maybeConfig
    else
        config = selfOrConfig
    end
    config = config or {}
    local previousWindow = M779_ENV and M779_ENV.__779_ACTIVE_WINDOW
    if previousWindow and previousWindow.Destroy then
        pcall(function() previousWindow:Destroy() end)
    end
    -- Session state is keyed by the live server JobId: reinjection in the same
    -- server is recognized, while a different server starts a fresh intro.
    local sessionKey = tostring(game.PlaceId) .. ":" .. tostring(game.JobId ~= "" and game.JobId or game.PrivateServerId)
    M779_ENV.__M779_SESSION_STATE = M779_ENV.__M779_SESSION_STATE or {}
    local sessionState = M779_ENV.__M779_SESSION_STATE[sessionKey]
    if type(sessionState) ~= "table" then
        sessionState = { IntroPlayed = false }
        M779_ENV.__M779_SESSION_STATE[sessionKey] = sessionState
    end
    Library._ReturningSession = sessionState.IntroPlayed == true
    Library._SessionState = sessionState
    Theme = resolveTheme(config.Theme or CurrentThemeName, config.CustomTheme)
    local appearanceConfig = type(config.Appearance) == "table" and config.Appearance or {}
    local styleName = appearanceConfig.Style or config.Style or (config.Theme == "Glass" and "Glass") or "Solid"
    Theme = applyStyle(table.clone(Theme), styleName)
    local gradientColors = normalizeGradientColors(appearanceConfig.GradientColors or config.GradientColors,
        {Theme.Purple, Theme.Blue, Theme.Cyan})
    local loadingConfig = type(config.LoadingScreen) == "table" and config.LoadingScreen or {}
    local loadingImageId = normalizeAssetId(loadingConfig.Image or config.LoadingImage or DEFAULT_ART)
    local heroImageId = normalizeAssetId(config.HeroImage or loadingConfig.HeroImage or loadingImageId)
    local backgroundImageId = normalizeAssetId(appearanceConfig.BackgroundImage or config.BackgroundImage)
    local animationConfig = type(config.Animation) == "table" and config.Animation or {}
    local themePresentation = THEME_PRESENTATIONS[tostring(config.Theme or CurrentThemeName)] or THEME_PRESENTATIONS.Midnight
    local cutsceneName
    if animationConfig.AutoTheme == true then
        cutsceneName = tostring(themePresentation.Cutscene)
    else
        cutsceneName = tostring(animationConfig.Intro or config.Cutscene or M779_PREFERENCES.Intro or M779_CONFIG.Intro or themePresentation.Cutscene)
    end
    local initialTextPreset
    if animationConfig.AutoTheme == true or M779_PREFERENCES.CutsceneTextAuto ~= false then
        initialTextPreset = tostring(animationConfig.TextPreset or themePresentation.TextPreset or "Minimal779")
    else
        initialTextPreset = tostring(animationConfig.TextPreset or M779_PREFERENCES.CutsceneTextPreset or themePresentation.TextPreset or "Minimal779")
    end
    if not CUTSCENE_TEXT_PRESETS[initialTextPreset] then initialTextPreset = themePresentation.TextPreset or "Minimal779" end
    local cutsceneKey = string.lower(cutsceneName)
    local validCutscenes = {starfall=true, waterfall=true, sakura=true, none=true}
    if not validCutscenes[cutsceneKey] then cutsceneName = "Waterfall" end
    local sizeConfig = type(config.WindowSize) == "table" and config.WindowSize or {}
    local windowWidth = math.clamp(tonumber(sizeConfig.Width or config.Width) or 1480, 620, 1600)
    local windowHeight = math.clamp(tonumber(sizeConfig.Height or config.Height) or 840, 420, 1000)
    local sidebarWidth = math.clamp(tonumber(config.SidebarWidth) or 250, 130, 300)
    local owner = setmetatable({
        _connections = {},
        _tabs = {},
        _destroyed = false,
        _visible = true,
        _introFinished = false,
        _config = config,
        _themeName = config.Theme or CurrentThemeName,
        _theme = Theme,
        _heroImage = heroImageId,
        _windowWidth = windowWidth,
        _windowHeight = windowHeight,
        _sidebarWidth = sidebarWidth,
        _loadingConfig = loadingConfig,
        _styleName = tostring(styleName),
        _gradientColors = gradientColors,
        _animationPreset = cutsceneName,
        _cutsceneTextPreset = initialTextPreset,
        _themeAutoPresentation = animationConfig.AutoTheme == true,
        _introStarted = false,
        _sessionState = Library._SessionState,
        _backgroundMusic = nil,
        _animationSpeed = tonumber(M779_PREFERENCES.AnimationSpeed) or 1,
        _smoothAnimations = true,
        _motionTweens = {},
        _transitionToken = 0,
        _cutsceneToken = 0,
        _cutsceneTweens = {},
        _notifications = {},
        _notificationLimit = 5,
        _notificationSerial = 0,
    }, Window)
    owner._animationManager = AnimationManager.new(owner)
    M779_ENV.__779_ACTIVE_WINDOW = owner
    ANIMATION_SPEED = owner._animationSpeed

    local screenGui = make("ScreenGui", {
        Name = "779_Minimal_UI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    })
    owner.ScreenGui = screenGui

    if not safeGuiParent(screenGui) then
        screenGui:Destroy()
        error("779 UI: Could not parent ScreenGui. Solara may have blocked GUI parenting; check executor output and retry after the game finishes loading.")
    end
    create779HUD(owner, config.HUD)

    -- v5.1.0: never create Lighting.BlurEffect. Roblox's BlurEffect blurs the
    -- entire 3D scene; 4D uses translucent layered panels as a local glass effect.
    owner._blur = nil
    owner._glassBlurEnabled = true

    local overlay = make("Frame", {
        Name = "IntroOverlay",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 100,
    }, screenGui)
    local loadingBackground = make("ImageLabel", {
        Name = "LoadingArtwork",
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0, 0),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 1,
        Image = loadingImageId,
        -- Keep the artwork visible without turning the entire loading screen into
        -- an opaque wallpaper. Users can override this in LoadingScreen config.
        ImageTransparency = math.clamp(tonumber(loadingConfig.ImageTransparency) or 0.34, 0, 1),
        ScaleType = Enum.ScaleType.Stretch,
        BorderSizePixel = 0,
        ZIndex = 100,
    }, overlay)
    local loadingTint = make("Frame", {
        Name = "LoadingArtworkTint",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Background,
        -- Higher transparency lets the artwork and game world show through.
        BackgroundTransparency = math.clamp(tonumber(loadingConfig.TintTransparency) or 0.62, 0, 1),
        BorderSizePixel = 0,
        ZIndex = 101,
    }, overlay)
    owner.LoadingOverlay = overlay
    owner.LoadingBackground = loadingBackground
    owner._loadingStatusLabel = nil
    owner._loadingProgressFill = nil

    local introGlow = make("Frame", {
        Name = "IntroGlow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.34),
        Size = UDim2.fromOffset(205, 205),
        BackgroundColor3 = Theme.Purple,
        BackgroundTransparency = 0.84,
        BorderSizePixel = 0,
        ZIndex = 102,
    }, overlay)
    corner(introGlow, 120)
    gradient(introGlow, gradientColors, 35)

    local logoHolder = make("Frame", {
        Name = "IntroTesseractHolder",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.34),
        Size = UDim2.fromOffset(154, 154),
        BackgroundTransparency = 1,
        ZIndex = 103,
    }, overlay)
    local introLogoScale = make("UIScale", { Scale = 0.06 }, logoHolder)
    createTesseract(owner, logoHolder, 154, 0.02)
    -- A pair of quiet orbital rings gives the mark depth while keeping the
    -- existing single-logo scene and its low-cost geometry intact.
    for ringIndex, ringSize in ipairs({188, 222}) do
        local orbit = make("Frame", {
            Name = "IntroOrbit_" .. tostring(ringIndex),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.34),
            Size = UDim2.fromOffset(ringSize, ringSize),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 102,
        }, overlay)
        corner(orbit, 200)
        local orbitStroke = stroke(orbit, ringIndex == 1 and Theme.Cyan or Theme.Purple,
            ringIndex == 1 and 0.42 or 0.66, ringIndex == 1 and 1.4 or 1)
        owner._introOrbitStrokes = owner._introOrbitStrokes or {}
        table.insert(owner._introOrbitStrokes, orbitStroke)
    end

    local introBrand = createLabel(overlay, "4D", 38, Color3.new(1, 1, 1), Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
    introBrand.AnchorPoint = Vector2.new(0.5, 0.5)
    introBrand.Position = UDim2.fromScale(0.5, 0.515)
    introBrand.Size = UDim2.fromOffset(260, 48)
    introBrand.TextTransparency = 1
    introBrand.ZIndex = 105

    local presentText = createLabel(overlay, "", 11, Theme.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    presentText.AnchorPoint = Vector2.new(0.5, 0.5)
    presentText.Position = UDim2.fromScale(0.5, 0.575)
    presentText.Size = UDim2.fromOffset(300, 22)
    presentText.TextTransparency = 1
    presentText.ZIndex = 105

    local loadingCard = make("Frame", {
        Name = "LoadingCard",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.755),
        Size = UDim2.fromOffset(380, 104),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = math.clamp(tonumber(loadingConfig.CardTransparency or config.LoadingCardTransparency) or 0.28, 0, 0.85),
        BorderSizePixel = 0,
        ZIndex = 106,
    }, overlay)
    corner(loadingCard, 17)
    local loadingCardStroke = stroke(loadingCard, Theme.Stroke, 0.12, 1.25)
    -- Subtle animated glass sheen; the card remains readable over bright art.
    local loadingCardGradient = gradient(loadingCard, gradientColors, 18)
    loadingCardGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.10),
        NumberSequenceKeypoint.new(0.5, 0.42),
        NumberSequenceKeypoint.new(1, 0.12),
    })
    local loadingSheen = TweenService:Create(loadingCardGradient,
        TweenInfo.new(5.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { Rotation = 198 })
    loadingSheen:Play()
    owner._loadingSheen = loadingSheen
    local loadingCardScale = make("UIScale", { Scale = 0.88 }, loadingCard)

    local loadingSubtitle = createLabel(loadingCard, string.upper(loadingConfig.Subtitle or config.LoadingSubtitle or
        ((CUTSCENE_TEXT_PRESETS[initialTextPreset] or CUTSCENE_TEXT_PRESETS.Minimal779).Title)), 10, Theme.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
    loadingSubtitle.Position = UDim2.fromOffset(20, 17)
    loadingSubtitle.Size = UDim2.new(1, -40, 0, 17)
    loadingSubtitle.ZIndex = 107

    local loadingStatus = createLabel(loadingCard, loadingConfig.Status or "Entering the fourth dimension...", 9, Theme.Muted, Enum.Font.Gotham, Enum.TextXAlignment.Left)
    owner._loadingStatusLabel = loadingStatus
    loadingStatus.Position = UDim2.fromOffset(20, 42)
    loadingStatus.Size = UDim2.new(1, -40, 0, 16)
    loadingStatus.ZIndex = 107

    local progressBack = make("Frame", {
        Position = UDim2.new(0, 20, 1, -25),
        Size = UDim2.new(1, -40, 0, 5),
        BackgroundColor3 = Theme.Surface3,
        BorderSizePixel = 0,
        ZIndex = 107,
    }, loadingCard)
    corner(progressBack, 10)

    local progressFill = make("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Purple,
        BorderSizePixel = 0,
        ZIndex = 108,
    }, progressBack)
    corner(progressFill, 10)
    owner._loadingProgressFill = progressFill
    local progressGradient = gradient(progressFill, gradientColors, 0)
    owner._progressGradient = progressGradient
    local progressShimmer = TweenService:Create(progressGradient, TweenInfo.new(2.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), { Offset = Vector2.new(1, 0) })
    progressShimmer:Play()
    owner._progressShimmer = progressShimmer

    local main = make("Frame", {
        Name = "MainWindow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.53),
        Size = UDim2.fromOffset(windowWidth, windowHeight),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = Theme.WindowTransparency or 0.02,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 5,
    }, screenGui)
    owner.Main = main
    owner._targetSize = Vector2.new(windowWidth, windowHeight)
    local mainScale = make("UIScale", { Scale = 0.84 }, main)
    owner._mainScale = mainScale
    corner(main, 16)
    stroke(main, Theme.Stroke, 0.12, 1)
    gradient(main, gradientColors, 20)
    if backgroundImageId then
        local backgroundArt = make("ImageLabel", {
            Name = "4D_CustomBackground",
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0, 0),
            BackgroundTransparency = 1,
            Image = backgroundImageId,
            ImageTransparency = math.clamp(tonumber(appearanceConfig.BackgroundImageTransparency or config.BackgroundImageTransparency) or 0.78, 0, 1),
            ScaleType = Enum.ScaleType.Crop,
            BorderSizePixel = 0,
            ZIndex = 5,
        }, main)
        corner(backgroundArt, 16)
        owner._backgroundArt = backgroundArt
    end

    local topbar = make("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 62),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = Theme.PanelTransparency or 0,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, main)
    gradient(topbar, { Theme.Surface2, Theme.Surface }, 0)

    local topLogo = make("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(17, 7),
        Size = UDim2.fromOffset(48, 48),
        ZIndex = 7,
    }, topbar)
    createTesseract(owner, topLogo, 48, 0.04)

    local title = createLabel(topbar, config.Name or "779 Minimal", 16, Theme.Text, Enum.Font.GothamBold)
    title.Position = UDim2.fromOffset(73, 12)
    title.Size = UDim2.new(0, 270, 0, 21)
    title.ZIndex = 7

    local subtitle = createLabel(topbar, config.Subtitle or "MINIMAL 4D GUI", 9, Theme.Muted, Enum.Font.GothamMedium)
    subtitle.Position = UDim2.fromOffset(74, 33)
    subtitle.Size = UDim2.new(0, 300, 0, 15)
    subtitle.ZIndex = 7

    local topRight = createLabel(topbar, string.upper(tostring(owner._themeName) .. " EDITION"), 9, Theme.Soft, Enum.Font.GothamMedium, Enum.TextXAlignment.Right)
    owner._themeBadge = topRight
    topRight.Position = UDim2.new(1, -220, 0, 0)
    topRight.Size = UDim2.new(0, 165, 1, 0)
    topRight.ZIndex = 7

    local minimizeButton = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -47, 0, 18),
        Size = UDim2.fromOffset(25, 25),
        BackgroundColor3 = Theme.Surface3,
        BackgroundTransparency = 0.2,
        Text = "—",
        TextColor3 = Theme.Muted,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex = 8,
    }, topbar)
    corner(minimizeButton, 7)
    local function bindChromeButton(button, accent)
        local outline = stroke(button, Theme.Stroke, 0.72, 1)
        addConnection(owner, button.MouseEnter:Connect(function()
            tween(button, 0.14, {BackgroundColor3 = Theme.Surface3:Lerp(accent, 0.22), BackgroundTransparency = 0.04})
            if outline then tween(outline, 0.14, {Transparency = 0.18, Color = accent}) end
        end))
        addConnection(owner, button.MouseLeave:Connect(function()
            tween(button, 0.14, {BackgroundColor3 = Theme.Surface3, BackgroundTransparency = 0.2})
            if outline then tween(outline, 0.14, {Transparency = 0.72, Color = Theme.Stroke}) end
        end))
        addConnection(owner, button.Activated:Connect(function()
            tween(button, 0.07, {BackgroundTransparency = 0})
            task.delay(0.09, function()
                if button.Parent then tween(button, 0.12, {BackgroundTransparency = 0.04}) end
            end)
        end))
    end
    bindChromeButton(minimizeButton, Theme.Cyan)

    local closeButton = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 18),
        Size = UDim2.fromOffset(25, 25),
        BackgroundColor3 = Theme.Surface3,
        BackgroundTransparency = 0.2,
        Text = "×",
        TextColor3 = Theme.Muted,
        TextSize = 16,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex = 8,
    }, topbar)
    corner(closeButton, 7)
    bindChromeButton(closeButton, Theme.Danger)

    local sidebar = make("Frame", {
        Name = "Sidebar",
        Position = UDim2.fromOffset(0, 62),
        Size = UDim2.new(0, sidebarWidth, 1, -62),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = Theme.SidebarTransparency or 0,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, main)

    owner._sidebar = sidebar

    local sidebarBrand = make("Frame", {
        Name = "4D_SidebarBrand",
        Position = UDim2.fromOffset(14, 13),
        Size = UDim2.new(1, -28, 0, 178),
        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 0.28,
        BorderSizePixel = 0,
        ZIndex = 7,
    }, sidebar)
    corner(sidebarBrand, 13)
    stroke(sidebarBrand, Theme.Stroke, 0.24, 1)
    local sideLogoHolder = make("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 9),
        Size = UDim2.fromOffset(88, 88),
        ZIndex = 8,
    }, sidebarBrand)
    createTesseract(owner, sideLogoHolder, 88, 0.02)
    local sideBrandText = createLabel(sidebarBrand, "4D", 39, Theme.Text, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
    sideBrandText.Position = UDim2.new(0, 0, 0, 92)
    sideBrandText.Size = UDim2.new(1, 0, 0, 48)
    sideBrandText.ZIndex = 8
    local sideBrandCaption = createLabel(sidebarBrand, "PREMIUM UI LIBRARY", 8, Theme.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    sideBrandCaption.Position = UDim2.new(0, 0, 0, 143)
    sideBrandCaption.Size = UDim2.new(1, 0, 0, 17)
    sideBrandCaption.ZIndex = 8

    local sidebarCaption = createLabel(sidebar, "NAVIGATION", 9, Theme.Soft, Enum.Font.GothamBold)
    sidebarCaption.Position = UDim2.fromOffset(17, 202)
    sidebarCaption.Size = UDim2.new(1, -30, 0, 17)
    sidebarCaption.ZIndex = 7

    local tabHolder = make("Frame", {
        Name = "TabHolder",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(10, 225),
        Size = UDim2.new(1, -20, 1, -315),
        ZIndex = 7,
    }, sidebar)
    local tabLayout = make("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, tabHolder)

    local sidebarFoot = make("Frame", {
        Name = "CommunityCard",
        Position = UDim2.new(0, 14, 1, -126),
        Size = UDim2.new(1, -28, 0, 112),
        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 0.18,
        BorderSizePixel = 0,
        ZIndex = 7,
    }, sidebar)
    corner(sidebarFoot, 12)
    stroke(sidebarFoot, Theme.Stroke, 0.3, 1)
    local communityTitle = createLabel(sidebarFoot, "4D Framework", 12, Theme.Text, Enum.Font.GothamBold)
    communityTitle.Position = UDim2.fromOffset(12, 12)
    communityTitle.Size = UDim2.new(1, -24, 0, 20)
    local communityVersion = createLabel(sidebarFoot, "v5.3.1  •  Open Source", 9, Theme.Muted, Enum.Font.Gotham)
    communityVersion.Position = UDim2.fromOffset(12, 34)
    communityVersion.Size = UDim2.new(1, -24, 0, 16)
    local communityNote = createLabel(sidebarFoot, "Built for the community  ♥", 9, Theme.Muted, Enum.Font.Gotham)
    communityNote.Position = UDim2.fromOffset(12, 66)
    communityNote.Size = UDim2.new(1, -24, 0, 18)
    sidebarFoot.ZIndex = 7

    local content = make("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(sidebarWidth, 62),
        Size = UDim2.new(1, -sidebarWidth, 1, -62),
        BackgroundTransparency = 1,
        ZIndex = 6,
    }, main)

    local pageTitle = createLabel(content, "Welcome", 20, Theme.Text, Enum.Font.GothamBold)
    pageTitle.Visible = false
    pageTitle.Position = UDim2.fromOffset(23, 17)
    pageTitle.Size = UDim2.new(1, -46, 0, 27)
    pageTitle.ZIndex = 7

    local pageSubtitle = createLabel(content, "Choose a tab to get started.", 11, Theme.Muted, Enum.Font.Gotham)
    pageSubtitle.Visible = false
    pageSubtitle.Position = UDim2.fromOffset(24, 45)
    pageSubtitle.Size = UDim2.new(1, -46, 0, 19)
    pageSubtitle.ZIndex = 7

    local pageHolder = make("Frame", {
        Name = "PageHolder",
        Position = UDim2.fromOffset(18, 14),
        Size = UDim2.new(1, -36, 1, -28),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 7,
    }, content)

    owner._tabHolder = tabHolder
    owner._pageHolder = pageHolder
    owner._pageTitle = pageTitle
    owner._pageSubtitle = pageSubtitle
    owner._loadingDuration = math.clamp(tonumber(loadingConfig.Duration or config.LoadingDuration) or 4.6, 1.5, 15)
    owner._glassBlurSize = (string.lower(tostring(owner._styleName)) == "glass" and config.GlassBlur ~= false) and math.clamp(tonumber(config.GlassBlur) or 9, 0, 24) or 0
    owner._glassBlurEnabled = owner._glassBlurSize > 0
    owner._toggleKey = config.ToggleKey or Enum.KeyCode.RightControl

    -- Scale down gracefully on smaller screens while keeping the desktop layout intact.
    local responsiveScale = make("UIScale", { Scale = 1 }, main)
    local function updateResponsiveScale()
        local camera = workspace.CurrentCamera
        if not camera then return end
        local viewport = camera.ViewportSize
        local target = owner._targetSize or Vector2.new(700, 470)
        local scaleValue = math.min(1, (viewport.X - 36) / target.X, (viewport.Y - 36) / target.Y)
        responsiveScale.Scale = math.clamp(scaleValue, 0.42, 1)
    end
    owner._responsiveScale = responsiveScale
    owner._updateResponsiveScale = updateResponsiveScale
    updateResponsiveScale()
    -- Keep one viewport listener alive and disconnect it when CurrentCamera changes.
    local function bindViewportCamera(camera)
        if owner._cameraViewportConnection then
            owner._cameraViewportConnection:Disconnect()
            owner._cameraViewportConnection = nil
        end
        if camera then
            owner._cameraViewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveScale)
        end
        updateResponsiveScale()
    end
    bindViewportCamera(workspace.CurrentCamera)
    addConnection(owner, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        bindViewportCamera(workspace.CurrentCamera)
    end))

    -- Drag the window from its top bar.
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil
    addConnection(owner, topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPosition = main.Position
        end
    end))
    addConnection(owner, topbar.InputEnded:Connect(function(input)
        if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            dragInput = nil
        end
    end))
    addConnection(owner, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end))

    addConnection(owner, minimizeButton.Activated:Connect(function()
        owner:SetVisible(false)
    end))
    addConnection(owner, closeButton.Activated:Connect(function()
        -- X is a true close: animate out, release resources, and remove the GUI.
        owner:Close()
    end))
    addConnection(owner, minimizeButton.MouseEnter:Connect(function()
        tween(minimizeButton, 0.12, { BackgroundColor3 = Theme.Purple, TextColor3 = Theme.Text })
    end))
    addConnection(owner, minimizeButton.MouseLeave:Connect(function()
        tween(minimizeButton, 0.12, { BackgroundColor3 = Theme.Surface3, TextColor3 = Theme.Muted })
    end))
    addConnection(owner, closeButton.MouseEnter:Connect(function()
        tween(closeButton, 0.12, { BackgroundColor3 = Theme.Danger, TextColor3 = Theme.Text })
    end))
    addConnection(owner, closeButton.MouseLeave:Connect(function()
        tween(closeButton, 0.12, { BackgroundColor3 = Theme.Surface3, TextColor3 = Theme.Muted })
    end))

    -- Minimal floating dock. It is the only minimized control: no resize shards.
    local dock = make("TextButton", {
        Name = "4D_MinimizedDock",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 0.04,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 230,
    }, screenGui)
    corner(dock, 16)
    stroke(dock, Theme.Purple, 0.12, 1.5)
    local dockLogo = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(48, 48),
        BackgroundTransparency = 1,
        ZIndex = 231,
    }, dock)
    createTesseract(owner, dockLogo, 48, 0.02)
    owner._dock = dock
    local dockScale = make("UIScale", {Scale = 1}, dock)
    owner._dockScale = dockScale

    -- Drag the minimized 4D mark freely; a click without movement restores it.
    local dockDragging, dockMoved = false, false
    local dockDragInput, dockDragStart, dockStartPosition
    addConnection(owner, dock.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dockDragging = true
            dockMoved = false
            dockDragInput = input
            dockDragStart = input.Position
            dockStartPosition = dock.Position
        end
    end))
    addConnection(owner, dock.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dockDragInput = input
        end
    end))
    addConnection(owner, UserInputService.InputChanged:Connect(function(input)
        if dockDragging and (input == dockDragInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dockDragStart
            if math.abs(delta.X) + math.abs(delta.Y) > 5 then dockMoved = true end
            if dockMoved then
                local camera = workspace.CurrentCamera
                local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
                local x = math.clamp(dockStartPosition.X.Offset + delta.X, 36, viewport.X - 36)
                local y = math.clamp(dockStartPosition.Y.Offset + delta.Y, 36, viewport.Y - 36)
                dock.Position = UDim2.fromOffset(x, y)
            end
        end
    end))
    addConnection(owner, UserInputService.InputEnded:Connect(function(input)
        if dockDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dockDragging = false
            if not dockMoved and not owner._transitioning then owner:SetVisible(true) end
        end
    end))

    -- Single-owner intro coordinator. Returning injections skip the cinematic;
    -- first injections play exactly one selected scene before revealing Main.
    owner._introStarted = true
    task.spawn(function()
        local introOK, introError = xpcall(function()
            if owner._destroyed or owner._closing or not screenGui.Parent then return end
            if owner._loadingSheen then pcall(function() owner._loadingSheen:Cancel() end); owner._loadingSheen = nil end
            if owner._progressShimmer then pcall(function() owner._progressShimmer:Cancel() end); owner._progressShimmer = nil end
            if overlay and overlay.Parent then overlay:Destroy() end
            if not main or not main.Parent then return end

            owner._visible = true
            main.Visible = false
            main.Size = UDim2.fromOffset(owner._targetSize.X, owner._targetSize.Y)
            main.BackgroundTransparency = Theme.WindowTransparency or 0
            if mainScale and mainScale.Parent then mainScale.Scale = 0.88 end

            if Library._ReturningSession then
                -- Same live server: no second cinematic, just a soft GUI return.
                owner._introFinished = true
                if owner._hud then owner._hud.Visible = true end
                main.Visible = true
                tween(main, 0.46, {Size = UDim2.fromOffset(owner._targetSize.X, owner._targetSize.Y)}, Enum.EasingStyle.Quint)
                if mainScale and mainScale.Parent then tween(mainScale, 0.46, {Scale = 1}, Enum.EasingStyle.Back) end
                local playerName = LocalPlayer and (LocalPlayer.DisplayName or LocalPlayer.Name) or "there"
                owner:Notify({Title = "Hello again", Content = tostring(playerName), Duration = 3.2, Type = "success"})
                owner._revealAfterCutscene = false
                return
            end

            owner._introFinished = false
            local selected = string.lower(tostring(owner._animationPreset or "none"))
            if selected ~= "none" then
                owner._revealAfterCutscene = true
                local started = owner:PlayCutscene(selected)
                if not started then
                    owner._revealAfterCutscene = false
                    main.Visible = true
                    if mainScale and mainScale.Parent then mainScale.Scale = 1 end
                    owner._introFinished = true
                if owner._hud then owner._hud.Visible = true end
                end
            else
                main.Visible = true
                if mainScale and mainScale.Parent then mainScale.Scale = 1 end
                owner._introFinished = true
                if owner._hud then owner._hud.Visible = true end
                if owner._sessionState then owner._sessionState.IntroPlayed = true end
            end
        end, function(err)
            return debug and debug.traceback and debug.traceback(tostring(err), 2) or tostring(err)
        end)
        if not introOK and not owner._destroyed then
            warn("[4D v" .. tostring(Library.Version) .. "] Intro failed: " .. tostring(introError))
            owner._revealAfterCutscene = false
            if overlay and overlay.Parent then pcall(function() overlay:Destroy() end) end
            if owner._cutsceneOverlay then pcall(function() owner._cutsceneOverlay:Destroy() end); owner._cutsceneOverlay = nil end
            owner._activeCutsceneName = nil
            if main and main.Parent then
                main.Visible = true
                main.Size = UDim2.fromOffset(owner._targetSize.X, owner._targetSize.Y)
                main.BackgroundTransparency = Theme.WindowTransparency or 0
            end
            if mainScale and mainScale.Parent then mainScale.Scale = 1 end
            owner._introFinished = true
                if owner._hud then owner._hud.Visible = true end
            owner._visible = true
            -- Do not mark the session as played after a failed cinematic.
        end
    end)

    local musicConfig = config.BackgroundMusic or appearanceConfig.BackgroundMusic
    if musicConfig then
        local musicId, musicVolume, musicSpeed
        if type(musicConfig) == "table" then
            musicId = normalizeAssetId(musicConfig.SoundId or musicConfig.Id or musicConfig.AssetId)
            musicVolume = math.clamp(tonumber(musicConfig.Volume) or 0.25, 0, 10)
            musicSpeed = math.clamp(tonumber(musicConfig.PlaybackSpeed) or 1, 0.5, 2)
        else
            musicId = normalizeAssetId(musicConfig)
            musicVolume, musicSpeed = 0.25, 1
        end
        if musicId then
            local soundService = game:GetService("SoundService")
            local music = Instance.new("Sound")
            music.Name = "4D_BackgroundMusic"
            music.SoundId = musicId
            music.Volume = musicVolume
            music.PlaybackSpeed = musicSpeed
            music.Looped = true
            music.Parent = soundService
            owner._backgroundMusic = music
            pcall(function() music:Play() end)
        end
    end

    addConnection(owner, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or owner._destroyed or not owner._introFinished then return end
        local controlDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
        local shiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
        if input.KeyCode == Enum.KeyCode.K and controlDown and shiftDown then
            owner:OpenCommandPalette()
        elseif input.KeyCode == Enum.KeyCode.K and controlDown then
            owner:SetVisible(not owner._visible)
        elseif input.KeyCode == owner._toggleKey then
            owner:SetVisible(not owner._visible)
        elseif input.KeyCode == Enum.KeyCode.Escape then
            if owner._commandPalette then owner:CloseCommandPalette() end
            if owner._openPopup then owner._openPopup.Visible = false; owner._openPopup = nil end
        end
    end))
    if M779_PREFERENCES.Font then pcall(function() owner:SetFont(M779_PREFERENCES.Font) end) end
    -- Apply one consistent corner system to the complete interface, including popup layers.
    pcall(function() owner:SetCornerRadius(tonumber(M779_PREFERENCES.CornerRadius) or 12, true) end)

    return owner
end

function Window:RegisterCommand(name, description, callback, keywords)
    if self._destroyed or type(callback)~="function" then return false end
    self._commands=self._commands or {}
    local key=string.lower(tostring(name or ""))
    if key=="" then return false end
    for _, command in ipairs(self._commands) do
        if command.Key==key then
            command.Name=tostring(name)
            command.Description=tostring(description or "")
            command.Callback=callback
            command.Keywords=string.lower(tostring(keywords or ""))
            return true
        end
    end
    table.insert(self._commands,{
        Key=key,Name=tostring(name),Description=tostring(description or ""),
        Callback=callback,Keywords=string.lower(tostring(keywords or "")),
    })
    return true
end

function Window:CloseCommandPalette()
    local palette=self._commandPalette
    self._commandPalette=nil
    for _, connection in ipairs(self._commandPaletteConnections or {}) do
        pcall(function() connection:Disconnect() end)
    end
    self._commandPaletteConnections={}
    if palette and palette.Parent then
        local card = palette:FindFirstChildWhichIsA("Frame")
        for _, child in ipairs(palette:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                tween(child,0.16,{TextTransparency=1},Enum.EasingStyle.Quint)
            elseif child:IsA("GuiObject") then
                tween(child,0.16,{BackgroundTransparency=1},Enum.EasingStyle.Quint)
            end
        end
        tween(palette,0.18,{BackgroundTransparency=1},Enum.EasingStyle.Quint)
        if card then tween(card,0.18,{Position=UDim2.new(0.5,0,0.12,0)},Enum.EasingStyle.Quint) end
        task.delay(0.21,function() if palette and palette.Parent then palette:Destroy() end end)
    end
    return true
end

function Window:OpenCommandPalette()
    if self._destroyed or not self.ScreenGui then return false end
    if self._commandPalette and self._commandPalette.Parent then return true end
    self._commands=self._commands or {}
    local overlay=make("Frame",{
        Name="4D_CommandPalette",Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0.38,
        BorderSizePixel=0,ZIndex=410,Active=true,
    },self.ScreenGui)
    self._commandPalette=overlay
    local overlayScale = make("UIScale", {Scale = 0.96}, overlay)
    self._commandPaletteConnections={}
    local card=make("Frame",{
        AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0.12,0),
        Size=UDim2.new(0.58,0,0,390),BackgroundColor3=Theme.Surface,
        BackgroundTransparency=0.02,BorderSizePixel=0,ZIndex=411,
    },overlay)
    corner(card,16);stroke(card,Theme.Stroke,0.12,1)
    tween(overlay,0.20,{BackgroundTransparency=0.38},Enum.EasingStyle.Quint)
    tween(overlayScale,0.28,{Scale=1},Enum.EasingStyle.Back)
    tween(card,0.28,{Position=UDim2.new(0.5,0,0.16,0)},Enum.EasingStyle.Back)
    local heading=createLabel(card,"COMMAND DECK",10,Theme.Cyan,Enum.Font.GothamBold)
    heading.Position=UDim2.fromOffset(18,14);heading.Size=UDim2.new(1,-36,0,18);heading.ZIndex=412
    local search=make("TextBox",{
        Position=UDim2.fromOffset(16,42),Size=UDim2.new(1,-32,0,42),
        BackgroundColor3=Theme.Surface2,BorderSizePixel=0,
        PlaceholderText="Search commands…",Text="",ClearTextOnFocus=false,
        TextColor3=Theme.Text,PlaceholderColor3=Theme.Soft,TextSize=13,
        Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=412,
    },card)
    corner(search,10)
    local results=make("ScrollingFrame",{
        Position=UDim2.fromOffset(16,96),Size=UDim2.new(1,-32,1,-112),
        BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
        ScrollBarImageColor3=Theme.Purple,AutomaticCanvasSize=Enum.AutomaticSize.Y,
        CanvasSize=UDim2.new(0,0,0,0),ZIndex=412,
    },card)
    make("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},results)
    make("UIPadding",{PaddingBottom=UDim.new(0,6),PaddingRight=UDim.new(0,4)},results)
    local empty=createLabel(results,"No matching commands",11,Theme.Soft,Enum.Font.Gotham)
    empty.Size=UDim2.new(1,-4,0,34);empty.ZIndex=413
    local function refresh()
        for _, child in ipairs(results:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local query=string.lower(search.Text or "")
        local found=0
        for _, command in ipairs(self._commands) do
            local haystack=string.lower(command.Name.." "..command.Description.." "..command.Keywords)
            if query=="" or string.find(haystack,query,1,true) then
                found+=1
                local button=make("TextButton",{
                    Size=UDim2.new(1,-4,0,54),BackgroundColor3=Theme.Surface2,
                    BackgroundTransparency=0.08,BorderSizePixel=0,Text="",
                    AutoButtonColor=false,LayoutOrder=found,ZIndex=413,
                },results)
                corner(button,9)
                local commandName=createLabel(button,command.Name,11,Theme.Text,Enum.Font.GothamSemibold)
                commandName.Position=UDim2.fromOffset(12,7);commandName.Size=UDim2.new(1,-24,0,18);commandName.ZIndex=414
                local commandDescription=createLabel(button,command.Description,9,Theme.Muted,Enum.Font.Gotham)
                commandDescription.Position=UDim2.fromOffset(12,27);commandDescription.Size=UDim2.new(1,-24,0,16);commandDescription.ZIndex=414
                local selectedCommand=command
                button.Activated:Connect(function()
                    self:CloseCommandPalette()
                    task.spawn(function()
                        local ok,err=pcall(selectedCommand.Callback)
                        if not ok then
                            warn("[4D] Command error: "..tostring(err))
                            self:Notify({Title="Command failed",Content=tostring(err),Type="error"})
                        end
                    end)
                end)
            end
        end
        empty.Visible=found==0
    end
    table.insert(self._commandPaletteConnections,search:GetPropertyChangedSignal("Text"):Connect(refresh))
    table.insert(self._commandPaletteConnections,overlay.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 and input.Position.Y<card.AbsolutePosition.Y then
            self:CloseCommandPalette()
        end
    end))
    refresh()
    task.defer(function() if search and search.Parent then search:CaptureFocus() end end)
    return true
end

function Window:CreateTab(name, iconName, description)
    if self._destroyed then return nil end
    local tab = setmetatable({
        _window = self,
        _name = name or ("Tab " .. tostring(#self._tabs + 1)),
        _description = description or "Manage your options and settings.",
        _sections = {},
        _fadeOriginals = setmetatable({}, {__mode = "k"}),
        _nextLayoutOrder = 1,
    }, Tab)

    local button = make("TextButton", {
        Name = "TabButton",
        Size = UDim2.new(1, 0, 0, 39),
        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex = 8,
    }, self._tabHolder)
    corner(button, 9)

    local icon = createLabel(button, iconName or "◇", 15, Theme.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    icon.Position = UDim2.fromOffset(8, 0)
    icon.Size = UDim2.fromOffset(25, 39)
    icon.ZIndex = 9

    local label = createLabel(button, tab._name, 11, Theme.Muted, Enum.Font.GothamSemibold)
    label.Position = UDim2.fromOffset(39, 0)
    label.Size = UDim2.new(1, -45, 1, 0)
    label.ZIndex = 9

    local indicator = make("Frame", {
        Name = "Indicator",
        Position = UDim2.new(0, 0, 0.5, -9),
        Size = UDim2.fromOffset(3, 18),
        BackgroundColor3 = Theme.Purple,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, button)
    corner(indicator, 5)

    local page = make("ScrollingFrame", {
        Name = "Page_" .. tostring(#self._tabs + 1),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Purple,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 8,
    }, self._pageHolder)
    make("UIListLayout", {
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 6),
    }, page)

    tab._button = button
    tab._icon = icon
    tab._label = label
    tab._indicator = indicator
    tab._page = page
    table.insert(self._tabs, tab)

    local function selectTab()
        if self._destroyed or not tab._page or not tab._page.Parent then return end
        if self._activeTab == tab and tab._page.Visible then return end
        if self._openPopup then
            pcall(function() self._openPopup.Visible = false end)
            self._openPopup = nil
        end
        self._activeTab = tab
        -- Cancel the previous tab entrance before starting another one. Pages are
        -- still hard-switched (never stacked), while their contents receive a short
        -- stagger-free fade/slide that remains safe under rapid clicking.
        if self._animationManager then self._animationManager:CancelGroup("tab-transition") end
        self._tabTransitionToken = (self._tabTransitionToken or 0) + 1
        local transitionToken = self._tabTransitionToken
        for _, other in ipairs(self._tabs) do
            if other._page and other._page.Parent then
                other._page.Visible = false
                other._page.Position = UDim2.fromOffset(0, 0)
            end
        end
        for _, other in ipairs(self._tabs) do
            local selected = other == tab
            if selected and other._page and other._page.Parent then
                local page = other._page
                page.Visible = true
                page.ZIndex = 8
                page.Position = UDim2.fromOffset(10, 0)
                local pageTweens = {}
                for _, object in ipairs(page:GetDescendants()) do
                    local props = {}
                    local originals = tab._fadeOriginals[object]
                    if not originals then originals = {}; tab._fadeOriginals[object] = originals end
                    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                        if originals.TextTransparency == nil then originals.TextTransparency = object.TextTransparency end
                        props.TextTransparency = originals.TextTransparency
                        object.TextTransparency = math.max(originals.TextTransparency, 0.72)
                        if object.TextStrokeTransparency < 1 or originals.TextStrokeTransparency ~= nil then
                            if originals.TextStrokeTransparency == nil then originals.TextStrokeTransparency = object.TextStrokeTransparency end
                            props.TextStrokeTransparency = originals.TextStrokeTransparency
                            object.TextStrokeTransparency = 1
                        end
                    elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
                        if originals.ImageTransparency == nil then originals.ImageTransparency = object.ImageTransparency end
                        props.ImageTransparency = originals.ImageTransparency
                        object.ImageTransparency = math.max(originals.ImageTransparency, 0.72)
                    end
                    if next(props) then
                        local startProps = {}
                        for property, value in pairs(props) do startProps[property] = value end
                        local animation = TweenService:Create(object,
                            TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), startProps)
                        pageTweens[#pageTweens + 1] = animation
                        animation:Play()
                    end
                end
                local slide = TweenService:Create(page,
                    TweenInfo.new(0.27, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {Position = UDim2.fromOffset(0, 0)})
                pageTweens[#pageTweens + 1] = slide
                for _, animation in ipairs(pageTweens) do
                    if self._animationManager then self._animationManager:Track("tab-transition", animation) end
                end
                slide:Play()
                task.delay(0.30, function()
                    if self._destroyed or transitionToken ~= self._tabTransitionToken then return end
                    if page and page.Parent then page.Position = UDim2.fromOffset(0, 0) end
                end)
            end
            tween(other._button, 0.2, {
                BackgroundTransparency = selected and 0 or 1,
                BackgroundColor3 = Theme.Surface2,
            })
            tween(other._label, 0.2, { TextColor3 = selected and Theme.Text or Theme.Muted })
            tween(other._icon, 0.2, { TextColor3 = selected and Theme.Cyan or Theme.Muted })
            tween(other._indicator, 0.2, { BackgroundTransparency = selected and 0 or 1 })
        end
        self._pageTitle.Text = tab._name
        self._pageSubtitle.Text = tab._description
    end

    addConnection(self, button.Activated:Connect(selectTab))
    if #self._tabs == 1 then
        selectTab()
    end

    return tab
end

local Column = {}
Column.__index = Column

local function createSectionFor(tab, parent, name, layoutOwner)
    local section = setmetatable({ _tab = tab, _name = tostring(name or "Section"), _customization = tab._customization and table.clone(tab._customization) or nil }, Section)
    local card = make("Frame", {
        Name = "Section_" .. tostring(name or "Section"),
        Size = UDim2.new(1, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = Theme.CardTransparency or 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = layoutOwner and layoutOwner._nextOrder or tab._nextLayoutOrder,
        ZIndex = 8,
    }, parent)

    if layoutOwner then
        layoutOwner._nextOrder += 1
    else
        tab._nextLayoutOrder += 1
    end

    corner(card, 12)
    stroke(card, Theme.Stroke, 0.48, 1)
    local padding = make("UIPadding", {
        PaddingTop = UDim.new(0, 13),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 13),
        PaddingRight = UDim.new(0, 13),
    }, card)
    make("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, card)

    local heading = createLabel(card, name or "Section", 12, Theme.Text, Enum.Font.GothamBold)
    heading.Size = UDim2.new(1, 0, 0, 18)
    heading.LayoutOrder = 1
    heading.ZIndex = 9

    local rule = make("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Stroke,
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        LayoutOrder = 2,
        ZIndex = 9,
    }, card)

    section._card = card
    section._order = 3
    section._controls = {}
    table.insert(tab._sections, section)
    return section
end

function Tab:CreateSection(name)
    return createSectionFor(self, self._page, name, nil)
end

-- Rayfield-style convenience methods: controls may be added directly to a tab.
-- They are routed into one lazily-created default section, while explicit
-- Tab:CreateSection() remains available for developers who want full grouping.
function Tab:_GetDefaultSection()
    if self._defaultSection and self._defaultSection._card and self._defaultSection._card.Parent then
        return self._defaultSection
    end
    self._defaultSection = self:CreateSection("Controls")
    return self._defaultSection
end

local TAB_CONTROL_METHODS = {
    "CreateButton", "CreateToggle", "CreateSlider", "CreateDropdown",
    "CreateTextbox", "CreateParagraph", "CreateKeybind",
    "CreateColorPicker", "CreateLabel", "CreateDivider", "CreateImage",
}
for _, methodName in ipairs(TAB_CONTROL_METHODS) do
    local controlMethod = methodName
    Tab[controlMethod] = function(self, ...)
        local section = self:_GetDefaultSection()
        return section[controlMethod](section, ...)
    end
end
Tab.AddButton = Tab.CreateButton
Tab.AddToggle = Tab.CreateToggle
Tab.AddSlider = Tab.CreateSlider
Tab.AddDropdown = Tab.CreateDropdown
Tab.AddTextbox = Tab.CreateTextbox
Tab.AddParagraph = Tab.CreateParagraph
Tab.AddKeybind = Tab.CreateKeybind
Tab.AddColorPicker = Tab.CreateColorPicker
Tab.AddLabel = Tab.CreateLabel
Tab.AddDivider = Tab.CreateDivider
Tab.AddImage = Tab.CreateImage

function Tab:CreateColumns(gap)
    local spacing = math.clamp(tonumber(gap) or 12, 4, 28)
    local holder = make("Frame", {
        Name = "4D_TwoColumnLayout",
        Size = UDim2.new(1, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = self._nextLayoutOrder,
        ZIndex = 8,
    }, self._page)
    self._nextLayoutOrder += 1

    local leftFrame = make("Frame", {
        Name = "LeftColumn",
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0.5, -spacing * 0.5, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 8,
    }, holder)
    local rightFrame = make("Frame", {
        Name = "RightColumn",
        Position = UDim2.new(0.5, spacing * 0.5, 0, 0),
        Size = UDim2.new(0.5, -spacing * 0.5, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 8,
    }, holder)
    for _, frame in ipairs({ leftFrame, rightFrame }) do
        make("UIListLayout", {
            Padding = UDim.new(0, spacing),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, frame)
    end
    local columns = {
        Left = setmetatable({ _tab = self, _container = leftFrame, _nextOrder = 1 }, Column),
        Right = setmetatable({ _tab = self, _container = rightFrame, _nextOrder = 1 }, Column),
        Container = holder,
    }
    function columns:Get(index)
        return index == 2 and self.Right or self.Left
    end
    return columns
end

function Column:CreateSection(name)
    return createSectionFor(self._tab, self._container, name, self)
end

Column.AddGroupBox = Column.CreateSection
Column.CreateGroupBox = Column.CreateSection

function Tab:CreateHero(config)
    config = config or {}
    local height = math.clamp(tonumber(config.Height) or 188, 110, 320)
    local card = make("Frame", {
        Name = "4D_HeroBanner",
        Size = UDim2.new(1, -4, 0, height),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = 0,
        ZIndex = 8,
    }, self._page)
    corner(card, 15)
    stroke(card, Theme.Stroke, 0.25, 1)

    local imageId = config.Image or self._window._heroImage or DEFAULT_ART
    local art = make("ImageLabel", {
        Name = "HeroArtwork",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = imageId,
        ImageTransparency = math.clamp(tonumber(config.ImageTransparency) or 0, 0, 1),
        ScaleType = config.ScaleType or Enum.ScaleType.Stretch,
        BorderSizePixel = 0,
        ZIndex = 8,
    }, card)

    local veil = make("Frame", {
        Name = "HeroReadabilityOverlay",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.23,
        BorderSizePixel = 0,
        ZIndex = 9,
    }, card)
    local veilGradient = gradient(veil, { Theme.Background, Theme.Background, Theme.Surface }, 0)
    veilGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.02),
        NumberSequenceKeypoint.new(0.55, 0.2),
        NumberSequenceKeypoint.new(1, 0.7),
    })

    local eyebrow = createLabel(card, string.upper(config.Eyebrow or "4D  •  BEYOND DIMENSIONS"), 9, Theme.Cyan, Enum.Font.GothamBold)
    eyebrow.Position = UDim2.fromOffset(23, 17)
    eyebrow.Size = UDim2.new(0.62, -30, 0, 16)
    eyebrow.ZIndex = 10

    local title = createLabel(card, config.Title or "Welcome to 4D", 22, Theme.Text, Enum.Font.GothamBold)
    title.Position = UDim2.fromOffset(22, 39)
    title.Size = UDim2.new(0.66, -32, 0, 31)
    title.ZIndex = 10

    local description = createLabel(card, config.Description or "A premium UI framework with flexible components and themes.", 11, Theme.Muted, Enum.Font.Gotham)
    description.Position = UDim2.fromOffset(24, 75)
    description.Size = UDim2.new(0.62, -36, 0, math.max(34, height - 111))
    description.TextWrapped = true
    description.TextYAlignment = Enum.TextYAlignment.Top
    description.ZIndex = 10

    local brand = createLabel(card, config.Brand or "4D", 44, Color3.new(1, 1, 1), Enum.Font.GothamBlack, Enum.TextXAlignment.Right)
    brand.AnchorPoint = Vector2.new(1, 0.5)
    brand.Position = UDim2.new(1, -25, 0.5, -7)
    brand.Size = UDim2.new(0, 180, 0, 58)
    brand.TextStrokeTransparency = 1
    brand.ZIndex = 10

    local ctaText = config.ButtonText
    local cta
    if ctaText and ctaText ~= "" then
        cta = make("TextButton", {
            Name = "HeroAction",
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 23, 1, -15),
            Size = UDim2.fromOffset(math.clamp(tonumber(config.ButtonWidth) or 150, 110, 220), 32),
            BackgroundColor3 = Theme.Purple,
            BackgroundTransparency = 0.06,
            Text = tostring(ctaText) .. "  →",
            TextColor3 = Theme.Text,
            TextSize = 10,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            ZIndex = 11,
        }, card)
        corner(cta, 9)
        gradient(cta, { Theme.Purple, Theme.Blue, Theme.Cyan }, 0)
        stroke(cta, Theme.Cyan, 0.5, 1)
        addConnection(self._window, cta.Activated:Connect(function()
            if type(config.Callback) == "function" then
                local ok, err = pcall(config.Callback)
                if not ok then warn("[4D] Hero callback error: " .. tostring(err)) end
            end
        end))
    end

    addConnection(self._window, card.MouseEnter:Connect(function()
        tween(card, 0.18, { BackgroundColor3 = Theme.Surface2 })
    end))
    addConnection(self._window, card.MouseLeave:Connect(function()
        tween(card, 0.18, { BackgroundColor3 = Theme.Surface })
    end))
    return { Frame = card, Image = art, Title = title, Description = description, Button = cta }
end

local function createControlRow(section, height)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, height or 43),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = section._order,
        ZIndex = 9,
    }, section._card)
    section._order += 1
    table.insert(section._controls, row)
    section._lastElementRow = row
    return row
end

local function addControlText(row, config)
    config = config or {}
    local title = createLabel(row, config.Name or "Option", 11, Theme.Text, Enum.Font.GothamSemibold)
    title.Position = UDim2.fromOffset(0, 2)
    title.Size = UDim2.new(1, -125, 0, 19)
    title.ZIndex = 10

    if config.Description and config.Description ~= "" then
        local description = createLabel(row, config.Description, 9, Theme.Muted, Enum.Font.Gotham)
        description.Position = UDim2.fromOffset(0, 21)
        description.Size = UDim2.new(1, -125, 0, 16)
        description.ZIndex = 10
    end
    return title
end

function Section:CreateButton(config)
    config = normalizeControlConfig(config)
    local row = createControlRow(self, 43)
    addControlText(row, config)
    local button = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(104, 30),
        BackgroundColor3 = Theme.Surface3,
        BackgroundTransparency = Theme.ButtonTransparency or 0,
        Text = config.ButtonText or "Run",
        TextColor3 = Theme.Text,
        TextSize = 10,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, row)
    corner(button, 8)
    local buttonStroke = stroke(button, Theme.Stroke, 0.45, 1)
    addConnection(self._tab._window, button.MouseEnter:Connect(function()
        tween(button, 0.15, { BackgroundColor3 = Theme.Surface3:Lerp(Theme.Purple, 0.22) })
        if buttonStroke then tween(buttonStroke, 0.15, {Transparency = 0.12, Color = Theme.Purple}) end
    end))
    addConnection(self._tab._window, button.MouseLeave:Connect(function()
        tween(button, 0.15, { BackgroundColor3 = Theme.Surface3 })
        if buttonStroke then tween(buttonStroke, 0.15, {Transparency = 0.45, Color = Theme.Stroke}) end
    end))
    addConnection(self._tab._window, button.Activated:Connect(function()
        play779Sound(M779_CONFIG.FunctionClickSoundId or "88442833509532", 0.42)
        tween(button, 0.08, { Size = UDim2.fromOffset(100, 28) })
        task.delay(0.08, function()
            if button.Parent then tween(button, 0.12, { Size = UDim2.fromOffset(104, 30) }) end
        end)
        if type(config.Callback) == "function" then
            local ok, err = pcall(config.Callback)
            if not ok then warn("[779] Button callback error:", err) end
        end
    end))
    return button
end

function Section:CreateToggle(config)
    config = normalizeControlConfig(config)
    local row = createControlRow(self, 43)
    addControlText(row, config)

    local enabled = config.CurrentValue == true
    local track = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(40, 22),
        Name = "ToggleTrack",
        BackgroundColor3 = enabled and Theme.Purple or Theme.Surface3,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, row)
    corner(track, 20)
    local knob = make("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, enabled and 21 or 3, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = Color3.fromRGB(248, 248, 255),
        BorderSizePixel = 0,
        ZIndex = 11,
    }, track)
    corner(knob, 20)

    local function setValue(value, shouldCallback)
        enabled = value == true
        tween(track, 0.18, { BackgroundColor3 = enabled and Theme.Purple or Theme.Surface3 })
        tween(knob, 0.18, { Position = UDim2.new(0, enabled and 21 or 3, 0.5, 0) })
        if shouldCallback and type(config.Callback) == "function" then
            local ok, err = pcall(config.Callback, enabled)
            if not ok then warn("[4D] Toggle callback error:", err) end
        end
    end

    addConnection(self._tab._window, track.Activated:Connect(function()
        setValue(not enabled, true)
    end))

    return {
        Set = function(_, value) setValue(value, false) end,
        Get = function() return enabled end,
    }
end

function Section:CreateSlider(config)
    config = normalizeControlConfig(config)
    local minimum = tonumber(config.Range and config.Range[1]) or 0
    local maximum = tonumber(config.Range and config.Range[2]) or 100
    if maximum < minimum then minimum, maximum = maximum, minimum end
    local step = math.max(0.0001, tonumber(config.Increment) or 1)
    local value = math.clamp(tonumber(config.CurrentValue) or minimum, minimum, maximum)
    local row = createControlRow(self, 58)

    local title = createLabel(row, config.Name or "Slider", 11, Theme.Text, Enum.Font.GothamSemibold)
    title.Position = UDim2.fromOffset(0, 0)
    title.Size = UDim2.new(1, -65, 0, 20)
    title.ZIndex = 10

    local valueLabel = createLabel(row, tostring(value), 10, Theme.Cyan, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.Size = UDim2.fromOffset(60, 20)
    valueLabel.ZIndex = 10

    local bar = make("TextButton", {
        Position = UDim2.new(0, 0, 0, 34),
        Size = UDim2.new(1, 0, 0, 7),
        BackgroundColor3 = Theme.Surface3,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, row)
    corner(bar, 10)
    local fill = make("Frame", {
        Name = "SliderFill",
        Size = UDim2.new(maximum == minimum and 0 or (value - minimum) / (maximum - minimum), 0, 1, 0),
        BackgroundColor3 = Theme.Purple,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, bar)
    corner(fill, 10)
    gradient(fill, { Theme.Purple, Theme.Blue, Theme.Cyan }, 0)

    local dragging = false
    local function setFromX(x, shouldCallback)
        local width = math.max(1, bar.AbsoluteSize.X)
        local alpha = math.clamp((x - bar.AbsolutePosition.X) / width, 0, 1)
        local raw = minimum + (maximum - minimum) * alpha
        value = math.clamp(minimum + math.floor(((raw - minimum) / step) + 0.5) * step, minimum, maximum)
        local decimals = step < 1 and math.min(4, math.ceil(-math.log10(step))) or 0
        local multiplier = 10 ^ decimals
        value = math.floor(value * multiplier + 0.5) / multiplier
        valueLabel.Text = tostring(value)
        tween(fill, 0.08, { Size = UDim2.new(maximum == minimum and 0 or (value - minimum) / (maximum - minimum), 0, 1, 0) })
        if shouldCallback and type(config.Callback) == "function" then
            local ok, err = pcall(config.Callback, value)
            if not ok then warn("[4D] Slider callback error:", err) end
        end
    end

    addConnection(self._tab._window, bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X, true)
        end
    end))
    addConnection(self._tab._window, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X, true)
        end
    end))
    addConnection(self._tab._window, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    return {
        Set = function(_, newValue)
            setFromX(bar.AbsolutePosition.X + bar.AbsoluteSize.X * ((math.clamp(tonumber(newValue) or minimum, minimum, maximum) - minimum) / math.max(0.0001, maximum - minimum)), false)
        end,
        Get = function() return value end,
    }
end

function Section:CreateDropdown(config)
    config = normalizeControlConfig(config)
    local options = config.Options or {}
    local selected = config.CurrentOption or options[1] or "Select"
    local row = createControlRow(self, 45)
    addControlText(row, config)

    local button = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(130, 30),
        BackgroundColor3 = Theme.Surface3,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex = 12,
    }, row)
    corner(button, 8)
    stroke(button, Theme.Stroke, 0.65, 1)

    local selectedLabel = createLabel(button, tostring(selected), 9, Theme.Text, Enum.Font.GothamMedium)
    selectedLabel.Position = UDim2.fromOffset(9, 0)
    selectedLabel.Size = UDim2.new(1, -28, 1, 0)
    selectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
    selectedLabel.ZIndex = 13

    local arrow = createLabel(button, "⌄", 14, Theme.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    arrow.Position = UDim2.new(1, -23, 0, 0)
    arrow.Size = UDim2.fromOffset(19, 30)
    arrow.ZIndex = 13

    local popupHeight = math.min(math.max(#options, 1), 5) * 29 + 8
    local popup = make("ScrollingFrame", {
        Name = "DropdownPopup",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(130, popupHeight),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Purple,
        CanvasSize = UDim2.fromOffset(0, #options * 29 + 8),
        Visible = false,
        ZIndex = 500,
    }, self._tab._window.ScreenGui)
    corner(popup, 9)
    stroke(popup, Theme.Stroke, 0.2, 1)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
    }, popup)
    make("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, popup)

    local function setOption(option, shouldCallback)
        selected = option
        selectedLabel.Text = tostring(option)
        popup.Visible = false
        if self._tab._window._openPopup == popup then self._tab._window._openPopup = nil end
        arrow.Text = "⌄"
        if shouldCallback and type(config.Callback) == "function" then
            local ok, err = pcall(config.Callback, selected)
            if not ok then warn("[4D] Dropdown callback error:", err) end
        end
    end

    for index, option in ipairs(options) do
        local optionButton = make("TextButton", {
            Name = "Option_" .. tostring(index),
            Size = UDim2.new(1, -2, 0, 27),
            BackgroundColor3 = Theme.Surface2,
            BackgroundTransparency = 0,
            Text = tostring(option),
            TextColor3 = option == selected and Theme.Cyan or Theme.Text,
            TextSize = 9,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            LayoutOrder = index,
            ZIndex = 501,
        }, popup)
        corner(optionButton, 6)
        make("UIPadding", { PaddingLeft = UDim.new(0, 8) }, optionButton)
        addConnection(self._tab._window, optionButton.MouseEnter:Connect(function()
            tween(optionButton, 0.12, { BackgroundColor3 = Theme.Surface3 })
        end))
        addConnection(self._tab._window, optionButton.MouseLeave:Connect(function()
            tween(optionButton, 0.12, { BackgroundColor3 = Theme.Surface2 })
        end))
        addConnection(self._tab._window, optionButton.Activated:Connect(function()
            setOption(option, true)
        end))
    end

    addConnection(self._tab._window, button.Activated:Connect(function()
        local window = self._tab._window
        local willOpen = not popup.Visible
        if window._openPopup and window._openPopup ~= popup then window._openPopup.Visible = false end
        popup.Visible = willOpen
        window._openPopup = willOpen and popup or nil
        arrow.Text = popup.Visible and "⌃" or "⌄"
        if popup.Visible then
            local absolute = button.AbsolutePosition
            local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
            local popupWidth = math.min(170, math.max(112, viewport.X - 16))
            local popupX = math.clamp(absolute.X + button.AbsoluteSize.X - popupWidth, 8, math.max(8, viewport.X - popupWidth - 8))
            local belowY = absolute.Y + button.AbsoluteSize.Y + 5
            local aboveY = absolute.Y - popupHeight - 5
            local popupY = belowY + popupHeight <= viewport.Y - 8 and belowY or math.max(8, aboveY)
            popup.Size = UDim2.fromOffset(popupWidth, 0)
            popup.Position = UDim2.fromOffset(popupX, popupY)
            tween(button, 0.12, { BackgroundColor3 = Theme.Surface3:Lerp(Theme.Purple, 0.16) })
            tween(popup, 0.20, {Size = UDim2.fromOffset(popupWidth, popupHeight)}, Enum.EasingStyle.Back)
        else
            tween(button, 0.12, { BackgroundColor3 = Theme.Surface3 })
        end
    end))

    return {
        Set = function(_, newValue)
            if table.find(options, newValue) then setOption(newValue, false) end
        end,
        Get = function() return selected end,
    }
end

function Section:CreateTextbox(config)
    config = normalizeControlConfig(config)
    local row = createControlRow(self, 47)
    addControlText(row, config)

    local box = make("TextBox", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(150, 31),
        BackgroundColor3 = Theme.Surface3,
        Text = tostring(config.CurrentValue or ""),
        PlaceholderText = config.PlaceholderText or "Enter text...",
        PlaceholderColor3 = Theme.Soft,
        TextColor3 = Theme.Text,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, row)
    corner(box, 8)
    stroke(box, Theme.Stroke, 0.65, 1)
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 9),
        PaddingRight = UDim.new(0, 9),
    }, box)

    addConnection(self._tab._window, box.FocusLost:Connect(function(enterPressed)
        if type(config.Callback) == "function" then
            local ok, err = pcall(config.Callback, box.Text, enterPressed)
            if not ok then warn("[4D] Textbox callback error:", err) end
        end
    end))
    return box
end

function Section:CreateParagraph(config)
    config = normalizeControlConfig(config)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = self._order,
        ZIndex = 9,
    }, self._card)
    self._order += 1
    self._lastElementRow = row
    self._controls = self._controls or {}
    table.insert(self._controls, row)

    local title = createLabel(row, config.Title or "Information", 11, Theme.Text, Enum.Font.GothamSemibold)
    title.Size = UDim2.new(1, 0, 0, 18)
    title.ZIndex = 10

    local body = createLabel(row, config.Content or "", 10, Theme.Muted, Enum.Font.Gotham)
    body.Position = UDim2.fromOffset(0, 21)
    body.Size = UDim2.new(1, 0, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.TextWrapped = true
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.ZIndex = 10
    return { Title = title, Content = body }
end


-- Additional components ------------------------------------------------------

function Section:CreateKeybind(config)
    config = normalizeControlConfig(config)
    local row = createControlRow(self, 43)
    addControlText(row, config)
    local currentKey = config.CurrentKey or config.DefaultKey or Enum.KeyCode.RightControl
    if typeof(currentKey) ~= "EnumItem" or currentKey.EnumType ~= Enum.KeyCode then
        currentKey = Enum.KeyCode.RightControl
    end
    local listening = false
    local keyButton = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(112, 29),
        BackgroundColor3 = Theme.Surface3,
        Text = currentKey.Name,
        TextColor3 = Theme.Text,
        TextSize = 9,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex = 12,
    }, row)
    corner(keyButton, 8)
    stroke(keyButton, Theme.Stroke, 0.65, 1)

    addConnection(self._tab._window, keyButton.Activated:Connect(function()
        listening = true
        keyButton.Text = "Press a key..."
        tween(keyButton, 0.12, { BackgroundColor3 = Theme.Purple })
    end))
    addConnection(self._tab._window, UserInputService.InputBegan:Connect(function(input, processed)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
                currentKey = input.KeyCode
                keyButton.Text = currentKey.Name
                listening = false
                tween(keyButton, 0.12, { BackgroundColor3 = Theme.Surface3 })
                if type(config.OnChanged) == "function" then
                    local ok, err = pcall(config.OnChanged, currentKey)
                    if not ok then warn("[4D] Keybind OnChanged error:", err) end
                end
            end
            return
        end
        if not processed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
            if type(config.Callback) == "function" then
                local ok, err = pcall(config.Callback, currentKey)
                if not ok then warn("[4D] Keybind callback error:", err) end
            end
        end
    end))
    return {
        Set = function(_, key)
            if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
                currentKey = key
                keyButton.Text = key.Name
            end
        end,
        Get = function() return currentKey end,
    }
end

function Section:CreateColorPicker(config)
    config = normalizeControlConfig(config)
    local row = createControlRow(self, 43)
    addControlText(row, config)
    local currentColor = typeof(config.CurrentValue) == "Color3" and config.CurrentValue or Theme.Purple
    local colors = {
        Color3.fromRGB(155, 112, 255), Color3.fromRGB(91, 153, 255),
        Color3.fromRGB(105, 220, 255), Color3.fromRGB(112, 224, 168),
        Color3.fromRGB(255, 190, 92), Color3.fromRGB(255, 112, 133),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(130, 137, 160),
        Color3.fromRGB(35, 38, 54), Color3.fromRGB(255, 105, 180),
        Color3.fromRGB(180, 220, 110), Color3.fromRGB(80, 190, 170),
        Color3.fromRGB(255, 80, 80), Color3.fromRGB(255, 145, 65),
        Color3.fromRGB(255, 220, 90), Color3.fromRGB(185, 255, 110),
        Color3.fromRGB(70, 220, 150), Color3.fromRGB(55, 190, 210),
        Color3.fromRGB(70, 125, 245), Color3.fromRGB(110, 85, 220),
        Color3.fromRGB(190, 90, 245), Color3.fromRGB(245, 90, 190),
        Color3.fromRGB(245, 205, 220), Color3.fromRGB(220, 205, 180),
        Color3.fromRGB(120, 90, 70), Color3.fromRGB(35, 35, 42),
    }
    local swatch = make("TextButton", {
        Name = "ColorSwatch",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(36, 26),
        BackgroundColor3 = currentColor,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex = 12,
    }, row)
    corner(swatch, 7)
    stroke(swatch, Theme.Text, 0.55, 1)
    local palette = make("Frame", {
        Name = "ColorPalette",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(258, 264),
        BackgroundColor3 = Theme.Surface2,
        Visible = false,
        BorderSizePixel = 0,
        ZIndex = 500,
    }, self._tab._window.ScreenGui)
    palette.AnchorPoint = Vector2.new(0, 0)
    corner(palette, 9)
    stroke(palette, Theme.Stroke, 0.2, 1)
    local swatchGrid = make("Frame", {
        Name = "PresetColors",
        Position = UDim2.fromOffset(12, 34),
        Size = UDim2.new(1, -24, 0, 174),
        BackgroundTransparency = 1,
        ZIndex = 501,
    }, palette)
    make("UIGridLayout", {
        CellSize = UDim2.fromOffset(29, 27),
        CellPadding = UDim2.fromOffset(8, 7),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, swatchGrid)
    local hexInput = make("TextBox", {
        Name = "HexColorInput",
        Position = UDim2.fromOffset(12, 220),
        Size = UDim2.new(1, -24, 0, 30),
        BackgroundColor3 = Theme.Surface3,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        PlaceholderText = "HEX / #A46EFF",
        Text = "",
        TextColor3 = Theme.Text,
        PlaceholderColor3 = Theme.Soft,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 502,
    }, palette)
    corner(hexInput, 6)
    for index, color in ipairs(colors) do
        local colorButton = make("TextButton", {
            Name = "Color_" .. tostring(index),
            Size = UDim2.fromOffset(25, 25),
            BackgroundColor3 = color,
            Text = "",
            AutoButtonColor = false,
            BorderSizePixel = 0,
            LayoutOrder = index,
            ZIndex = 502,
        }, swatchGrid)
        corner(colorButton, 6)
        addConnection(self._tab._window, colorButton.Activated:Connect(function()
            currentColor = color
            tween(swatch, 0.16, { BackgroundColor3 = color })
            palette.Visible = false
            if self._tab._window._openPopup == palette then self._tab._window._openPopup = nil end
            if type(config.Callback) == "function" then
                local ok, err = pcall(config.Callback, color)
                if not ok then warn("[4D] ColorPicker callback error:", err) end
            end
        end))
    end
    addConnection(self._tab._window, hexInput.FocusLost:Connect(function()
        local hex = tostring(hexInput.Text or ""):gsub("#", ""):gsub("%s", "")
        if #hex == 3 then
            hex = hex:sub(1, 1):rep(2) .. hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2)
        end
        if #hex ~= 6 or not hex:match("^%x%x%x%x%x%x$") then
            hexInput.Text = ""
            return
        end
        local red = tonumber(hex:sub(1, 2), 16)
        local green = tonumber(hex:sub(3, 4), 16)
        local blue = tonumber(hex:sub(5, 6), 16)
        currentColor = Color3.fromRGB(red, green, blue)
        tween(swatch, 0.16, { BackgroundColor3 = currentColor })
        hexInput.Text = ""
        palette.Visible = false
        if self._tab._window._openPopup == palette then self._tab._window._openPopup = nil end
        if type(config.Callback) == "function" then
            local ok, err = pcall(config.Callback, currentColor)
            if not ok then warn("[4D] ColorPicker callback error:", err) end
        end
    end))
    addConnection(self._tab._window, swatch.Activated:Connect(function()
        local window = self._tab._window
        local willOpen = not palette.Visible
        if window._openPopup and window._openPopup ~= palette then window._openPopup.Visible = false end
        palette.Visible = willOpen
        window._openPopup = willOpen and palette or nil
        if palette.Visible then
            local absolute = swatch.AbsolutePosition
            local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
            local paletteWidth, paletteHeight = palette.AbsoluteSize.X, palette.AbsoluteSize.Y
            local rightX = absolute.X
            local leftX = absolute.X + swatch.AbsoluteSize.X - paletteWidth
            local paletteX
            if rightX + paletteWidth <= viewport.X - 8 then
                paletteX = rightX
            elseif leftX >= 8 then
                paletteX = leftX
            else
                paletteX = math.clamp(rightX, 8, math.max(8, viewport.X - paletteWidth - 8))
            end
            local belowY = absolute.Y + swatch.AbsoluteSize.Y + 8
            local aboveY = absolute.Y - paletteHeight - 8
            local paletteY = belowY + paletteHeight <= viewport.Y - 8 and belowY or math.max(8, aboveY)
            palette.Position = UDim2.fromOffset(paletteX, paletteY)
            hexInput:ReleaseFocus()
        end
    end))
    return {
        Set = function(_, color)
            if typeof(color) == "Color3" then
                currentColor = color
                swatch.BackgroundColor3 = color
            end
        end,
        Get = function() return currentColor end,
    }
end

function Section:CreateLabel(text)
    local row = createControlRow(self, 24)
    local label = createLabel(row, tostring(text or "Label"), 10, Theme.Muted, Enum.Font.GothamMedium)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.ZIndex = 10
    return label
end

function Section:CreateDivider()
    local row = createControlRow(self, 8)
    local line = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Stroke,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, row)
    return line
end


function Section:CreateImage(config)
    config = config or {}
    local height = math.clamp(tonumber(config.Height) or 132, 48, 360)
    local row = createControlRow(self, height)
    local image = make("ImageLabel", {
        Name = config.Name or "4D_Image",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 0,
        Image = config.Image or DEFAULT_ART,
        ImageTransparency = math.clamp(tonumber(config.ImageTransparency) or 0, 0, 1),
        ScaleType = config.ScaleType or Enum.ScaleType.Stretch,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, row)
    corner(image, math.clamp(tonumber(config.Radius) or 10, 0, 24))
    stroke(image, Theme.Stroke, 0.4, 1)
    if config.Caption then
        local caption = createLabel(image, config.Caption, 10, Theme.Text, Enum.Font.GothamBold)
        caption.Position = UDim2.new(0, 12, 1, -29)
        caption.Size = UDim2.new(1, -24, 0, 18)
        caption.ZIndex = 11
        local captionShade = make("Frame", {
            Size = UDim2.new(1, 0, 0, 48),
            Position = UDim2.new(0, 0, 1, -48),
            BackgroundColor3 = Theme.Background,
            BackgroundTransparency = 0.28,
            BorderSizePixel = 0,
            ZIndex = 10,
        }, image)
        gradient(captionShade, { Theme.Background, Theme.Background }, 90)
    end
    return image
end

-- Rayfield-like compatibility layer. AddGroupBox returns a Section-compatible
-- object and supports both Add* and Create* method names.
function Tab:AddGroupBox(name)
    return self:CreateSection(name)
end

Tab.CreateGroupBox = Tab.AddGroupBox
Tab.AddSection = Tab.CreateSection

function Window:AddTab(name, iconName, description)
    return self:CreateTab(name, iconName, description)
end

function Window:AddGroupBox(name)
    local tab = self._activeTab or self._tabs[1]
    if not tab then tab = self:CreateTab("Main", "◇", "Main controls") end
    return tab:AddGroupBox(name)
end

Window.Toggle = function(self)
    self:SetVisible(not self._visible)
end
Window.CreateTabLegacy = Window.AddTab
Window.CreateGroupBox = Window.AddGroupBox

Section.AddButton = Section.CreateButton
Section.AddToggle = Section.CreateToggle
Section.AddSlider = Section.CreateSlider
Section.AddDropdown = Section.CreateDropdown
Section.AddTextbox = Section.CreateTextbox
Section.AddInput = Section.CreateTextbox
Section.AddTextBox = Section.CreateTextbox
Section.AddParagraph = Section.CreateParagraph
Section.AddKeybind = Section.CreateKeybind
Section.AddColorPicker = Section.CreateColorPicker
Section.AddLabel = Section.CreateLabel
Section.AddDivider = Section.CreateDivider

function Window:_ReflowNotifications()
    local list = self._notifications or {}
    local height, gap, bottom = 82, 10, 22
    for index, entry in ipairs(list) do
        local toast = entry.Frame
        if toast and toast.Parent then
            local y = bottom + (#list - index) * (height + gap)
            toast.LayoutOrder = index
            tween(toast, 0.24, {Position=UDim2.new(1,-20,1,-y)}, Enum.EasingStyle.Quint)
        end
    end
end

function Window:_RemoveNotification(entry, instant)
    if not entry or entry.Removing then return end
    entry.Removing = true
    local list = self._notifications or {}
    for index = #list, 1, -1 do
        if list[index] == entry then table.remove(list,index); break end
    end
    local toast = entry.Frame
    if entry.QuestionTween then pcall(function() entry.QuestionTween:Cancel() end) end
    if toast and toast.Parent then
        if instant then
            toast:Destroy()
        else
            for _, child in ipairs(toast:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    tween(child,0.24,{TextTransparency=1},Enum.EasingStyle.Quint)
                elseif child:IsA("ImageLabel") or child:IsA("ImageButton") then
                    tween(child,0.24,{ImageTransparency=1},Enum.EasingStyle.Quint)
                elseif child:IsA("UIStroke") then
                    tween(child,0.24,{Transparency=1},Enum.EasingStyle.Quint)
                elseif child:IsA("GuiObject") then
                    tween(child,0.24,{BackgroundTransparency=1},Enum.EasingStyle.Quint)
                end
            end
            tween(toast,0.28,{Position=UDim2.new(1,42,toast.Position.Y.Scale,toast.Position.Y.Offset),BackgroundTransparency=1},Enum.EasingStyle.Quint)
            task.delay(0.31,function() if toast and toast.Parent then toast:Destroy() end end)
        end
    end
    self:_ReflowNotifications()
end

function Window:Notify(config)
    if self._destroyed or not self.ScreenGui then return nil end
    config = config or {}
    local list = self._notifications
    local accent = Theme.Cyan
    local kind = string.lower(tostring(config.Type or config.Kind or "info"))
    if kind == "success" then accent = Theme.Good
    elseif kind == "error" or kind == "danger" then accent = Theme.Danger
    elseif kind == "warning" then accent = Color3.fromRGB(255,190,86) end

    self._notificationSerial = (self._notificationSerial or 0) + 1
    local entry = {Id=self._notificationSerial,Removing=false}
    local toast = make("Frame", {
        Name="779_Notification_"..tostring(entry.Id), AnchorPoint=Vector2.new(1,1),
        Position=UDim2.new(1,340,1,-22), Size=UDim2.fromOffset(300,82),
        BackgroundColor3=Theme.Surface, BackgroundTransparency=Theme.CardTransparency or 0.04,
        BorderSizePixel=0, ClipsDescendants=true, Active=true, ZIndex=300+entry.Id,
    },self.ScreenGui)
    entry.Frame=toast
    corner(toast,13)
    local toastStroke = stroke(toast,Theme.Stroke,0.18,1)
    play779Sound(M779_CONFIG.NotificationSoundId or "131390520971848", 0.48)
    local hoverHint = createLabel(toast,"?",13,Theme.Cyan,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    hoverHint.AnchorPoint=Vector2.new(1,0)
    hoverHint.Position=UDim2.new(1,-12,0,10)
    hoverHint.Size=UDim2.fromOffset(20,20)
    hoverHint.ZIndex=toast.ZIndex+5
    local hintTooltip=make("TextLabel",{Name="HelpTooltip",AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-10,0,32),Size=UDim2.fromOffset(174,25),BackgroundColor3=Theme.Surface3,BackgroundTransparency=0.05,Text="Click to dismiss this notice",TextColor3=Theme.Text,TextSize=9,Font=Enum.Font.GothamMedium,Visible=false,BorderSizePixel=0,ZIndex=toast.ZIndex+8},toast)
    corner(hintTooltip,7); stroke(hintTooltip,Theme.Stroke,0.2,1)
    addConnection(self,toast.MouseEnter:Connect(function()
        if entry.Removing then return end
        tween(toast,0.16,{BackgroundColor3=Theme.Surface3,BackgroundTransparency=0.01},Enum.EasingStyle.Quad)
        if toastStroke then tween(toastStroke,0.16,{Color=accent,Transparency=0.02,Thickness=1.7}) end
        tween(hoverHint,0.16,{TextColor3=accent,TextSize=16})
        hintTooltip.Visible=true
    end))
    addConnection(self,toast.MouseLeave:Connect(function()
        if entry.Removing then return end
        tween(toast,0.16,{BackgroundColor3=Theme.Surface,BackgroundTransparency=Theme.CardTransparency or 0.04},Enum.EasingStyle.Quad)
        if toastStroke then tween(toastStroke,0.16,{Color=Theme.Stroke,Transparency=0.18,Thickness=1}) end
        tween(hoverHint,0.16,{TextColor3=Theme.Cyan,TextSize=13})
        hintTooltip.Visible=false
    end))
    addConnection(self,toast.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            self:_RemoveNotification(entry,false)
        end
    end))
    local questionSpin=TweenService:Create(hoverHint,TweenInfo.new(3.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Rotation=14})
    questionSpin:Play()
    entry.QuestionTween=questionSpin
    local rail=make("Frame",{Position=UDim2.fromOffset(0,10),Size=UDim2.new(0,3,1,-20),BackgroundColor3=accent,BorderSizePixel=0,ZIndex=toast.ZIndex+1},toast)
    corner(rail,4)
    local symbol = kind=="success" and "✓" or (kind=="error" or kind=="danger") and "×" or kind=="warning" and "!" or "i"
    local iconHolder=make("Frame",{Position=UDim2.fromOffset(14,16),Size=UDim2.fromOffset(27,27),BackgroundColor3=accent,BackgroundTransparency=0.82,BorderSizePixel=0,ZIndex=toast.ZIndex+1},toast)
    corner(iconHolder,9)
    local iconLabel=createLabel(iconHolder,symbol,14,accent,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    iconLabel.ZIndex=toast.ZIndex+2
    local heading=createLabel(toast,tostring(config.Title or "779 Notification"),12,Theme.Text,Enum.Font.GothamBold)
    heading.Position=UDim2.fromOffset(51,14); heading.Size=UDim2.new(1,-68,0,19); heading.ZIndex=toast.ZIndex+2
    local message=createLabel(toast,tostring(config.Content or config.Message or "Something happened."),10,Theme.Muted,Enum.Font.Gotham)
    message.Position=UDim2.fromOffset(51,36); message.Size=UDim2.new(1,-66,0,32)
    message.TextWrapped=true; message.TextTruncate=Enum.TextTruncate.AtEnd
    message.TextYAlignment=Enum.TextYAlignment.Top; message.ZIndex=toast.ZIndex+2
    local progressBack=make("Frame",{Position=UDim2.new(0,14,1,-5),Size=UDim2.new(1,-28,0,2),BackgroundColor3=Theme.Surface3,BorderSizePixel=0,ZIndex=toast.ZIndex+1},toast)
    corner(progressBack,3)
    local progress=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=accent,BorderSizePixel=0,ZIndex=toast.ZIndex+2},progressBack)
    corner(progress,3)

    table.insert(list,entry)
    while #list > (self._notificationLimit or 5) do self:_RemoveNotification(list[1],false) end
    tween(toast,0.32,{Position=UDim2.new(1,-20,1,-22)},Enum.EasingStyle.Back)
    self:_ReflowNotifications()
    local duration=math.clamp(tonumber(config.Duration) or 3.5,1,20)
    tween(progress,duration,{Size=UDim2.new(0,0,1,0)},Enum.EasingStyle.Linear,Enum.EasingDirection.In)
    task.delay(duration,function()
        if not self._destroyed and not entry.Removing then self:_RemoveNotification(entry,false) end
    end)
    return toast
end


function Window:StartAmbientAnimations()
    if self._destroyed or self._ambientStarted or not self.Main then return false end
    self._ambientStarted = true
    self._ambientTweens = self._ambientTweens or {}
    self._ambientConnections = self._ambientConnections or {}
    local function track(animation)
        self._ambientTweens[#self._ambientTweens + 1] = animation
        animation:Play()
    end
    for _, object in ipairs(self.Main:GetDescendants()) do
        if object:IsA("UIGradient") then
            local targetOffset = Vector2.new(0.32, 0)
            local shimmer = TweenService:Create(object,
                TweenInfo.new(5.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Offset = targetOffset})
            track(shimmer)
        elseif object:IsA("UIStroke") then
            local original = object.Transparency
            local pulse = TweenService:Create(object,
                TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Transparency = math.clamp(original + 0.12, 0, 0.92)})
            track(pulse)
        elseif object:IsA("TextButton") or object:IsA("ImageButton") then
            local scale = object:FindFirstChildOfClass("UIScale")
            if not scale then
                scale = make("UIScale", {Scale = 1}, object)
            end
            local enter = object.MouseEnter:Connect(function()
                if object.Parent and not self._destroyed then
                    tween(scale, 0.16, {Scale = 1.035}, Enum.EasingStyle.Quint)
                end
            end)
            local leave = object.MouseLeave:Connect(function()
                if object.Parent and not self._destroyed then
                    tween(scale, 0.19, {Scale = 1}, Enum.EasingStyle.Quint)
                end
            end)
            self._ambientConnections[#self._ambientConnections + 1] = enter
            self._ambientConnections[#self._ambientConnections + 1] = leave
        end
    end
    return true
end

function Window:StopAmbientAnimations()
    for _, animation in ipairs(self._ambientTweens or {}) do
        pcall(function() animation:Cancel() end)
    end
    self._ambientTweens = {}
    for _, connection in ipairs(self._ambientConnections or {}) do
        pcall(function() connection:Disconnect() end)
    end
    self._ambientConnections = {}
    self._ambientStarted = false
    return true
end

function Window:GetTheme()
    return self._themeName, table.clone(self._theme or Theme)
end

local function colorDistance(a, b)
    local dr, dg, db = a.R - b.R, a.G - b.G, a.B - b.B
    return dr * dr + dg * dg + db * db
end

local function nearestThemeColor(color, sourceTheme, targetTheme, keys)
    if typeof(color) ~= "Color3" then return color end
    local bestKey, bestDistance = nil, math.huge
    for _, key in ipairs(keys) do
        local candidate = sourceTheme[key]
        if typeof(candidate) == "Color3" then
            local distance = colorDistance(color, candidate)
            if distance < bestDistance then bestDistance, bestKey = distance, key end
        end
    end
    -- Do not force arbitrary custom colors into the nearest palette token.
    -- Only migrate a color when it is effectively an exact match to an old token.
    if bestKey and bestDistance <= 0.00002 and typeof(targetTheme[bestKey]) == "Color3" then
        return targetTheme[bestKey]
    end
    return color
end

function Window:SetTheme(themeName, overrides)
    if self._destroyed or not self.ScreenGui then return false end
    local oldTheme = self._theme or Theme
    self._themeApplyToken = (self._themeApplyToken or 0) + 1
    local applyToken = self._themeApplyToken
    self._themeTweens = self._themeTweens or {}
    local function themeTween(object, duration, properties)
        if not object or not object.Parent or self._destroyed or applyToken ~= self._themeApplyToken then return nil end
        local objectTweens = self._themeTweens[object]
        if not objectTweens then objectTweens = {}; self._themeTweens[object] = objectTweens end
        local lastAnimation
        -- Track each property independently: changing a frame's color must not
        -- cancel its simultaneous transparency transition.
        for property, targetValue in pairs(properties) do
            local previous = objectTweens[property]
            if previous then pcall(function() previous:Cancel() end) end
            local animation = TweenService:Create(object,
                TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {[property] = targetValue})
            objectTweens[property] = animation
            animation.Completed:Connect(function()
                if self._themeTweens and self._themeTweens[object]
                    and self._themeTweens[object][property] == animation then
                    self._themeTweens[object][property] = nil
                    if next(self._themeTweens[object]) == nil then self._themeTweens[object] = nil end
                end
            end)
            animation:Play()
            lastAnimation = animation
        end
        return lastAnimation
    end
    local requestedName = tostring(themeName or self._themeName or "Midnight")
    local effectiveOverrides = overrides
    if requestedName == "Custom" and type(effectiveOverrides) ~= "table" then
        effectiveOverrides = self._customTheme or M779_PREFERENCES.CustomTheme
    end
    local baseTheme = resolveTheme(requestedName, effectiveOverrides)
    local newTheme = applyStyle(baseTheme, self._styleName or "Glass")
    local backgroundKeys = {"Background", "Surface", "Surface2", "Surface3"}
    local textKeys = {"Text", "Muted", "Soft", "Purple", "Blue", "Cyan", "Good", "Danger"}
    local accentKeys = {"Purple", "Blue", "Cyan", "Stroke", "Good", "Danger"}
    for _, object in ipairs(self.ScreenGui:GetDescendants()) do
        pcall(function()
            local keepWhiteLogo = object:GetAttribute("4D_KeepWhiteLogo") == true
            if object:IsA("GuiObject") and object ~= self._backgroundArt and not keepWhiteLogo then
                -- Map each surface to its semantic role, not exact RGB equality.
                if object.Name == "PanelAccentHalo" or string.sub(object.Name, -10) == "AccentHalo" then
                    themeTween(object, 0.34, {BackgroundColor3 = newTheme.Purple})
                elseif object.Name == "PanelTopHighlight" then
                    themeTween(object, 0.34, {BackgroundColor3 = newTheme.Cyan})
                end
                if object.BackgroundTransparency < 0.995 then
                    local bestKey, bestDistance = nil, math.huge
                    for _, key in ipairs(backgroundKeys) do
                        local candidate = oldTheme[key]
                        if typeof(candidate) == "Color3" then
                            local distance = colorDistance(object.BackgroundColor3, candidate)
                            if distance < bestDistance then bestDistance, bestKey = distance, key end
                        end
                    end
                    if bestKey and bestDistance <= 0.00002 then
                        themeTween(object, 0.34, {BackgroundColor3 = newTheme[bestKey] or object.BackgroundColor3})
                        local transparencyKey = ({Background="WindowTransparency",Surface="PanelTransparency",Surface2="CardTransparency",Surface3="ButtonTransparency"})[bestKey]
                        if transparencyKey and newTheme[transparencyKey] ~= nil then
                            local targetTransparency = newTheme[transparencyKey]
                            if object:GetAttribute("4D_PanelSurface") == true then
                                targetTransparency = math.min(0.12, tonumber(targetTransparency) or 0.03)
                            end
                            themeTween(object, 0.34, {BackgroundTransparency = targetTransparency})
                        end
                    end
                end
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                    themeTween(object, 0.34, {TextColor3 = nearestThemeColor(object.TextColor3, oldTheme, newTheme, textKeys)})
                end
                if object:IsA("ImageLabel") or object:IsA("ImageButton") then
                    themeTween(object, 0.34, {ImageColor3 = nearestThemeColor(object.ImageColor3, oldTheme, newTheme, textKeys)})
                end
            end
            if object:IsA("UIStroke") then
                local styleName = string.lower(tostring(self._styleName or "glass"))
                local thickness = styleName == "neon" and 1.65 or styleName == "minimal" and 0.7 or styleName == "solid" and 1.15 or 1.3
                local transparency = styleName == "neon" and 0.08 or styleName == "minimal" and 0.58 or styleName == "solid" and 0.24 or 0.18
                local targetStrokeColor = object:GetAttribute("FourD_ThemeStroke") == true
                    and newTheme.Stroke or nearestThemeColor(object.Color, oldTheme, newTheme, accentKeys)
                themeTween(object, 0.34, {
                    Color = targetStrokeColor,
                    Thickness = thickness,
                    Transparency = transparency,
                })
            elseif object:IsA("ScrollingFrame") then
                themeTween(object, 0.34, {ScrollBarImageColor3 = nearestThemeColor(object.ScrollBarImageColor3, oldTheme, newTheme, accentKeys)})
            elseif object:IsA("UIGradient") then
                local points = {}
                for _, point in ipairs(object.Color.Keypoints) do
                    table.insert(points, ColorSequenceKeypoint.new(point.Time,
                        nearestThemeColor(point.Value, oldTheme, newTheme, textKeys)))
                end
                object.Color = ColorSequence.new(points)
            end
        end)
    end
    -- Re-apply known semantic surface transparencies to the window and its major layers.
    if self.Main and self.Main.Parent then
        themeTween(self.Main, 0.34, {BackgroundColor3 = newTheme.Background, BackgroundTransparency = newTheme.WindowTransparency or 0})
        self._mainBaseTransparency = newTheme.WindowTransparency or 0
    end
    if self._sidebar and self._sidebar.Parent then
        themeTween(self._sidebar, 0.34, {BackgroundColor3 = newTheme.Surface, BackgroundTransparency = newTheme.SidebarTransparency or 0})
    end
    -- Commit the new palette only after the previous theme transitions have been invalidated.
    if applyToken ~= self._themeApplyToken then return false end
    Theme = newTheme
    self._theme = newTheme
    self._themeName = requestedName
    if requestedName == "Custom" and type(effectiveOverrides)=="table" then
        self._customTheme = table.clone(effectiveOverrides)
        M779_PREFERENCES.CustomTheme = table.clone(self._customTheme)
    end
    self._gradientColors = {newTheme.Purple, newTheme.Blue, newTheme.Cyan}
    self:SetGradientColors(self._gradientColors)
    local presentation = THEME_PRESENTATIONS[requestedName]
    if presentation then
        self._themeAutoPresentation = true
        self:SetAnimation(presentation.Cutscene, false, true)
        self:SetCutsceneTextPreset(presentation.TextPreset, false, true)
    end
    if self._themeBadge and self._themeBadge.Parent then
        self._themeBadge.Text = string.upper(self._themeName .. " EDITION")
    end
    M779_PREFERENCES.Theme = requestedName
    save4DPreferences()
    return true
end

-- Runtime token editing keeps the existing Window:SetTheme pipeline and API intact.
function Window:SetThemeToken(token, value)
    if self._destroyed or not self.ScreenGui then return false, "window is unavailable" end
    if not THEME_COLOR_TOKENS[token] and not THEME_NUMBER_TOKENS[token] then
        return false, "unknown theme token"
    end
    local current = table.clone(self._theme or ThemePresets.Midnight)
    if THEME_COLOR_TOKENS[token] then
        if typeof(value) ~= "Color3" then return false, "color token requires Color3" end
    else
        value = tonumber(value)
        if not value or value < 0 or value > 1 then return false, "numeric token must be between 0 and 1" end
    end
    current[token] = value
    local targetName = "Custom"
    local ok = self:SetTheme(targetName, current)
    if ok then
        self._themeOverrides = current
        if targetName == "Custom" then
            self._customTheme = table.clone(current)
            M779_PREFERENCES.CustomTheme = table.clone(current)
            save4DPreferences()
        end
    end
    return ok
end

function Window:GetAppearance()
    if self._destroyed then return nil end
    return {
        Theme = self._themeName,
        Style = self._styleName,
        Font = self._fontName,
        CornerRadius = self._cornerRadius,
        WindowSize = self._targetSize and {Width=self._targetSize.X, Height=self._targetSize.Y} or nil,
        SidebarWidth = self._sidebarWidth,
        Transparency = self._mainBaseTransparency,
        AnimationSpeed = self._animationSpeed,
        SmoothAnimations = self._smoothAnimations,
        VisualEffects = self._visualEffects == true,
        ThemeTokens = table.clone(self._theme or {}),
    }
end

function Window:ApplyAppearance(appearance)
    if self._destroyed or type(appearance) ~= "table" then return false, "invalid appearance" end
    local errors = {}
    if appearance.Theme then
        local ok, reason = self:SetTheme(appearance.Theme, appearance.ThemeTokens)
        if not ok then table.insert(errors, "Theme: " .. tostring(reason)) end
    end
    if appearance.Style then
        local ok = self:SetStyle(appearance.Style)
        if not ok then table.insert(errors, "Style: rejected") end
    end
    if appearance.Font then
        local ok = self:SetFont(appearance.Font)
        if not ok then table.insert(errors, "Font: rejected") end
    end
    if appearance.CornerRadius ~= nil and not self:SetCornerRadius(appearance.CornerRadius) then
        table.insert(errors, "CornerRadius: rejected")
    end
    if type(appearance.WindowSize) == "table" then
        local size = appearance.WindowSize
        if not self:SetWindowSize(size.Width, size.Height) then table.insert(errors, "WindowSize: rejected") end
    end
    if appearance.SidebarWidth ~= nil and not self:SetSidebarWidth(appearance.SidebarWidth) then
        table.insert(errors, "SidebarWidth: rejected")
    end
    if appearance.Transparency ~= nil and not self:SetTransparency(appearance.Transparency) then
        table.insert(errors, "Transparency: rejected")
    end
    if appearance.AnimationSpeed ~= nil then self:SetAnimationSpeed(appearance.AnimationSpeed) end
    if appearance.SmoothAnimations ~= nil then self:SetSmoothAnimations(appearance.SmoothAnimations == true) end
    if appearance.VisualEffects ~= nil then self:SetVisualEffects(appearance.VisualEffects == true) end
    return #errors == 0, errors
end

function Window:CancelAnimations(groupName)
    if self._destroyed or not self._animationManager then return false end
    if groupName == nil then
        self._animationManager:CancelAll()
        self._animationManager = AnimationManager.new(self)
        return true
    end
    self._animationManager:CancelGroup(groupName)
    return true
end

function Window:SetLoadingStatus(message)
    if self._destroyed then return false end
    local label = self._loadingStatusLabel
    if label and label.Parent then
        label.Text = tostring(message or "")
        return true
    end
    return false
end

function Window:SetLoadingProgress(value, status)
    if self._destroyed then return false end
    local fill = self._loadingProgressFill
    if not fill or not fill.Parent then return false end
    local progress = math.clamp(tonumber(value) or 0, 0, 1)
    tween(fill, 0.25, { Size = UDim2.new(progress, 0, 1, 0) }, Enum.EasingStyle.Quint)
    if status ~= nil then self:SetLoadingStatus(status) end
    return true
end

function Window:SetAnimation(cutsceneName, previewNow, fromTheme)
    if self._destroyed then return false end
    local allowed = {none = true, starfall = true, waterfall = true, sakura = true}
    local name = string.lower(tostring(cutsceneName or "waterfall"))
    if not allowed[name] then return false end
    self._animationPreset = name
    if fromTheme ~= true then self._themeAutoPresentation = false end
    M779_PREFERENCES.IntroAutoTheme = fromTheme == true
    self._config = self._config or {}
    self._config.Animation = self._config.Animation or {}
    self._config.Animation.Intro = name
    M779_PREFERENCES.Intro = name
    save4DPreferences()
    if previewNow == true and self._introFinished and self._visible then
        return self:PlayCutscene(name)
    end
    return true
end

function Window:PreviewCutscene(cutsceneName)
    return self:SetAnimation(cutsceneName or self._animationPreset, true)
end

function Window:SetCutsceneTextPreset(presetName, previewNow, fromTheme)
    if self._destroyed then return false end
    local name = tostring(presetName or "Auto")
    if name == "Auto" then
        local presentation = THEME_PRESENTATIONS[self._themeName or "Midnight"] or THEME_PRESENTATIONS.Midnight
        name = presentation.TextPreset
    end
    if not CUTSCENE_TEXT_PRESETS[name] then return false end
    self._cutsceneTextPreset = name
    if fromTheme ~= true then self._themeAutoPresentation = false end
    M779_PREFERENCES.CutsceneTextAuto = fromTheme == true
    M779_PREFERENCES.CutsceneTextPreset = name
    self._config = self._config or {}
    self._config.CutsceneTextPreset = name
    save4DPreferences()
    if previewNow == true and self._introFinished and self._visible then
        return self:PlayCutscene(self._animationPreset)
    end
    return true
end

function Window:SetAnimationSpeed(value)
    if self._destroyed then return false end
    local speed = math.clamp(tonumber(value) or 1, 0.35, 2.5)
    self._animationSpeed = speed
    ANIMATION_SPEED = speed
    M779_PREFERENCES.AnimationSpeed = speed
    save4DPreferences()
    return speed
end

function Window:SetSmoothAnimations(enabled)
    if self._destroyed then return false end
    self._smoothAnimations = enabled == true
    SMOOTH_ANIMATIONS = self._smoothAnimations
    return self._smoothAnimations
end

function Window:SetVisualEffects(enabled)
    if self._destroyed then return false end
    VISUAL_EFFECTS_ENABLED = enabled == true
    self._visualEffects = VISUAL_EFFECTS_ENABLED
    return self._visualEffects
end

function Window:StopCutsceneSound(fadeDuration)
    local sound = self._cutsceneSound
    if self._cutsceneSoundFade then
        pcall(function() self._cutsceneSoundFade:Cancel() end)
        self._cutsceneSoundFade = nil
    end
    if not sound then return true end
    local duration = math.max(0, tonumber(fadeDuration) or 0)
    if duration <= 0 then
        self._cutsceneSound = nil
        pcall(function() sound:Stop(); sound:Destroy() end)
        return true
    end
    local ok, fade = pcall(function()
        return TweenService:Create(sound, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Volume = 0})
    end)
    if ok and fade then
        self._cutsceneSoundFade = fade
        fade:Play()
        task.delay(duration + 0.08, function()
            if self._cutsceneSound == sound then self._cutsceneSound = nil end
            if self._cutsceneSoundFade == fade then self._cutsceneSoundFade = nil end
            pcall(function() sound:Stop(); sound:Destroy() end)
        end)
    else
        self._cutsceneSound = nil
        pcall(function() sound:Stop(); sound:Destroy() end)
    end
    return true
end

function Window:StopCutscene()
    self:StopCutsceneSound(0)
    self._cutsceneToken = (self._cutsceneToken or 0) + 1
    if self._animationManager then self._animationManager:CancelGroup("cutscene") end
    for _, active in ipairs(self._cutsceneTweens or {}) do pcall(function() active:Cancel() end) end
    self._cutsceneTweens = {}
    if self._cutsceneOverlay then
        pcall(function() self._cutsceneOverlay:Destroy() end)
        self._cutsceneOverlay = nil
    end
    self._activeCutsceneName = nil
    -- Stopping an intro must never leave the library window hidden forever.
    if self._revealAfterCutscene and not self._destroyed and self.Main and self.Main.Parent then
        self._revealAfterCutscene = false
        self.Main.Visible = true
        self.Main.Size = UDim2.fromOffset(self._targetSize.X, self._targetSize.Y)
        if self._mainScale and self._mainScale.Parent then self._mainScale.Scale = 1 end
        self._introFinished = true
        if self._hud then self._hud.Visible = true end
        self._visible = true
    end
    return true
end

function Window:PlayCutscene(cutsceneName)
    if self._destroyed or not self.ScreenGui or not self.Main or not self._visible then return false end
    local name = string.lower(tostring(cutsceneName or self._animationPreset or "minimal"))
    local valid = {none=true, starfall=true, waterfall=true, sakura=true}
    if not valid[name] then return false end
    if self._activeCutsceneName == name and self._cutsceneOverlay and self._cutsceneOverlay.Parent then return true end
    -- Defensive singleton: destroy orphaned/duplicate overlays before starting a scene.
    for _, child in ipairs(self.ScreenGui:GetChildren()) do
        if child.Name == "4D_CutsceneOverlay" and child ~= self._cutsceneOverlay then
            pcall(function() child:Destroy() end)
        end
    end
    self._activeCutsceneName = name
    self._cutsceneToken = (self._cutsceneToken or 0) + 1
    local token = self._cutsceneToken
    if self._animationManager then self._animationManager:CancelGroup("cutscene") end
    for _, active in ipairs(self._cutsceneTweens or {}) do pcall(function() active:Cancel() end) end
    self._cutsceneTweens = {}
    self:StopCutsceneSound(0)
    if self._cutsceneOverlay then pcall(function() self._cutsceneOverlay:Destroy() end) end
    if name == "none" then
        self._activeCutsceneName = nil
        return true
    end

    local isStarfall = name == "starfall"
    local isWaterfall = name == "waterfall"
    local isButterflies = name == "butterflies"
    local isSakura = name == "sakura"
    local isMidnight = name == "midnight"
    local isPortal = name == "portal" or name == "cinematic"
    local overlay = make("Frame", {
        Name = "4D_CutsceneOverlay", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = (self._theme or Theme).Background, BackgroundTransparency = 1,
        BorderSizePixel = 0, Active = false, ZIndex = 200,
    }, self.ScreenGui)
    self._cutsceneOverlay = overlay
    -- A dedicated one-shot sound belongs to the active cutscene only.
    local cutsceneSoundId = normalizeAssetId(M779_CONFIG.CutsceneSoundId or "1841647093")
    if cutsceneSoundId then
        local soundOk, sound = pcall(function()
            local instance = Instance.new("Sound")
            instance.Name = "4D_CutsceneIntroSound"
            instance.SoundId = cutsceneSoundId
            instance.Volume = math.clamp(tonumber(M779_CONFIG.CutsceneSoundVolume) or 0.55, 0, 1)
            instance.Looped = false
            instance.Parent = game:GetService("SoundService")
            instance:Play()
            return instance
        end)
        if soundOk then self._cutsceneSound = sound end
    end
    -- Cutscene colors always inherit the active theme. Scene identity changes
    -- particle shapes and motion, never the user's selected palette.
    local activeTheme = self._theme or Theme or ThemePresets.Midnight
    local palette = self._gradientColors or {activeTheme.Purple, activeTheme.Blue, activeTheme.Cyan}

    local vignette = make("Frame", {
        Name="SceneVignette", Size=UDim2.fromScale(1,1), BackgroundColor3=(self._theme or Theme).Background,
        BackgroundTransparency=1, BorderSizePixel=0, ZIndex=200,
    }, overlay)
    local outerHalo = make("Frame", {
        Name="SceneOuterHalo", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.43),
        Size=UDim2.fromOffset(120,120), BackgroundColor3=palette[2] or palette[1],
        BackgroundTransparency=0.90, BorderSizePixel=0, ZIndex=200,
    }, overlay)
    corner(outerHalo, 200)
    gradient(outerHalo, {palette[1], palette[2] or palette[1], palette[3] or palette[1]}, 25)
    local glow = make("Frame", {
        Name="SceneCoreGlow", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.43),
        Size=UDim2.fromOffset(20,20), BackgroundColor3=palette[1], BackgroundTransparency=0.78,
        BorderSizePixel=0, ZIndex=201,
    }, overlay)
    corner(glow, 200)
    gradient(glow, palette, 35)
    local letterboxTop = make("Frame", {
        Name="SceneLetterboxTop", Size=UDim2.new(1,0,0,0),
        BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.12,
        BorderSizePixel=0, ZIndex=220,
    }, overlay)
    local letterboxBottom = make("Frame", {
        Name="SceneLetterboxBottom", AnchorPoint=Vector2.new(0,1), Position=UDim2.fromScale(0,1),
        Size=UDim2.new(1,0,0,0), BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.12, BorderSizePixel=0, ZIndex=220,
    }, overlay)
    local ringHolder = make("Frame", {
        Name="SceneOrbit", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.43),
        Size=UDim2.fromOffset(42,42), BackgroundTransparency=1, ZIndex=202,
    }, overlay)
    corner(ringHolder, 200)
    local orbitStroke = stroke(ringHolder, palette[3] or Theme.Cyan, 0.06, 1.8)
    local ring2 = make("Frame", {
        Name="SceneOrbitSecondary", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.43),
        Size=UDim2.fromOffset(66,66), BackgroundTransparency=1, ZIndex=202,
    }, overlay)
    corner(ring2, 200)
    local ring2Stroke = stroke(ring2, palette[1] or Theme.Purple, 0.25, 1.2)

    -- The original animated 4D tesseract is the primary brand mark in every scene.
    -- Keep it above decorative particles/rings so the logo remains unmistakable.
    local cutsceneLogoHolder = make("Frame", {
        Name="4D_PrimaryTesseractLogo", AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5,0.405), Size=UDim2.fromOffset(270,270),
        BackgroundTransparency=1, ZIndex=208,
    }, overlay)
    local cutsceneLogoScale = make("UIScale",{Scale=0.88},cutsceneLogoHolder)
    createTesseract(self,cutsceneLogoHolder,270,0.008)
    local logoHalo = make("Frame",{
        Name="4D_LogoHalo",AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5,0.405),Size=UDim2.fromOffset(292,292),
        BackgroundTransparency=1,ZIndex=207,
    },overlay)
    corner(logoHalo,200)
    stroke(logoHalo,palette[3] or Theme.Cyan,0.48,1.25)

    local textProfile = CUTSCENE_TEXT_PRESETS[self._cutsceneTextPreset or "Minimal779"] or CUTSCENE_TEXT_PRESETS.Minimal779
    local title = make("TextLabel", {
        Name="FourDTitle", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.69),
        Size=UDim2.new(0.9,0,0,52), BackgroundTransparency=1, Text=textProfile.Title or "MINIMAL",
        TextColor3=Color3.new(1,1,1), TextTransparency=1, TextSize=31, MaxVisibleGraphemes=0,
        TextStrokeTransparency=1, Font=Enum.Font.GothamBlack, ZIndex=210,
    }, overlay)
    local titleScale = make("UIScale", {Scale=0.82}, title)
    local titleAccent = make("Frame", {
        Name="CutsceneTitleAccent", AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5,0.728), Size=UDim2.new(0,0,0,2),
        BackgroundColor3=palette[2] or Theme.Cyan, BackgroundTransparency=0.08,
        BorderSizePixel=0, ZIndex=211,
    }, overlay)
    corner(titleAccent, 4)
    gradient(titleAccent, palette, 0)
    local subtitle = make("TextLabel", {
        Name="FourDSubtitle", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.755),
        Size=UDim2.new(0.9,0,0,24), BackgroundTransparency=1,
        Text=textProfile.Subtitle or "4D GUI", TextColor3=palette[3] or Theme.Cyan,
        TextTransparency=1, TextSize=13, MaxVisibleGraphemes=0, Font=Enum.Font.GothamBold, ZIndex=210,
    }, overlay)
    local caption = make("TextLabel", {
        Name="SceneCaption", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.80),
        Size=UDim2.new(0.9,0,0,22), BackgroundTransparency=1,
        Text=textProfile.Caption or (isStarfall and "A SKY FULL OF POSSIBILITIES" or isWaterfall and "FLOW BEYOND LIMITS"
            or isButterflies and "A NEW DIMENSION AWAKENS" or isSakura and "PETALS BETWEEN DIMENSIONS"
            or isMidnight and "THE COSMOS IS YOURS" or isPortal and "STEP THROUGH THE 4D PORTAL" or string.upper(name)),
        TextColor3=activeTheme.Muted or ThemePresets.Midnight.Muted, TextTransparency=1, TextSize=11, MaxVisibleGraphemes=0,
        Font=Enum.Font.Gotham, ZIndex=210,
    }, overlay)

    local auroraCurtains = {}
    if name == "aurora" then
        for band = 1, 9 do
            -- Tall translucent curtains create a true polar-light silhouette,
            -- rather than the old stack of flat horizontal bars.
            local x = 0.055 + (band-1)*0.112
            local ribbon = make("Frame", {
                Name="AuroraRibbon_"..tostring(band), AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(x,0,0.48+(band%3-1)*0.035,0),
                Size=UDim2.new(0,42+(band%4)*17,1.34,0),
                Rotation=(band%2==0 and -11 or 9),
                BackgroundColor3=palette[((band-1)%#palette)+1],
                BackgroundTransparency=0.91+(band%3)*0.018,
                BorderSizePixel=0,ZIndex=203,
            },overlay)
            local ribbonGradient=gradient(ribbon,{
                palette[((band-1)%#palette)+1],
                palette[(band%#palette)+1],
                palette[((band+1)%#palette)+1],
            },90)
            ribbonGradient.Transparency=NumberSequence.new({
                NumberSequenceKeypoint.new(0,1),
                NumberSequenceKeypoint.new(0.16,0.72),
                NumberSequenceKeypoint.new(0.42,0.18),
                NumberSequenceKeypoint.new(0.68,0.34),
                NumberSequenceKeypoint.new(0.88,0.78),
                NumberSequenceKeypoint.new(1,1),
            })
            corner(ribbon,60)
            auroraCurtains[#auroraCurtains+1]=ribbon
        end
    end

    local particles = {}
    -- Richer scenes: more independent moving elements, while keeping a safe cap
    -- for executor/client performance on lower-end devices.
    local particleCount = isStarfall and 132 or isWaterfall and 112 or isButterflies and 42
        or isSakura and 96 or isMidnight and 118 or isPortal and 82 or name == "aurora" and 72 or 52
    particleCount = math.min(particleCount, 140)
    if name == "fade" or name == "minimal" then particleCount = 0 end
    for i=1, particleCount do
        local particle
        if isWaterfall then
            local width = math.random(1,3)
            particle = make("Frame", {
                Name="WaterfallStream", AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(math.random(4,96)/100,0,math.random(-30,110)/100,0),
                Size=UDim2.fromOffset(width, math.random(18,52)),
                BackgroundColor3=palette[(i%#palette)+1], BackgroundTransparency=math.random(20,55)/100,
                BorderSizePixel=0, Rotation=math.random(-4,4), ZIndex=204,
            }, overlay)
            corner(particle, 4)
        elseif isButterflies then
            particle = make("Frame", {
                Name="Butterfly", AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(math.random(5,95)/100,0,math.random(10,95)/100,0),
                Size=UDim2.fromOffset(math.random(24,34),math.random(20,28)),
                BackgroundTransparency=1, Rotation=math.random(-25,25), ZIndex=205,
            }, overlay)
            local wingColor = palette[(i%#palette)+1]
            local leftWing = make("Frame", {
                Name="LeftWing", AnchorPoint=Vector2.new(0.5,1), Position=UDim2.new(0.43,0,0.62,0),
                Size=UDim2.fromOffset(12,15), BackgroundColor3=wingColor, BackgroundTransparency=0.12,
                BorderSizePixel=0, Rotation=-18, ZIndex=206,
            }, particle)
            corner(leftWing, 10)
            local rightWing = make("Frame", {
                Name="RightWing", AnchorPoint=Vector2.new(0.5,1), Position=UDim2.new(0.57,0,0.62,0),
                Size=UDim2.fromOffset(12,15), BackgroundColor3=wingColor, BackgroundTransparency=0.12,
                BorderSizePixel=0, Rotation=18, ZIndex=206,
            }, particle)
            corner(rightWing, 10)
            local body = make("Frame", {
                Name="ButterflyBody", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.55),
                Size=UDim2.fromOffset(2,13), BackgroundColor3=Color3.fromRGB(245,242,255),
                BorderSizePixel=0, ZIndex=207,
            }, particle)
            corner(body, 4)
            local flapLeft = TweenService:Create(leftWing,TweenInfo.new(0.22,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Rotation=-38})
            local flapRight = TweenService:Create(rightWing,TweenInfo.new(0.22,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Rotation=38})
            flapLeft:Play(); flapRight:Play()
            self._cutsceneTweens[#self._cutsceneTweens+1]=flapLeft
            self._cutsceneTweens[#self._cutsceneTweens+1]=flapRight
            if self._animationManager then
                self._animationManager:Track("cutscene", flapLeft)
                self._animationManager:Track("cutscene", flapRight)
            end
        else
            local glyph = isSakura and (i%3==0 and "✿" or "❀")
                or (isPortal and (i%3==0 and "◇" or "✧"))
                or (isMidnight and (i%5==0 and "✧" or i%2==0 and "✦" or "·"))
                or (isStarfall and (i%5==0 and "✧" or i%3==0 and "✦" or "·"))
                or (name=="aurora" and "✧" or "•")
            particle = make("TextLabel", {
                Name=isSakura and "SakuraPetal" or isMidnight and "MidnightStar" or "StarfallParticle", AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(math.random(),0,isSakura and math.random(-20,-5)/100 or math.random(-15,95)/100,0),
                Size=UDim2.fromOffset(math.random(8,22),math.random(8,22)),
                BackgroundTransparency=1, Text=glyph, TextColor3=palette[(i%#palette)+1],
                TextTransparency=math.random(8,35)/100, TextSize=isSakura and math.random(17,29) or math.random(12,24),
                Rotation=math.random(0,360), ZIndex=204,
            }, overlay)
        end
        particles[#particles+1]=particle
    end

    local speed = math.max(0.35, self._animationSpeed or 1)
    local function play(obj, duration, props, style, direction)
        if self._animationManager then
            return self._animationManager:Play("cutscene", obj, duration, props, style or Enum.EasingStyle.Quint, direction)
        end
        return tween(obj, duration, props, style or Enum.EasingStyle.Quint, direction)
    end
    play(overlay, 0.42, {BackgroundTransparency=0.48}, Enum.EasingStyle.Sine)
    play(vignette, 0.5, {BackgroundTransparency=0.62}, Enum.EasingStyle.Sine)
    play(outerHalo, 1.25, {Size=UDim2.fromOffset(540,540), BackgroundTransparency=0.96})
    play(glow, 1.05, {Size=UDim2.fromOffset(isStarfall and 470 or isWaterfall and 360 or 410, isStarfall and 470 or isWaterfall and 360 or 410), BackgroundTransparency=0.91})
    play(letterboxTop, 0.62, {Size=UDim2.new(1,0,0,34)}, Enum.EasingStyle.Quint)
    play(letterboxBottom, 0.62, {Size=UDim2.new(1,0,0,34)}, Enum.EasingStyle.Quint)
    play(ringHolder, 1.15, {Size=UDim2.fromOffset(520,520), Rotation=220})
    play(ring2, 1.45, {Size=UDim2.fromOffset(650,650), Rotation=-180})
    play(orbitStroke, 1.1, {Transparency=0.88, Thickness=0.8})
    play(ring2Stroke, 1.25, {Transparency=0.92, Thickness=0.6})
    for band, ribbon in ipairs(auroraCurtains) do
        local drift=(band%2==0) and 0.035 or -0.035
        play(ribbon,1.65+band*0.11,{
            Position=UDim2.new(math.clamp(ribbon.Position.X.Scale+drift,0.02,0.98),0,
                ribbon.Position.Y.Scale+(band%2==0 and 0.025 or -0.025),0),
            Rotation=ribbon.Rotation+(band%2==0 and 5 or -5),
            BackgroundTransparency=0.78+(band%3)*0.025,
        },Enum.EasingStyle.Sine)
        local ribbonGradient=ribbon:FindFirstChildOfClass("UIGradient")
        if ribbonGradient then
            local shimmer=TweenService:Create(ribbonGradient,TweenInfo.new(2.2+band*0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Offset=Vector2.new((band%2==0) and 0.65 or -0.65,0)})
            shimmer:Play()
            self._cutsceneTweens[#self._cutsceneTweens+1]=shimmer
            if self._animationManager then self._animationManager:Track("cutscene", shimmer) end
        end
    end
    -- Cinematic text: slide + fade + per-grapheme reveal + soft glow.
    play(title, 0.82/speed, {TextTransparency=0, Position=UDim2.fromScale(0.5,0.65),
        MaxVisibleGraphemes=#title.Text, TextStrokeTransparency=1}, Enum.EasingStyle.Quint)
    play(titleScale, 0.86/speed, {Scale=1}, Enum.EasingStyle.Back)
    play(titleAccent, 0.72/speed, {Size=UDim2.new(0.38,0,0,2)}, Enum.EasingStyle.Quint)
    task.delay(0.18/speed, function()
        if self._destroyed or token~=self._cutsceneToken or not subtitle.Parent then return end
        play(subtitle, 0.78/speed, {TextTransparency=0, Position=UDim2.fromScale(0.5,0.715),
            MaxVisibleGraphemes=#subtitle.Text}, Enum.EasingStyle.Quint)
    end)
    task.delay(0.38/speed, function()
        if self._destroyed or token~=self._cutsceneToken or not caption.Parent then return end
        play(caption, 0.72/speed, {TextTransparency=0, Position=UDim2.fromScale(0.5,0.765),
            MaxVisibleGraphemes=#caption.Text}, Enum.EasingStyle.Quint)
    end)
    local logoPulse = TweenService:Create(cutsceneLogoScale,
        TweenInfo.new(1.05/speed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Scale=1.035})
    logoPulse:Play()
    self._cutsceneTweens[#self._cutsceneTweens+1] = logoPulse
    local orbitSpin = TweenService:Create(ringHolder,
        TweenInfo.new(8.5/speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation=580})
    local orbitSpin2 = TweenService:Create(ring2,
        TweenInfo.new(11/speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation=-540})
    orbitSpin:Play(); orbitSpin2:Play()
    self._cutsceneTweens[#self._cutsceneTweens+1]=orbitSpin
    self._cutsceneTweens[#self._cutsceneTweens+1]=orbitSpin2

    for i, particle in ipairs(particles) do
        local delayTime = (i % 12) * 0.012 / speed
        task.delay(delayTime, function()
            if self._destroyed or token~=self._cutsceneToken or not particle.Parent then return end
            if isSakura then
                local duration = math.random(18,30)/10
                play(particle, duration, {
                    Position=UDim2.new(math.clamp(particle.Position.X.Scale + math.random(-18,18)/100,0.02,0.98),0,1.12,0),
                    Rotation=particle.Rotation + math.random(180,540), TextTransparency=1,
                }, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
            elseif isMidnight then
                local duration = math.random(16,28)/10
                play(particle, duration, {
                    Position=UDim2.new(math.clamp(particle.Position.X.Scale + math.random(-8,8)/100,0.02,0.98),0,1.08,0),
                    Rotation=particle.Rotation + math.random(-90,90), TextTransparency=1,
                }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            elseif isWaterfall then
                local duration = math.random(14,24)/10
                play(particle, duration, {
                    Position=UDim2.new(particle.Position.X.Scale + math.random(-4,4)/100,0,1.18,0),
                    BackgroundTransparency=1, Size=UDim2.fromOffset(1,math.random(4,12)),
                }, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
            elseif isButterflies then
                local duration = math.random(18,30)/10
                play(particle, duration, {
                    Position=UDim2.new(math.clamp(particle.Position.X.Scale + math.random(-25,25)/100,0.02,0.98),0,
                        math.clamp(particle.Position.Y.Scale - math.random(18,42)/100,0.05,0.95),0),
                    Rotation=particle.Rotation + math.random(-90,90), BackgroundTransparency=1,
                }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            else
                local duration = math.random(13,25)/10
                play(particle, duration, {
                    Position=UDim2.new(math.clamp(particle.Position.X.Scale + math.random(-15,15)/100,0.01,0.99),0,1.14,0),
                    Rotation=particle.Rotation + math.random(90,320), TextTransparency=1,
                }, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
            end
        end)
    end

    local lifetime = (isStarfall and 3.3 or isWaterfall and 3.2 or isButterflies and 3.4
        or isSakura and 3.8 or isMidnight and 3.6 or 2.9) / speed
    task.delay(lifetime, function()
        if self._destroyed or token~=self._cutsceneToken or not overlay.Parent then return end
        self:StopCutsceneSound(0.42)
        play(title,0.28,{TextTransparency=1,Position=UDim2.fromScale(0.5,0.61),TextStrokeTransparency=1})
        play(subtitle,0.24,{TextTransparency=1})
        play(caption,0.22,{TextTransparency=1})
        play(titleAccent,0.2,{BackgroundTransparency=1})
        play(overlay,0.42,{BackgroundTransparency=1})
        play(vignette,0.35,{BackgroundTransparency=1})
        play(outerHalo,0.28,{BackgroundTransparency=1})
        play(letterboxTop,0.28,{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1})
        play(letterboxBottom,0.28,{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1})
        task.delay(0.48/speed,function()
            -- A stale completion callback must not cancel or reset a newer scene.
            if self._destroyed or token ~= self._cutsceneToken then return end
            if overlay and overlay.Parent then overlay:Destroy() end
            if self._cutsceneOverlay==overlay then
                self._cutsceneOverlay=nil
                self._activeCutsceneName=nil
            end
            if self._animationManager then self._animationManager:CancelGroup("cutscene") end
            for _, active in ipairs(self._cutsceneTweens or {}) do pcall(function() active:Cancel() end) end
            self._cutsceneTweens = {}
            self:StopCutsceneSound(0)
            if self._revealAfterCutscene and not self._destroyed and self.Main and self.Main.Parent then
                self._revealAfterCutscene=false
                self.Main.Visible=true
                self.Main.BackgroundTransparency=self._mainBaseTransparency or self._theme.WindowTransparency or 0.04
                if self._mainScale and self._mainScale.Parent then self._mainScale.Scale=0.88 end
                local showTween=tween(self.Main,0.52,{
                    Size=UDim2.fromOffset((self._targetSize or Vector2.new(700,470)).X,(self._targetSize or Vector2.new(700,470)).Y),
                },Enum.EasingStyle.Quint)
                if self._mainScale and self._mainScale.Parent then
                    tween(self._mainScale,0.52,{Scale=1},Enum.EasingStyle.Back)
                end
                if self._blur and self._blur.Parent then
                    tween(self._blur,0.42,{Size=self._glassBlurSize or 0},Enum.EasingStyle.Quint)
                end
                self._introFinished = true
        if self._hud then self._hud.Visible = true end
                self._visible = true
                if self._sessionState then self._sessionState.IntroPlayed = true end
            end
        end)
    end)
    return true
end

function Window:SetGradientColors(colors)
    if self._destroyed then return false end
    local normalized = normalizeGradientColors(colors, self._gradientColors)
    self._gradientColors = normalized
    local keypoints = {}
    for index, color in ipairs(normalized) do
        table.insert(keypoints, ColorSequenceKeypoint.new((index - 1) / (#normalized - 1), color))
    end
    local sequence = ColorSequence.new(keypoints)
    if self.ScreenGui then
        for _, object in ipairs(self.ScreenGui:GetDescendants()) do
            if object:IsA("UIGradient") then
                pcall(function() object.Color = sequence end)
            end
        end
    end
    return true
end

function Window:SetBackgroundImage(assetId, transparency)
    if self._destroyed or not self.Main then return false end
    local id = normalizeAssetId(assetId)
    if not id then
        if self._backgroundArt then self._backgroundArt:Destroy(); self._backgroundArt = nil end
        return true
    end
    if not self._backgroundArt or not self._backgroundArt.Parent then
        local art = make("ImageLabel", {
            Name = "4D_CustomBackground", Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Crop, ZIndex = 5,
        }, self.Main)
        corner(art, 16)
        self._backgroundArt = art
    end
    self._backgroundArt.Image = id
    self._backgroundArt.ImageTransparency = math.clamp(tonumber(transparency) or 0.78, 0, 1)
    return true
end

-- Global UI outline controls. These only affect UIStroke instances inside this ScreenGui.
function Window:SetOutlineEnabled(enabled)
    if self._destroyed or not self.ScreenGui then return false end
    self._outlineEnabled = enabled == true
    for _, object in ipairs(self.ScreenGui:GetDescendants()) do
        if object:IsA("UIStroke") then
            if object:GetAttribute("FourD_OriginalTransparency") == nil then
                object:SetAttribute("FourD_OriginalTransparency", object.Transparency)
            end
            object.Enabled = self._outlineEnabled
        end
    end
    return true
end

function Window:SetOutlineColor(color)
    if self._destroyed or not self.ScreenGui or typeof(color) ~= "Color3" then return false end
    self._outlineColor = color
    for _, object in ipairs(self.ScreenGui:GetDescendants()) do
        if object:IsA("UIStroke") then object.Color = color end
    end
    return true
end

function Window:SetOutlineTransparency(value)
    if self._destroyed or not self.ScreenGui then return false end
    local transparency = math.clamp(tonumber(value) or 0.2, 0, 1)
    self._outlineTransparency = transparency
    for _, object in ipairs(self.ScreenGui:GetDescendants()) do
        if object:IsA("UIStroke") then object.Transparency = transparency end
    end
    return true
end

function Window:SetOutlineThickness(value)
    if self._destroyed or not self.ScreenGui then return false end
    local thickness = math.clamp(tonumber(value) or 1, 0, 6)
    self._outlineThickness = thickness
    for _, object in ipairs(self.ScreenGui:GetDescendants()) do
        if object:IsA("UIStroke") then object.Thickness = thickness end
    end
    return true
end

function Window:SetBackgroundTexture(assetId, transparency)
    return self:SetBackgroundImage(assetId, transparency)
end

function Window:SetBackgroundMusic(assetId, volume, playbackSpeed)
    if self._destroyed then return false end
    self:StopBackgroundMusic()
    local id = normalizeAssetId(assetId)
    if not id then return false end
    local music = Instance.new("Sound")
    music.Name = "4D_BackgroundMusic"
    music.SoundId = id
    music.Volume = math.clamp(tonumber(volume) or 0.25, 0, 10)
    music.PlaybackSpeed = math.clamp(tonumber(playbackSpeed) or 1, 0.5, 2)
    music.Looped = true
    music.Parent = game:GetService("SoundService")
    self._backgroundMusic = music
    local ok = pcall(function() music:Play() end)
    return ok
end

function Window:StopBackgroundMusic()
    local music = self._backgroundMusic
    self._backgroundMusic = nil
    if music then
        pcall(function() music:Stop(); music:Destroy() end)
    end
    return true
end

function Window:SetStyle(styleName)
    if self._destroyed or not self.Main then return false end
    local style=string.lower(tostring(styleName or "solid"))
    if style~="glass" and style~="solid" and style~="neon" and style~="minimal" then return false end
    if style == self._styleName then return true end
    if self._openPopup then self._openPopup.Visible = false; self._openPopup = nil end
    if self._commandPalette then self:CloseCommandPalette() end
    self._styleTransitionToken = (self._styleTransitionToken or 0) + 1
    local token = self._styleTransitionToken
    local main = self.Main
    local wasVisible = self._visible and main.Visible
    local function apply()
        if self._destroyed or token ~= self._styleTransitionToken then return end
        self._styleName = style
        self:SetTheme(self._themeName or "Midnight", (self._themeName == "Custom") and self._customTheme or nil)
        -- Deterministically clear stale Neon tab/stroke styling after rapid style swaps.
        local strokeThickness = style == "neon" and 1.65 or style == "minimal" and 0.7 or style == "solid" and 1.15 or 1.3
        local strokeTransparency = style == "neon" and 0.08 or style == "minimal" and 0.58 or style == "solid" and 0.24 or 0.18
        for _, descendant in ipairs(self.ScreenGui:GetDescendants()) do
            if descendant:IsA("UIStroke") then
                descendant.Thickness = self._outlineThickness or strokeThickness
                descendant.Transparency = self._outlineTransparency or strokeTransparency
                if self._outlineColor then descendant.Color = self._outlineColor end
            end
        end
        for _, tab in ipairs(self._tabs or {}) do
            if tab._button and tab._button.Parent then
                local selected = self._activeTab == tab
                tab._button.BackgroundColor3 = Theme.Surface2
                tab._button.BackgroundTransparency = selected and 0 or 1
                if tab._label then tab._label.TextColor3 = selected and Theme.Text or Theme.Muted end
                if tab._icon then tab._icon.TextColor3 = selected and Theme.Cyan or Theme.Muted end
                if tab._indicator then tab._indicator.BackgroundColor3 = Theme.Purple; tab._indicator.BackgroundTransparency = selected and 0 or 1 end
            end
        end
        if not self._cornerRadiusCustom then
            local styleRadius = style == "minimal" and 7 or style == "solid" and 11 or style == "neon" and 15 or 18
            self:SetCornerRadius(styleRadius, true)
        end
        M779_PREFERENCES.Style = style
        save4DPreferences()
    end
    if not wasVisible then apply(); return true end
    local notice = make("Frame", {Name="4D_StyleTransition", Size=UDim2.fromScale(1,1), BackgroundColor3=Theme.Background,
        BackgroundTransparency=0.10, BorderSizePixel=0, ZIndex=490}, self.ScreenGui)
    local label = createLabel(notice, "Changing style", 18, Theme.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    label.AnchorPoint = Vector2.new(0.5,0.5)
    label.Position = UDim2.fromScale(0.5,0.5)
    label.Size = UDim2.new(0.8,0,0,34)
    label.ZIndex = 492
    local sub = createLabel(notice, string.upper(style) .. " EDITION", 9, Theme.Cyan, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    sub.AnchorPoint = Vector2.new(0.5,0.5)
    sub.Position = UDim2.fromScale(0.5,0.56)
    sub.Size = UDim2.new(0.8,0,0,18)
    sub.ZIndex = 492
    local scale = self._mainScale
    tween(main,0.24,{Size=UDim2.fromOffset(58,58),BackgroundTransparency=1},Enum.EasingStyle.Quint)
    if scale then tween(scale,0.24,{Scale=0.84},Enum.EasingStyle.Back) end
    task.delay(0.27,function()
        if self._destroyed or token ~= self._styleTransitionToken then if notice.Parent then notice:Destroy() end; return end
        apply()
        if scale and scale.Parent then scale.Scale=0.84 end
        tween(main,0.38,{Size=UDim2.fromOffset(self._targetSize.X,self._targetSize.Y),BackgroundTransparency=self._theme.WindowTransparency or 0},Enum.EasingStyle.Quint)
        if scale and scale.Parent then tween(scale,0.42,{Scale=1},Enum.EasingStyle.Back) end
        tween(notice,0.30,{BackgroundTransparency=1},Enum.EasingStyle.Quint)
        tween(label,0.22,{TextTransparency=1},Enum.EasingStyle.Quint)
        tween(sub,0.22,{TextTransparency=1},Enum.EasingStyle.Quint)
        task.delay(0.34,function() if notice and notice.Parent then notice:Destroy() end end)
    end)
    return true
end

function Window:SetFont(fontName)
    if self._destroyed or not self.Main then return false end
    local allowed = {Gotham=true, GothamMedium=true, GothamSemibold=true, GothamBold=true, GothamBlack=true,
        SourceSans=true, SourceSansBold=true, Code=true, Arcade=true, SciFi=true, Fantasy=true, Antique=true}
    local name = tostring(fontName or "Gotham")
    if not allowed[name] or not Enum.Font[name] then return false end
    for _, object in ipairs(self.Main:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            pcall(function() object.Font = Enum.Font[name] end)
        end
    end
    self._fontName = name
    M779_PREFERENCES.Font = name
    save4DPreferences()
    return true
end

function Window:SetCornerRadius(radius, internal)
    if self._destroyed or not self.Main then return false end
    local value = math.clamp(tonumber(radius) or 12, 0, 28)
    if internal ~= true then self._cornerRadiusCustom = true end

    -- Add corners to actual painted Frame surfaces that were missed by their
    -- constructors. Transparent layout wrappers and thin decorative rules stay square.
    local excludedFrameNames = {
        Edge = true, CoreGlow = true, Indicator = true, Rule = true,
        Separator = true, Divider = true, IntroGlow = true,
        LoadingOverlay = true, ["4D_StyleTransition"] = true,
        ["4D_CommandPalette"] = true,
    }
    local function ensureSurfaceCorner(object)
        if not object or not object:IsA("Frame") then return end
        if excludedFrameNames[object.Name] then return end
        if object:GetAttribute("4D_KeepWhiteLogo") == true then return end
        if object.BackgroundTransparency >= 0.995 then return end
        if object.Name == "IntroOverlay" or object.Name == "4D_CutsceneOverlay" then return end
        if self._cutsceneOverlay and (object == self._cutsceneOverlay or object:IsDescendantOf(self._cutsceneOverlay)) then return end
        local size = object.AbsoluteSize
        if size.X <= 3 or size.Y <= 3 then return end
        local existing = object:FindFirstChildOfClass("UICorner")
        if existing then return end
        local localRadius = math.min(value, math.max(0, math.floor(math.min(size.X, size.Y) * 0.5)))
        corner(object, localRadius)
    end

    local factor = value / 12
    local function applyCorner(cornerObject)
        if not cornerObject or not cornerObject:IsA("UICorner") then return end
        local object = cornerObject.Parent
        if not object or not object:IsA("GuiObject") then return end
        if self._cutsceneOverlay and (object == self._cutsceneOverlay or object:IsDescendantOf(self._cutsceneOverlay)) then return end
        if object.Name == "IntroOverlay" or object.Name == "4D_CutsceneOverlay" then return end

        local baseScale = cornerObject:GetAttribute("4D_BaseCornerScale")
        local baseOffset = cornerObject:GetAttribute("4D_BaseCornerOffset")
        if baseScale == nil or baseOffset == nil then
            local original = cornerObject.CornerRadius
            baseScale = original.Scale
            baseOffset = original.Offset
            cornerObject:SetAttribute("4D_BaseCornerScale", baseScale)
            cornerObject:SetAttribute("4D_BaseCornerOffset", baseOffset)
        end
        local scaledOffset = math.max(0, baseOffset * factor)
        pcall(function()
            cornerObject.CornerRadius = UDim.new(baseScale, scaledOffset)
        end)
    end

    local function processObject(object)
        if object:IsA("Frame") then ensureSurfaceCorner(object) end
        if object:IsA("UICorner") then applyCorner(object) end
    end

    if self.ScreenGui and self.ScreenGui.Parent then
        for _, object in ipairs(self.ScreenGui:GetDescendants()) do processObject(object) end
        if not self._cornerWatcher then
            self._cornerWatcher = self.ScreenGui.DescendantAdded:Connect(function(object)
                task.defer(function()
                    if self._destroyed or not object.Parent then return end
                    processObject(object)
                end)
            end)
            addConnection(self, self._cornerWatcher)
        end
    else
        for _, object in ipairs(self.Main:GetDescendants()) do processObject(object) end
    end
    self._cornerRadius = value
    M779_PREFERENCES.CornerRadius = value
    save4DPreferences()
    return true
end

function Window:SetWindowSize(width, height)
    if self._destroyed or not self.Main then return false end
    local w = math.clamp(tonumber(width) or self._targetSize.X, 620, 1600)
    local h = math.clamp(tonumber(height) or self._targetSize.Y, 420, 1000)
    self._targetSize = Vector2.new(w,h)
    self._windowWidth, self._windowHeight = w,h
    if self._visible and not self._transitioning then
        tween(self.Main,0.22,{Size=UDim2.fromOffset(w,h)},Enum.EasingStyle.Quint)
    else
        self.Main.Size=UDim2.fromOffset(w,h)
    end
    if self._updateResponsiveScale then self._updateResponsiveScale() end
    return true
end

function Window:SetSidebarWidth(width)
    if self._destroyed then return false end
    local value=math.clamp(tonumber(width) or self._sidebarWidth or 220,130,300)
    self._sidebarWidth=value
    if self._sidebar and self._sidebar.Parent then
        tween(self._sidebar,0.18,{Size=UDim2.new(0,value,1,-62)},Enum.EasingStyle.Quint)
    end
    local content=self.Main and self.Main:FindFirstChild("Content")
    if content then
        tween(content,0.18,{Position=UDim2.fromOffset(value,62),Size=UDim2.new(1,-value,1,-62)},Enum.EasingStyle.Quint)
    end
    return true
end

function Window:SetBlur(enabled, amount)
    if self._destroyed or not self.Main then return false end
    -- Roblox BlurEffect is screen-wide, so the library intentionally avoids it.
    -- The local glass treatment is implemented by layered translucent surfaces.
    self._glassBlurEnabled = enabled ~= false
    self._glassBlurSize = self._glassBlurEnabled and math.clamp(tonumber(amount) or 9, 0, 24) or 0
    local target = self._glassBlurEnabled and (self._styleName == "glass" and 0.20 or 0.06) or (self._theme.WindowTransparency or 0)
    tween(self.Main, 0.30, {BackgroundTransparency = target}, Enum.EasingStyle.Quint)
    for _, object in ipairs(self.Main:GetDescendants()) do
        if object:IsA("Frame") and (object.Name == "Sidebar" or object.Name == "Topbar" or object.Name == "CommunityCard"
            or object.Name == "4D_SidebarBrand" or string.sub(object.Name, 1, 8) == "Section_") then
            local value = self._glassBlurEnabled and 0.18 or (self._theme.PanelTransparency or 0)
            tween(object, 0.30, {BackgroundTransparency = value}, Enum.EasingStyle.Quint)
        end
    end
    self._mainBaseTransparency = target
    return true
end

function Window:SetTransparency(value)
    if self._destroyed or not self.Main then return false end
    local amount=math.clamp(tonumber(value) or 0,0,0.8)
    self.Main.BackgroundTransparency=amount
    self._mainBaseTransparency=amount
    return true
end

function Window:SetNotificationLimit(value)
    if self._destroyed then return false end
    self._notificationLimit=math.clamp(math.floor(tonumber(value) or 5),1,8)
    while #self._notifications>self._notificationLimit do
        self:_RemoveNotification(self._notifications[1],false)
    end
    return self._notificationLimit
end

function Window:GetNotificationCount()
    return #(self._notifications or {})
end

function Window:_CancelMotion()
    self._transitionToken = (self._transitionToken or 0) + 1
    if self._animationManager then self._animationManager:CancelGroup("motion") end
    for _, active in ipairs(self._motionTweens or {}) do
        pcall(function() active:Cancel() end)
    end
    self._motionTweens = {}
    return self._transitionToken
end

function Window:_MotionTween(object, duration, properties, style)
    if self._destroyed or not object or not object.Parent then return nil end
    self._motionTweens = self._motionTweens or {}
    self._motionSerial = (self._motionSerial or 0) + 1
    local serial = self._motionSerial
    local animation = self._animationManager and self._animationManager:Play("motion", object, duration, properties, style)
        or tween(object, duration, properties, style)
    if not animation then return nil end
    self._motionTweens[#self._motionTweens + 1] = animation
    -- Completed tweens are removed so long-running sessions do not accumulate handles.
    animation.Completed:Connect(function()
        for index = #self._motionTweens, 1, -1 do
            if self._motionTweens[index] == animation then
                table.remove(self._motionTweens, index)
                break
            end
        end
    end)
    return animation
end

function Window:_FadeContents(show, token)
    if not self.Main or not self.Main.Parent then return end
    self._fadeSnapshots = self._fadeSnapshots or {}
    self._fadeObjectTweens = self._fadeObjectTweens or {}
    local items = {}
    for _, object in ipairs(self.Main:GetDescendants()) do
        if object ~= self._cutsceneOverlay and not object:IsA("UIGradient") then
            local props = {}
            local snapshot = self._fadeSnapshots[object]
            if not snapshot then snapshot={}; self._fadeSnapshots[object]=snapshot end
            if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                if snapshot.TextTransparency==nil then snapshot.TextTransparency=object.TextTransparency end
                props.TextTransparency=show and snapshot.TextTransparency or 1
            end
            if object:IsA("ImageLabel") or object:IsA("ImageButton") then
                if snapshot.ImageTransparency==nil then snapshot.ImageTransparency=object.ImageTransparency end
                props.ImageTransparency=show and snapshot.ImageTransparency or 1
            end
            if object:IsA("GuiObject") then
                if snapshot.BackgroundTransparency==nil then snapshot.BackgroundTransparency=object.BackgroundTransparency end
                props.BackgroundTransparency=show and snapshot.BackgroundTransparency or 1
            end
            if object:IsA("UIStroke") then
                if snapshot.Transparency==nil then snapshot.Transparency=object.Transparency end
                props.Transparency=show and snapshot.Transparency or 1
            end
            if next(props) then items[#items+1]={object=object,props=props} end
        end
    end
    -- Restore instantly before opening tweens. This prevents a stale fade tween
    -- from leaving solid themes translucent after a fast hide/show sequence.
    for _, item in ipairs(items) do
        local object=item.object
        local previous=self._fadeObjectTweens[object]
        if previous then pcall(function() previous:Cancel() end) end
        if show then
            -- Start fully transparent, then reveal each descendant in a short stagger.
            for property,_ in pairs(item.props) do
                pcall(function() object[property]=1 end)
            end
        end
    end
    for index, item in ipairs(items) do
        local function animateItem()
            if self._destroyed or token~=(self._transitionToken or 0) then return end
            if item.object and item.object.Parent then
                local previous=self._fadeObjectTweens[item.object]
                if previous then pcall(function() previous:Cancel() end) end
                local duration=show and 0.24 or 0.18
                local animation=tween(item.object,duration,item.props,Enum.EasingStyle.Quint)
                self._fadeObjectTweens[item.object]=animation
            end
        end
        if show then
            task.delay(math.min((index-1)*0.004,0.16), animateItem)
        else
            animateItem()
        end
    end
end

function Window:SetVisible(visible)
    if self._destroyed or self._closing or not self._introFinished then return false end
    visible = visible == true
    if visible == self._visible and not self._transitioning then return true end
    local token = self:_CancelMotion()
    self._transitioning = true
    self._visible = visible
    local main, dock = self.Main, self._dock
    if not main or not main.Parent then self._transitioning=false; return false end
    local target = self._targetSize or Vector2.new(700,470)

    if visible then
        if dock and dock.Parent then
            dock.Visible=true
            dock.Size=UDim2.fromOffset(58,58)
            dock.BackgroundTransparency=0.04
            if self._dockScale and self._dockScale.Parent then self._dockScale.Scale=1.12; self:_MotionTween(self._dockScale,0.20,{Scale=0.94},Enum.EasingStyle.Back) end
        end
        main.Visible=true
        self._mainBaseTransparency = self._mainBaseTransparency or main.BackgroundTransparency
        main.BackgroundTransparency=1
        main.AnchorPoint=Vector2.new(0.5,0.5)
        local startPosition=self._lastMainPosition or UDim2.fromScale(0.5,0.5)
        if dock and dock.Parent then
            local center=dock.AbsolutePosition+dock.AbsoluteSize/2
            main.Position=UDim2.fromOffset(center.X,center.Y)
        else main.Position=startPosition end
        main.Size=UDim2.fromOffset(58,58)
        main.Rotation=-5
        if self._mainScale and self._mainScale.Parent then self._mainScale.Scale=0.86 end
        self:_FadeContents(true,token)
        local openTween=self:_MotionTween(main,0.48,{Position=startPosition,Size=UDim2.fromOffset(target.X,target.Y),Rotation=0,BackgroundTransparency=self._mainBaseTransparency or 0},Enum.EasingStyle.Quint)
        if self._mainScale and self._mainScale.Parent then self:_MotionTween(self._mainScale,0.46,{Scale=1},Enum.EasingStyle.Quint) end
        if self._blur and self._blur.Parent then self:_MotionTween(self._blur,0.38,{Size=self._glassBlurSize or 0},Enum.EasingStyle.Quint) end
        if dock and dock.Parent then self:_MotionTween(dock,0.24,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Quint) end
        task.spawn(function()
            pcall(function() openTween.Completed:Wait() end)
            if self._destroyed or token~=self._transitionToken then return end
            if dock and dock.Parent then dock.Visible=false end
            self._transitioning=false
            self._motionTweens={}
        end)
    else
        if self._openPopup then
            pcall(function() self._openPopup.Visible = false end)
            self._openPopup = nil
        end
        self:StopCutscene()
        self._lastMainPosition=main.Position
        local abs,size=main.AbsolutePosition,main.AbsoluteSize
        local centerX,centerY=abs.X+size.X/2,abs.Y+size.Y/2
        if dock and dock.Parent then
            dock.Position=UDim2.fromOffset(centerX,centerY)
            dock.Visible=true; dock.Size=UDim2.fromOffset(0,0); dock.BackgroundTransparency=1
        end
        if self._blur and self._blur.Parent then self:_MotionTween(self._blur,0.26,{Size=0},Enum.EasingStyle.Quint) end
        self:_FadeContents(false,token)
        task.delay(0.27/math.max(0.35,self._animationSpeed or 1),function()
            if self._destroyed or token~=self._transitionToken or not main.Parent then return end
            self._mainBaseTransparency = self._mainBaseTransparency or main.BackgroundTransparency
            local shrink=self:_MotionTween(main,0.40,{Position=UDim2.fromOffset(centerX,centerY),Size=UDim2.fromOffset(58,58),Rotation=7,BackgroundTransparency=1},Enum.EasingStyle.Quint)
            if self._mainScale and self._mainScale.Parent then self:_MotionTween(self._mainScale,0.40,{Scale=0.82},Enum.EasingStyle.Quint) end
            if dock and dock.Parent then
                self:_MotionTween(dock,0.40,{Size=UDim2.fromOffset(58,58),BackgroundTransparency=0.04},Enum.EasingStyle.Back)
                if self._dockScale and self._dockScale.Parent then self._dockScale.Scale = 0.72; self:_MotionTween(self._dockScale,0.48,{Scale=1},Enum.EasingStyle.Back) end
            end
            task.spawn(function()
                pcall(function() shrink.Completed:Wait() end)
                if self._destroyed or token~=self._transitionToken then return end
                main.Visible=false
                main.Size=UDim2.fromOffset(target.X,target.Y)
                main.Rotation=0
                if self._mainScale and self._mainScale.Parent then self._mainScale.Scale=1 end
                self._transitioning=false
                self._motionTweens={}
            end)
        end)
    end
    return true
end

Window.SetOpen = Window.SetVisible

function Window:Close()
    if self._destroyed or self._closing then return false end
    self._closing=true
    if self._openPopup then
        pcall(function() self._openPopup.Visible = false end)
        self._openPopup = nil
    end
    self:StopCutscene()
    local token=self:_CancelMotion()
    self._transitioning=true
    self._visible=false
    local main=self.Main
    if not main or not main.Parent then self:Destroy(); return true end
    if self._dock then self._dock.Visible=false end
    self:_FadeContents(false,token)
    task.delay(0.28/math.max(0.35,self._animationSpeed or 1),function()
        if self._destroyed or token~=self._transitionToken or not main.Parent then return end
        self._mainBaseTransparency = self._mainBaseTransparency or main.BackgroundTransparency
        local first=self:_MotionTween(main,0.40,{Size=UDim2.fromOffset(62,62),Rotation=8,BackgroundTransparency=1},Enum.EasingStyle.Quint)
        if self._mainScale and self._mainScale.Parent then self:_MotionTween(self._mainScale,0.40,{Scale=0.82},Enum.EasingStyle.Quint) end
        task.spawn(function()
            pcall(function() first.Completed:Wait() end)
            if self._destroyed or token~=self._transitionToken then return end
            local last=self:_MotionTween(main,0.24,{Size=UDim2.fromOffset(2,2),Rotation=90,BackgroundTransparency=1},Enum.EasingStyle.Quint)
            if self._mainScale and self._mainScale.Parent then self:_MotionTween(self._mainScale,0.24,{Scale=0.05},Enum.EasingStyle.Quint) end
            if self._blur and self._blur.Parent then self:_MotionTween(self._blur,0.24,{Size=0},Enum.EasingStyle.Quint) end
            pcall(function() last.Completed:Wait() end)
            if not self._destroyed and token==self._transitionToken then self:Destroy() end
        end)
    end)
    return true
end

function Window:Destroy()
    if self._destroyed then return false end
    self:StopCutsceneSound(0)
    self._themeApplyToken = (self._themeApplyToken or 0) + 1
    for object, objectTweens in pairs(self._themeTweens or {}) do
        for _, activeTween in pairs(objectTweens) do
            pcall(function() activeTween:Cancel() end)
        end
        self._themeTweens[object] = nil
    end
    self._destroyed = true
    if self._animationManager then self._animationManager:CancelAll() end
    self:StopAmbientAnimations()
    self._transitionToken = (self._transitionToken or 0) + 1
    self._cutsceneToken = (self._cutsceneToken or 0) + 1
    for _, active in ipairs(self._motionTweens or {}) do pcall(function() active:Cancel() end) end
    table.clear(self._motionTweens or {})
    if self._cutsceneOverlay then pcall(function() self._cutsceneOverlay:Destroy() end); self._cutsceneOverlay = nil end
    if self._commandPalette then pcall(function() self._commandPalette:Destroy() end); self._commandPalette=nil end
    for _, active in ipairs(self._cutsceneTweens or {}) do pcall(function() active:Cancel() end) end
    table.clear(self._cutsceneTweens or {})
    for _, entry in ipairs(self._notifications or {}) do
        if entry.Frame then pcall(function() entry.Frame:Destroy() end) end
    end
    table.clear(self._notifications or {})
    if self._loadingSheen then pcall(function() self._loadingSheen:Cancel() end) end
    if self._progressShimmer then pcall(function() self._progressShimmer:Cancel() end) end
    self:StopBackgroundMusic()
    if self._cameraViewportConnection then
        pcall(function() self._cameraViewportConnection:Disconnect() end)
        self._cameraViewportConnection = nil
    end
    for _, connection in ipairs(self._connections) do pcall(function() connection:Disconnect() end) end
    table.clear(self._connections)
    if self._blur then pcall(function() self._blur.Size = 0; self._blur:Destroy() end); self._blur = nil end
    if self.ScreenGui then pcall(function() self.ScreenGui:Destroy() end) end
    if M779_ENV and M779_ENV.__779_ACTIVE_WINDOW == self then M779_ENV.__779_ACTIVE_WINDOW = nil end
    return true
end



-- 4D v5.3.2: element customization + collapsible folder containers.
-- Customization is opt-in per control through config.Customization and can also
-- be applied to existing/future controls through Section/Tab/Window methods.
local function fourDApplyElementStyle(row, style)
    if not row or not row.Parent or type(style) ~= "table" then return false end
    local radius = tonumber(style.Radius or style.CornerRadius)
    local bg = typeof(style.BackgroundColor) == "Color3" and style.BackgroundColor or nil
    local textColor = typeof(style.TextColor) == "Color3" and style.TextColor or nil
    local accent = typeof(style.AccentColor) == "Color3" and style.AccentColor or nil
    local strokeColor = typeof(style.StrokeColor) == "Color3" and style.StrokeColor or nil
    local textSize = tonumber(style.TextSize)
    local transparency = tonumber(style.BackgroundTransparency)
    local font = style.Font
    if type(font) == "string" and Enum.Font[font] then font = Enum.Font[font] end
    for _, object in ipairs(row:GetDescendants()) do
        pcall(function()
            if bg and (object:IsA("TextBox") or (object:IsA("TextButton") and object.Name ~= "ToggleTrack" and object.Name ~= "ColorSwatch")) then
                object.BackgroundColor3 = bg
                object:SetAttribute("4D_CustomElementBackground", true)
            end
            if textColor and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
                object.TextColor3 = textColor
                object:SetAttribute("4D_CustomElementText", true)
            end
            if accent and ((object:IsA("TextButton") and object.Name ~= "ToggleTrack" and object.Name ~= "ColorSwatch") or object.Name == "SliderFill" or object.Name == "ToggleTrack" or object:IsA("UIGradient")) then
                if object:IsA("UIGradient") then
                    object.Color = ColorSequence.new(accent, accent:Lerp(Color3.new(1,1,1), 0.18))
                else
                    object.BackgroundColor3 = accent
                end
                object:SetAttribute("4D_CustomElementAccent", true)
            end
            if textSize and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
                object.TextSize = math.clamp(math.floor(textSize + 0.5), 7, 32)
            end
            if font and typeof(font) == "EnumItem" and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
                object.Font = font
            end
            if transparency and (object:IsA("TextButton") or object:IsA("TextBox")) then
                object.BackgroundTransparency = math.clamp(transparency, 0, 1)
            end
            if strokeColor and object:IsA("UIStroke") then
                object.Color = strokeColor
                object:SetAttribute("4D_CustomElementStroke", true)
            end
            if radius and object:IsA("UICorner") then
                object.CornerRadius = UDim.new(0, math.clamp(radius, 0, 28))
            end
        end)
    end
    return true
end

local function fourDMergeStyle(base, extra)
    local result = {}
    if type(base) == "table" then for k,v in pairs(base) do result[k] = v end end
    if type(extra) == "table" then for k,v in pairs(extra) do result[k] = v end end
    return result
end

function Section:SetCustomization(style)
    if type(style) ~= "table" then return false end
    self._customization = fourDMergeStyle(self._customization, style)
    for _, row in ipairs(self._controls or {}) do fourDApplyElementStyle(row, self._customization) end
    return true
end

function Section:SetElementCustomization(index, style)
    local row = self._controls and self._controls[tonumber(index) or -1]
    if not row then return false end
    row:SetAttribute("4D_Customization", true)
    return fourDApplyElementStyle(row, style)
end

local function fourDCreateFolder(owner, name, config)
    config = config or {}
    local tab = owner._tab or owner
    if not tab or not tab._window or tab._window._destroyed then return nil end
    local parent = owner._folderContainer or owner._card or owner._page
    if not parent then return nil end
    local order
    if owner._page then
        order = owner._nextLayoutOrder or 1
        owner._nextLayoutOrder = order + 1
    else
        order = owner._order or 1
        owner._order = order + 1
    end
    M779_PREFERENCES.FolderStates = M779_PREFERENCES.FolderStates or {}
    local folderKey = tostring(config.Id or (tab._name .. "/" .. tostring(name or "Folder")))
    local savedExpanded = M779_PREFERENCES.FolderStates[folderKey]
    local initiallyExpanded = config.Expanded ~= nil and config.Expanded ~= false or (config.Expanded == nil and savedExpanded ~= false)
    local card = make("Frame", {
        Name = "4D_Folder_" .. tostring(name or "Folder"),
        Size = UDim2.new(1, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = Theme.CardTransparency or 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = order,
        ZIndex = 8,
    }, parent)
    corner(card, tonumber(config.Radius) or 12)
    stroke(card, Theme.Stroke, 0.48, 1)
    make("UIListLayout", {Padding=UDim.new(0, 5), SortOrder=Enum.SortOrder.LayoutOrder}, card)
    local header = make("TextButton", {
        Name="FolderHeader", Size=UDim2.new(1,0,0,39), BackgroundColor3=Theme.Surface2,
        BackgroundTransparency=0.18, BorderSizePixel=0, Text="", AutoButtonColor=false,
        LayoutOrder=1, ZIndex=9,
    }, card)
    corner(header, 9)
    local title = createLabel(header, tostring(name or "Folder"), 11, Theme.Text, Enum.Font.GothamSemibold)
    title.Position=UDim2.fromOffset(12,0); title.Size=UDim2.new(1,-48,1,0); title.ZIndex=10
    local arrow = createLabel(header, initiallyExpanded and "−" or "+", 17, Theme.Cyan, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    arrow.AnchorPoint=Vector2.new(1,0.5); arrow.Position=UDim2.new(1,-10,0.5,0); arrow.Size=UDim2.fromOffset(24,28); arrow.ZIndex=10
    local content = make("Frame", {
        Name="FolderContent", Size=UDim2.new(1,-18,0,0), Position=UDim2.fromOffset(9,0),
        AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, BorderSizePixel=0,
        LayoutOrder=2, Visible=initiallyExpanded, ZIndex=9,
    }, card)
    make("UIListLayout", {Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder}, content)
    make("UIPadding", {PaddingTop=UDim.new(0,3),PaddingBottom=UDim.new(0,10)}, content)
    local folder = setmetatable({
        _tab=tab, _card=content, _folderCard=card, _folderContainer=content,
        _folderHeader=header, _folderTitle=title, _folderArrow=arrow,
        _order=1, _controls={}, _customization=owner._customization and table.clone(owner._customization) or nil,
        _name=tostring(name or "Folder"), _folderKey=folderKey, _expanded=initiallyExpanded,
    }, Section)
    addConnection(tab._window, header.Activated:Connect(function()
        folder._expanded = not folder._expanded
        content.Visible = folder._expanded
        arrow.Text = folder._expanded and "−" or "+"
        M779_PREFERENCES.FolderStates[folderKey] = folder._expanded
        save4DPreferences()
    end))
    table.insert(tab._sections, folder)
    if config.Customization then folder:SetCustomization(config.Customization) end
    return folder
end

function Tab:CreateFolder(name, config) return fourDCreateFolder(self, name, config) end
function Section:CreateFolder(name, config) return fourDCreateFolder(self, name, config) end
Tab.AddFolder = Tab.CreateFolder
Section.AddFolder = Section.CreateFolder

-- Wrap every element factory once so per-element config customization is
-- consistently supported without changing legacy return values or callbacks.
local FOURD_ELEMENT_FACTORIES = {
    "CreateButton", "CreateToggle", "CreateSlider", "CreateDropdown",
    "CreateTextbox", "CreateParagraph", "CreateKeybind", "CreateColorPicker",
    "CreateLabel", "CreateDivider", "CreateImage",
}
for _, factoryName in ipairs(FOURD_ELEMENT_FACTORIES) do
    local originalFactory = Section[factoryName]
    if type(originalFactory) == "function" and not Section["_4DWrapped_" .. factoryName] then
        Section["_4DWrapped_" .. factoryName] = true
        Section[factoryName] = function(self, config, ...)
            local before = #(self._controls or {})
            local result = originalFactory(self, config, ...)
            local row = self._controls and self._controls[#self._controls]
            if row and #self._controls > before then
                local custom = type(config) == "table" and (config.Customization or config.Style) or nil
                local combined = fourDMergeStyle(self._customization, custom)
                if next(combined) then fourDApplyElementStyle(row, combined) end
                row:SetAttribute("4D_ElementIndex", #self._controls)
            end
            return result
        end
    end
end

function Window:SetCustomization(style)
    if type(style) ~= "table" then return false end
    self._customization = fourDMergeStyle(self._customization, style)
    for _, tab in ipairs(self._tabs or {}) do
        for _, section in ipairs(tab._sections or {}) do
            section:SetCustomization(self._customization)
        end
    end
    return true
end

function Tab:SetCustomization(style)
    if type(style) ~= "table" then return false end
    self._customization = fourDMergeStyle(self._customization, style)
    for _, section in ipairs(self._sections or {}) do section:SetCustomization(self._customization) end
    return true
end


-- Familiar aliases make the API easier to learn for developers migrating from other UI libraries.
Tab.AddSection = Tab.CreateSection
Tab.CreateGroupBox = Tab.CreateSection
Tab.AddHero = Tab.CreateHero
Section.AddButton = Section.CreateButton
Section.AddToggle = Section.CreateToggle
Section.AddSlider = Section.CreateSlider
Section.AddDropdown = Section.CreateDropdown
Section.AddTextbox = Section.CreateTextbox
Section.AddKeybind = Section.CreateKeybind
Section.AddColorPicker = Section.CreateColorPicker
Section.AddParagraph = Section.CreateParagraph
Section.AddImage = Section.CreateImage

-- Open theme registry: users can define, export, import and share complete palettes.
-- Built-in palettes remain read-only; custom palettes are persisted in preferences.
Library.RegisteredThemes = Library.RegisteredThemes or {}
Library.ThemeTokens = {
    "Background", "Surface", "Surface2", "Surface3", "Text", "Muted", "Soft",
    "Purple", "Blue", "Cyan", "Stroke", "Good", "Danger",
    "WindowTransparency", "PanelTransparency", "CardTransparency",
    "ButtonTransparency", "SidebarTransparency", "LoadingTintTransparency",
}
local BUILTIN_THEME_NAMES = {
    Midnight=true, White=true, Glass=true, Ocean=true, Sakura=true,
    Emerald=true, Sunset=true, Carbon=true, Aurora=true, Custom=true,
}

local function normalizeThemeName(name)
    local result = string.gsub(tostring(name or ""), "^%s*(.-)%s*$", "%1")
    if #result < 2 or #result > 32 then return nil end
    if not string.match(result, "^[%w _%-]+$") then return nil end
    return result
end

local function validateThemeDefinition(definition, base)
    if type(definition) ~= "table" then return nil, "theme definition must be a table" end
    local resolved = table.clone(base or ThemePresets.Midnight)
    local accepted = 0
    for token, value in pairs(definition) do
        if THEME_COLOR_TOKENS[token] then
            if typeof(value) ~= "Color3" then
                return nil, "token '" .. tostring(token) .. "' must be Color3"
            end
            resolved[token] = value
            accepted += 1
        elseif THEME_NUMBER_TOKENS[token] then
            local number = tonumber(value)
            if not number or number < 0 or number > 1 then
                return nil, "token '" .. tostring(token) .. "' must be between 0 and 1"
            end
            resolved[token] = number
            accepted += 1
        else
            return nil, "unknown theme token '" .. tostring(token) .. "'"
        end
    end
    if accepted == 0 then return nil, "theme has no valid tokens" end
    return resolved
end

function Library:RegisterTheme(name, definition, options)
    local safeName = normalizeThemeName(name)
    if not safeName then return false, "invalid theme name" end
    if BUILTIN_THEME_NAMES[safeName] then return false, "built-in theme names are reserved" end
    local normalized, reason = validateThemeDefinition(definition, ThemePresets.Midnight)
    if not normalized then return false, reason end
    Library.RegisteredThemes[safeName] = normalized
    if type(options) == "table" and options.Persist == true then
        M779_PREFERENCES.UserThemes = M779_PREFERENCES.UserThemes or {}
        M779_PREFERENCES.UserThemes[safeName] = table.clone(normalized)
        save4DPreferences()
    end
    return true, safeName
end

function Library:CreateTheme(name, definition, options)
    return Library:RegisterTheme(name, definition, options)
end

function Library:GetThemeDefinition(name)
    local safeName = tostring(name or Library.Theme or "Midnight")
    local definition = ThemePresets[safeName] or Library.RegisteredThemes[safeName]
    if not definition then return nil end
    return table.clone(definition)
end

function Library:GetThemeTokens()
    return table.clone(Library.ThemeTokens)
end

function Library:RemoveTheme(name)
    local safeName = normalizeThemeName(name)
    if not safeName or not Library.RegisteredThemes[safeName] then return false end
    Library.RegisteredThemes[safeName] = nil
    if type(M779_PREFERENCES.UserThemes) == "table" then
        M779_PREFERENCES.UserThemes[safeName] = nil
        save4DPreferences()
    end
    return true
end

local function colorToHex(color)
    local r = math.floor(math.clamp(color.R, 0, 1) * 255 + 0.5)
    local g = math.floor(math.clamp(color.G, 0, 1) * 255 + 0.5)
    local b = math.floor(math.clamp(color.B, 0, 1) * 255 + 0.5)
    return string.format("#%02X%02X%02X", r, g, b)
end

function Library:ExportTheme(name)
    local safeName = tostring(name or Library.Theme or "Midnight")
    local definition = ThemePresets[safeName] or Library.RegisteredThemes[safeName]
    if not definition then return nil, "theme not found" end
    local payload = {Format="4DTheme", Version=1, Name=safeName, Tokens={}}
    for token, value in pairs(definition) do
        if typeof(value) == "Color3" then
            payload.Tokens[token] = colorToHex(value)
        elseif type(value) == "number" then
            payload.Tokens[token] = value
        end
    end
    local ok, encoded = pcall(function() return HttpService:JSONEncode(payload) end)
    if not ok then return nil, tostring(encoded) end
    return encoded
end

local function parseThemeColor(value)
    if typeof(value) == "Color3" then return value end
    if type(value) ~= "string" then return nil end
    local hex = string.gsub(value, "^#", "")
    if #hex ~= 6 or not string.match(hex, "^%x%x%x%x%x%x$") then return nil end
    return Color3.fromRGB(
        tonumber(string.sub(hex, 1, 2), 16),
        tonumber(string.sub(hex, 3, 4), 16),
        tonumber(string.sub(hex, 5, 6), 16))
end

function Library:ImportTheme(encoded, options)
    if type(encoded) ~= "string" or #encoded > 32768 then
        return false, "invalid theme data"
    end
    local ok, payload = pcall(function() return HttpService:JSONDecode(encoded) end)
    if not ok or type(payload) ~= "table" or payload.Format ~= "4DTheme" or type(payload.Tokens) ~= "table" then
        return false, "unsupported theme format"
    end
    local definition = {}
    for token, value in pairs(payload.Tokens) do
        if THEME_COLOR_TOKENS[token] then
            local color = parseThemeColor(value)
            if not color then return false, "invalid color token '" .. tostring(token) .. "'" end
            definition[token] = color
        elseif THEME_NUMBER_TOKENS[token] then
            definition[token] = value
        else
            return false, "unknown theme token '" .. tostring(token) .. "'"
        end
    end
    return Library:RegisterTheme(payload.Name, definition, options)
end

-- Restore registered user palettes after the persistence layer is initialized.
for savedName, savedDefinition in pairs(M779_PREFERENCES.UserThemes or {}) do
    local safeName = normalizeThemeName(savedName)
    if safeName and not BUILTIN_THEME_NAMES[safeName] then
        local normalized = validateThemeDefinition(savedDefinition, ThemePresets.Midnight)
        if normalized then Library.RegisteredThemes[safeName] = normalized end
    end
end

function Library:SetTheme(themeName, customTheme)
    Theme = resolveTheme(themeName, customTheme)
    Library.Theme = themeName or "Midnight"
    return Theme
end

function Library:GetThemes()
    local names = { "Midnight", "White", "Glass", "Ocean", "Sakura", "Emerald", "Sunset", "Carbon", "Aurora", "Custom" }
    local customNames = {}
    for name in pairs(Library.RegisteredThemes or {}) do
        if type(name) == "string" then table.insert(customNames, name) end
    end
    table.sort(customNames, function(a, b) return string.lower(a) < string.lower(b) end)
    for _, name in ipairs(customNames) do table.insert(names, name) end
    return names
end

Library.Version = "1.0.0"
Library.Theme = "Midnight"
Library.Authoring = "Open Source UI Framework"
Library.CreateWindow = Library.CreateWindow

-- Do not use Library as its own metatable. Since Library.__index = Library,
-- self-metatable lookup recurses forever for any missing key and Luau reports
-- "__index chain too long". Instances still inherit methods via setmetatable(..., Library).



-- 4D v4.7.0 | Standalone executor edition
-- A restrained dashboard layout: no decorative gradient rails or crowded cards.
Library.Version = "1.0.0"

-- Persist normalized defaults now so the next injection starts from the same local theme.
M779_PREFERENCES.Theme = savedThemeName
M779_PREFERENCES.Style = tostring(M779_PREFERENCES.Style or "Solid")
save4DPreferences()

local function start4DDemo()
    local Window = Library:CreateWindow({
        Name = "779 Minimal",
        Subtitle = "MINIMAL 4D GUI",
        Theme = savedThemeName,
        CustomTheme = M779_PREFERENCES.CustomTheme,
        Style = M779_CONFIG.Style,
        Animation = { AutoTheme = M779_PREFERENCES.IntroAutoTheme ~= false },
        Appearance = {
            Style = M779_CONFIG.Style,
            GradientColors = M779_CONFIG.GradientColors,
            BackgroundImage = M779_CONFIG.BackgroundImage ~= "" and M779_CONFIG.BackgroundImage or nil,
            BackgroundImageTransparency = M779_CONFIG.BackgroundImageTransparency,
        },
        BackgroundMusic = M779_CONFIG.BackgroundMusic ~= "" and {
            SoundId = M779_CONFIG.BackgroundMusic,
            Volume = M779_CONFIG.MusicVolume,
            PlaybackSpeed = 1,
        } or nil,
        Width = 1240,
        Height = 760,
        SidebarWidth = 218,
        ToggleKey = Enum.KeyCode.RightControl,
        LoadingScreen = {
            Image = "rbxassetid://5725566168",
            ImageTransparency = 0,
            TintTransparency = 0.48,
            CardTransparency = 0.22,
            Status = "Preparing interface...",
            Duration = 4.8,
        },
        HeroImage = "rbxassetid://5725566168",
    })

    local function panel(parent, name, position, size, z)
        local layer = z or 10
        -- Two restrained depth layers create a premium lifted surface without
        -- BlurEffect or per-frame work. They inherit the active palette.
        local shadow = make("Frame", {
            Name = name .. "_DepthShadow",
            Position = UDim2.new(position.X.Scale, position.X.Offset + 2, position.Y.Scale, position.Y.Offset + 5),
            Size = size,
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.68,
            BorderSizePixel = 0,
            ZIndex = math.max(1, layer - 2),
        }, parent)
        corner(shadow, 15)
        local halo = make("Frame", {
            Name = name .. "_AccentHalo",
            Position = UDim2.new(position.X.Scale, position.X.Offset - 1, position.Y.Scale, position.Y.Offset - 1),
            Size = UDim2.new(size.X.Scale, size.X.Offset + 2, size.Y.Scale, size.Y.Offset + 2),
            BackgroundColor3 = Theme.Purple,
            BackgroundTransparency = 0.91,
            BorderSizePixel = 0,
            ZIndex = math.max(1, layer - 1),
        }, parent)
        corner(halo, 15)
        local haloGradient = gradient(halo, {Theme.Purple, Theme.Blue, Theme.Cyan}, 18)
        haloGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.30),
            NumberSequenceKeypoint.new(0.5, 0.72),
            NumberSequenceKeypoint.new(1, 0.30),
        })
        local f = make("Frame", {
            Name = name,
            Position = position,
            Size = size,
            BackgroundColor3 = Theme.Surface,
            BackgroundTransparency = math.min(0.12, Theme.PanelTransparency or 0.03),
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = layer,
        }, parent)
        f:SetAttribute("4D_PanelSurface", true)
        corner(f, 13)
        stroke(f, Theme.Stroke, 0.30, 1.15)
        local surfaceGradient = gradient(f, {Theme.Surface2, Theme.Surface, Theme.Background}, 90)
        surfaceGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.76),
            NumberSequenceKeypoint.new(0.48, 0.93),
            NumberSequenceKeypoint.new(1, 0.82),
        })
        local topEdge = make("Frame", {
            Name = "PanelTopHighlight",
            Position = UDim2.fromOffset(14, 0),
            Size = UDim2.new(1, -28, 0, 1),
            BackgroundColor3 = Theme.Cyan,
            BackgroundTransparency = 0.58,
            BorderSizePixel = 0,
            ZIndex = layer + 1,
        }, f)
        gradient(topEdge, {Theme.Purple, Theme.Cyan, Theme.Blue}, 0)
        return f
    end

    local function label(parent, value, size, color, pos, dims, font, align, z)
        local t = createLabel(parent, value, size, color or Theme.Text,
            font or Enum.Font.Gotham, align or Enum.TextXAlignment.Left)
        t.Position = pos
        t.Size = dims
        t.ZIndex = z or 12
        return t
    end

    local function actionButton(parent, value, pos, dims, callback, primary)
        local b = make("TextButton", {
            Position = pos,
            Size = dims,
            BackgroundColor3 = primary and Theme.Purple or Theme.Surface2,
            BackgroundTransparency = primary and 0.04 or 0.08,
            BorderSizePixel = 0,
            Text = value,
            TextColor3 = Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamSemibold,
            AutoButtonColor = false,
            ZIndex = 14,
        }, parent)
        corner(b, 9)
        stroke(b, primary and Theme.Purple or Theme.Stroke, 0.42, 1)
        addConnection(Window, b.MouseEnter:Connect(function()
            tween(b, 0.14, {BackgroundTransparency = 0, BackgroundColor3 = primary and Theme.Blue or Theme.Surface3})
        end))
        addConnection(Window, b.MouseLeave:Connect(function()
            tween(b, 0.14, {BackgroundTransparency = primary and 0.04 or 0.08, BackgroundColor3 = primary and Theme.Purple or Theme.Surface2})
        end))
        addConnection(Window, b.Activated:Connect(function()
            if callback then callback() end
        end))
        return b
    end

    local Home = Window:CreateTab("Home", "⌂", "Your 4D workspace at a glance.")

    local Components = Window:CreateTab("Components", "◇", "Ready-to-use interface elements.")
    local Themes = Window:CreateTab("Themes", "◐", "Choose a visual style for your project.")
    local Customize = Window:CreateTab("Customize", "⚙", "All visual and intro customization in one place.")
    local Gallery = Window:CreateTab("Gallery", "▧", "Artwork and image components.")
    local Settings = Window:CreateTab("Settings", "⚙", "Framework preferences.")
    local About = Window:CreateTab("About", "ⓘ", "About the 4D open-source framework.")

    -- Rebuild Home from a genuinely clean page. The earlier showcase section
    -- must be removed too; leaving it behind causes a second layer under the dashboard.
    for _, child in ipairs(Home._page:GetChildren()) do
        child:Destroy()
    end
    Home._page.AutomaticCanvasSize = Enum.AutomaticSize.None
    Home._page.CanvasSize = UDim2.fromScale(0, 0)

    local root = make("Frame", {
        Name = "4D_CleanDashboard",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 9,
    }, Home._page)

    -- Top row: artwork welcome card and compact status panel.
    local hero = panel(root, "WelcomeCard",
        UDim2.fromScale(0, 0), UDim2.new(0.685, -8, 0.36, -8), 10)

    local heroImage = make("ImageLabel", {
        Name = "WelcomeArtwork",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5725566168",
        ImageTransparency = 0,
        ScaleType = Enum.ScaleType.Crop,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, hero)
    local heroShade = make("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(5, 6, 14),
        BackgroundTransparency = 0.24,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, hero)
    local shade = gradient(heroShade, {
        Color3.fromRGB(5, 6, 14),
        Color3.fromRGB(7, 8, 18),
        Color3.fromRGB(7, 8, 18),
    }, 0)
    shade.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.04),
        NumberSequenceKeypoint.new(0.48, 0.34),
        NumberSequenceKeypoint.new(1, 0.08),
    })

    label(hero, "WELCOME TO", 10, Theme.Cyan,
        UDim2.new(0.53, 0, 0.20, 0), UDim2.new(0.42, -22, 0, 18),
        Enum.Font.GothamBold)
    label(hero, "4D", 58, Color3.new(1, 1, 1),
        UDim2.new(0.52, 0, 0.29, 0), UDim2.new(0.42, -22, 0, 70),
        Enum.Font.GothamBlack)
    label(hero, "A flexible UI framework for Roblox.\nBuild clean interfaces with reusable components.",
        13, Theme.Muted, UDim2.new(0.535, 0, 0.57, 0),
        UDim2.new(0.42, -24, 0, 48), Enum.Font.Gotham)
    actionButton(hero, "Explore components  →",
        UDim2.new(0.535, 0, 0.79, 0), UDim2.fromOffset(190, 37),
        function() Window:Notify({Title = "4D Components", Content = "Open the Components tab to explore the library.", Duration = 3}) end,
        true)

    local status = panel(root, "StatusCard",
        UDim2.new(0.695, 0, 0, 0), UDim2.new(0.305, 0, 0.36, -8), 10)
    label(status, "SYSTEM OVERVIEW", 10, Theme.Soft,
        UDim2.fromOffset(18, 17), UDim2.new(1, -36, 0, 18), Enum.Font.GothamBold)
    local statusItems = {
        {"Framework", "4D UI"},
        {"Version", tostring(Library.Version)},
        {"Theme", tostring(Window._themeName or "Midnight")},
        {"Build", "Open Source"},
    }
    for i, item in ipairs(statusItems) do
        local y = 52 + (i - 1) * 43
        label(status, item[1], 12, Theme.Muted,
            UDim2.fromOffset(18, y), UDim2.new(0.48, -18, 0, 22))
        label(status, item[2], 12, Theme.Text,
            UDim2.new(0.48, 0, 0, y), UDim2.new(0.52, -18, 0, 22),
            Enum.Font.GothamSemibold, Enum.TextXAlignment.Right)
        if i < #statusItems then
            local divider = make("Frame", {
                Position = UDim2.new(0, 18, 0, y + 31),
                Size = UDim2.new(1, -36, 0, 1),
                BackgroundColor3 = Theme.Stroke,
                BackgroundTransparency = 0.72,
                BorderSizePixel = 0,
                ZIndex = 11,
            }, status)
        end
    end

    -- Middle row: two balanced panels.
    local quick = panel(root, "QuickStart",
        UDim2.new(0, 0, 0.385, 0), UDim2.new(0.49, -7, 0.34, -8), 10)
    label(quick, "QUICK START", 11, Theme.Soft,
        UDim2.fromOffset(18, 15), UDim2.new(1, -36, 0, 20), Enum.Font.GothamBold)
    label(quick, "Everything you need to get started.", 15, Theme.Text,
        UDim2.fromOffset(18, 42), UDim2.new(1, -36, 0, 25), Enum.Font.GothamSemibold)

    local quickItems = {
        {"01", "Create a window", "Start with Library:CreateWindow()."},
        {"02", "Add components", "Build tabs, sections and controls."},
        {"03", "Customize the theme", "Choose a preset or define your own."},
    }
    for i, item in ipairs(quickItems) do
        local y = 82 + (i - 1) * 49
        local number = make("Frame", {
            Position = UDim2.fromOffset(18, y),
            Size = UDim2.fromOffset(30, 30),
            BackgroundColor3 = Theme.Surface2,
            BorderSizePixel = 0,
            ZIndex = 12,
        }, quick)
        corner(number, 8)
        label(number, item[1], 10, Theme.Cyan,
            UDim2.fromScale(0, 0), UDim2.fromScale(1, 1),
            Enum.Font.GothamBold, Enum.TextXAlignment.Center, 13)
        label(quick, item[2], 12, Theme.Text,
            UDim2.fromOffset(60, y - 1), UDim2.new(1, -78, 0, 18),
            Enum.Font.GothamSemibold)
        label(quick, item[3], 10, Theme.Muted,
            UDim2.fromOffset(60, y + 17), UDim2.new(1, -78, 0, 16))
    end

    local appearance = panel(root, "AppearanceCard",
        UDim2.new(0.50, 0, 0.385, 0), UDim2.new(0.50, 0, 0.34, -8), 10)
    label(appearance, "APPEARANCE", 11, Theme.Soft,
        UDim2.fromOffset(18, 15), UDim2.new(1, -36, 0, 20), Enum.Font.GothamBold)
    label(appearance, "Choose your interface style", 15, Theme.Text,
        UDim2.fromOffset(18, 42), UDim2.new(1, -36, 0, 25), Enum.Font.GothamSemibold)

    local themeOptions = {
        {"🌌 Midnight", ThemePresets.Midnight.Purple, "Midnight"},
        {"🌊 Ocean", ThemePresets.Ocean.Cyan, "Ocean"},
        {"🌸 Sakura", ThemePresets.Sakura.Purple, "Sakura"},
        {"🌿 Emerald", ThemePresets.Emerald.Purple, "Emerald"},
        {"🌅 Sunset", ThemePresets.Sunset.Purple, "Sunset"},
        {"⚫ Carbon", ThemePresets.Carbon.Purple, "Carbon"},
        {"✨ Aurora", ThemePresets.Aurora.Cyan, "Aurora"},
        {"☁️ White", ThemePresets.White.Purple, "White"},
    }
    for i, item in ipairs(themeOptions) do
        local swatch = make("TextButton", {
            Position = UDim2.new(((i - 1) % 4) * 0.245, 18, 0, 88 + math.floor((i - 1) / 4) * 67),
            Size = UDim2.new(0.225, -3, 0, 58),
            BackgroundColor3 = Theme.Surface2,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 12,
        }, appearance)
        corner(swatch, 9)
        stroke(swatch, Theme.Stroke, 0.48, 1)
        local colorChip = make("Frame", {
            Position = UDim2.new(0.5, -10, 0, 6),
            Size = UDim2.fromOffset(20, 20),
            BackgroundColor3 = item[2],
            BorderSizePixel = 0,
            ZIndex = 13,
        }, swatch)
        corner(colorChip, 20)
        label(swatch, item[1], 9, Theme.Muted,
            UDim2.new(0, 0, 0, 32), UDim2.new(1, 0, 0, 17),
            Enum.Font.GothamMedium, Enum.TextXAlignment.Center, 13)
        addConnection(Window, swatch.Activated:Connect(function()
            Window:SetTheme(item[3] or item[1])
            Window:Notify({
                Title = (item[3] or item[1]) .. " theme",
                Content = "The complete interface palette has been updated.",
                Type = "success",
                Duration = 2.4,
            })
        end))
    end

    -- Bottom row: restrained brand signature and activity card.
    local activity = panel(root, "ActivityCard",
        UDim2.new(0, 0, 0.75, 0), UDim2.new(0.62, -7, 0.25, -2), 10)
    label(activity, "RECENT ACTIVITY", 10, Theme.Soft,
        UDim2.fromOffset(18, 13), UDim2.new(1, -36, 0, 18), Enum.Font.GothamBold)
    local activityRows = {
        {"✓", "Interface initialized", "All core modules are ready.", Theme.Good},
        {"i", "Welcome to 4D", "Explore the components and themes.", Theme.Cyan},
    }
    for i, item in ipairs(activityRows) do
        local y = 43 + (i - 1) * 42
        label(activity, item[1], 16, item[4],
            UDim2.fromOffset(19, y), UDim2.fromOffset(22, 23), Enum.Font.GothamBold)
        label(activity, item[2], 11, Theme.Text,
            UDim2.fromOffset(49, y), UDim2.new(1, -65, 0, 17), Enum.Font.GothamSemibold)
        label(activity, item[3], 9, Theme.Muted,
            UDim2.fromOffset(49, y + 17), UDim2.new(1, -65, 0, 15))
    end

    local signature = panel(root, "BrandCard",
        UDim2.new(0.635, 0, 0.75, 0), UDim2.new(0.365, 0, 0.25, -2), 10)
    signature.ClipsDescendants = false
    local cubeHolder = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.22, 0, 0.53, 0),
        Size = UDim2.fromOffset(86, 86),
        BackgroundTransparency = 1,
        ZIndex = 12,
    }, signature)
    createTesseract(Window, cubeHolder, 86, 0.01)
    label(signature, "4D", 43, Color3.new(1, 1, 1),
        UDim2.new(0.43, 0, 0.25, 0), UDim2.new(0.50, 0, 0, 52),
        Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
    label(signature, "BEYOND DIMENSIONS", 8, Theme.Cyan,
        UDim2.new(0.43, 0, 0.62, 0), UDim2.new(0.50, 0, 0, 18),
        Enum.Font.GothamBold, Enum.TextXAlignment.Center)

    -- Public component examples, all labels in English.
    local buttonSection = Components:CreateSection("Buttons & toggles")
    buttonSection:CreateButton({
        Name = "Notification",
        ButtonText = "Show notification",
        Callback = function()
            Window:Notify({Title = "4D", Content = "Your interface is ready.", Duration = 3})
        end,
    })
    buttonSection:CreateToggle({
        Name = "Enable visual effects",
        CurrentValue = true,
        Callback = function(value) Window:SetVisualEffects(value) end,
    })
    local sliderSection = Components:CreateSection("Values & selection")
    sliderSection:CreateSlider({
        Name = "Animation speed",
        Range = {0.4, 2.5},
        Increment = 0.05,
        CurrentValue = tonumber(M779_PREFERENCES.AnimationSpeed) or 1,
        Callback = function(value) Window:SetAnimationSpeed(value) end,
    })
    sliderSection:CreateDropdown({
        Name = "Quality preset",
        Options = {"Low", "Medium", "High", "Ultra"},
        CurrentOption = "High",
        Callback = function(value) print("Quality:", value) end,
    })

    local themeSection = Themes:CreateSection("Theme presets")
    local themeDisplayOptions = {"🌌 Midnight", "🌸 Sakura", "🌿 Emerald"}
    themeSection:CreateDropdown({
        Name = "Interface theme",
        Options = themeDisplayOptions,
        CurrentOption = (THEME_PRESENTATIONS[tostring(M779_PREFERENCES.Theme or "Midnight")] and
            (THEME_PRESENTATIONS[tostring(M779_PREFERENCES.Theme or "Midnight")].Emoji .. " " .. tostring(M779_PREFERENCES.Theme or "Midnight"))) or "🎨 Custom",
        Callback = function(value)
            Window:SetTheme(THEME_DISPLAY_NAMES[value] or value)
        end,
    })
    local liveCustom = {
        Purple = Theme.Purple,
        Background = Theme.Background,
        Surface = Theme.Surface,
        Text = Theme.Text,
        Cyan = Theme.Cyan,
    }
    themeSection:CreateColorPicker({
        Name = "Accent color",
        CurrentValue = liveCustom.Purple,
        Callback = function(color)
            local _, currentPalette = Window:GetTheme()
            liveCustom = currentPalette
            liveCustom.Purple = color
            Window:SetTheme("Custom", liveCustom)
            Window:SetGradientColors({liveCustom.Purple, Theme.Blue, liveCustom.Cyan})
        end,
    })
    themeSection:CreateColorPicker({
        Name = "Background color",
        CurrentValue = liveCustom.Background,
        Callback = function(color)
            local _, currentPalette = Window:GetTheme()
            liveCustom = currentPalette
            liveCustom.Background = color
            Window:SetTheme("Custom", liveCustom)
        end,
    })
    themeSection:CreateColorPicker({
        Name = "Panel color",
        CurrentValue = liveCustom.Surface,
        Callback = function(color)
            local _, currentPalette = Window:GetTheme()
            liveCustom = currentPalette
            liveCustom.Surface = color
            Window:SetTheme("Custom", liveCustom)
        end,
    })
    themeSection:CreateColorPicker({
        Name = "Text color",
        CurrentValue = liveCustom.Text,
        Callback = function(color)
            local _, currentPalette = Window:GetTheme()
            liveCustom = currentPalette
            liveCustom.Text = color
            Window:SetTheme("Custom", liveCustom)
        end,
    })
    themeSection:CreateColorPicker({
        Name = "Secondary accent",
        CurrentValue = liveCustom.Cyan,
        Callback = function(color)
            local _, currentPalette = Window:GetTheme()
            liveCustom = currentPalette
            liveCustom.Cyan = color
            Window:SetTheme("Custom", liveCustom)
            Window:SetGradientColors({liveCustom.Purple, Theme.Blue, liveCustom.Cyan})
        end,
    })
    themeSection:CreateParagraph({
        Title = "Custom theme",
        Content = [[Choose a preset, then edit Accent, Background, Panel and Text colors. Changes apply immediately. Use Window:SetTheme("Custom", palette) in your own script.]],
    })

    local imageSection = Gallery:CreateSection("Image components")
    imageSection:CreateImage({
        Image = "rbxassetid://5725566168",
        Height = 220,
        ScaleType = Enum.ScaleType.Crop,
        Caption = "4D / Beyond Dimensions",
    })

    local settingsSection = Settings:CreateSection("General")
    local textStudio
    local customizeOverview = Customize:CreateSection("Customization center")
    customizeOverview:CreateParagraph({
        Title = "One place for every visual setting",
        Content = "Choose a theme, interface style, intro scene, typography preset and corner treatment here. The original Themes and Settings tabs remain available for detailed controls."
    })
    customizeOverview:CreateDropdown({
        Name = "Theme",
        Options = {"🌌 Midnight", "🌸 Sakura", "🌿 Emerald"},
        CurrentOption = (THEME_PRESENTATIONS[tostring(Window._themeName or "Midnight")] and (THEME_PRESENTATIONS[tostring(Window._themeName or "Midnight")].Emoji .. " " .. tostring(Window._themeName or "Midnight"))) or "🎨 Custom",
        Callback = function(value) Window:SetTheme(THEME_DISPLAY_NAMES[value] or value) end,
    })
    customizeOverview:CreateDropdown({
        Name = "Interface style",
        Options = {"Solid", "Glass", "Neon", "Minimal"},
        CurrentOption = tostring(M779_PREFERENCES.Style or M779_CONFIG.Style or "Solid"),
        Callback = function(value) Window:SetStyle(value) end,
    })
    customizeOverview:CreateDropdown({
        Name = "Intro scene",
        Options = {"Use theme animation", "Waterfall", "Starfall", "Sakura"},
        CurrentOption = "Use theme animation",
        Callback = function(value)
            if value == "Use theme animation" then
                local presentation = THEME_PRESENTATIONS[Window._themeName or "Midnight"] or THEME_PRESENTATIONS.Midnight
                Window:SetAnimation(presentation.Cutscene, false, true)
                Window:SetCutsceneTextPreset(presentation.TextPreset, false, true)
                Window._themeAutoPresentation = true
            else
                Window:SetAnimation(value, false)
                M779_CONFIG.Intro = value
            end
        end,
    })
    customizeOverview:CreateDropdown({
        Name = "Intro text preset",
        Options = {"Auto", "Minimal779"},
        CurrentOption = tostring(Window._cutsceneTextPreset or "Minimal779"),
        Callback = function(value)
            Window:SetCutsceneTextPreset(value, false)
            if value == "Auto" then
                local presentation = THEME_PRESENTATIONS[Window._themeName or "Midnight"] or THEME_PRESENTATIONS.Midnight
                Window:SetCutsceneTextPreset(presentation.TextPreset, false, true)
            end
        end,
    })
    customizeOverview:CreateDropdown({
        Name = "Interface font",
        Options = {"Gotham", "GothamMedium", "GothamSemibold", "GothamBold", "GothamBlack", "SourceSans", "SourceSansBold", "Code", "Arcade", "SciFi", "Fantasy", "Antique"},
        CurrentOption = tostring(M779_PREFERENCES.Font or "Gotham"),
        Callback = function(value) Window:SetFont(value) end,
    })
    customizeOverview:CreateSlider({
        Name = "Corner radius",
        Range = {0, 28}, Increment = 1,
        CurrentValue = tonumber(M779_PREFERENCES.CornerRadius) or 12,
        Callback = function(value) Window:SetCornerRadius(value) end,
    })
    customizeOverview:CreateSlider({
        Name = "Animation speed",
        Range = {0.4, 2.5}, Increment = 0.05,
        CurrentValue = tonumber(M779_PREFERENCES.AnimationSpeed) or 1,
        Callback = function(value) Window:SetAnimationSpeed(value) end,
    })
    customizeOverview:CreateButton({
        Name = "Intro typography",
        ButtonText = "Open text preset selector",
        Callback = function() if textStudio then textStudio.Visible = true end end,
    })
    customizeOverview:CreateButton({
        Name = "Preview intro",
        ButtonText = "Preview current cutscene",
        Callback = function() Window:PreviewCutscene(Window._animationPreset) end,
    })
    settingsSection:CreateDropdown({
        Name = "GUI style",
        Options = {"Glass", "Solid", "Neon", "Minimal"},
        CurrentOption = tostring(M779_PREFERENCES.Style or M779_CONFIG.Style),
        Callback = function(value)
            Window:SetStyle(value)
            Window:Notify({Title = "4D appearance", Content = value .. " style applied.", Duration = 2})
        end,
    })
    settingsSection:CreateDropdown({
        Name = "Next intro animation",
        Options = {"Use theme animation", "Waterfall", "Starfall", "Sakura"},
        CurrentOption = "Use theme animation",
        Callback = function(value)
            if value == "Use theme animation" then
                local presentation = THEME_PRESENTATIONS[Window._themeName or "Midnight"] or THEME_PRESENTATIONS.Midnight
                Window:SetAnimation(presentation.Cutscene, false, true)
                Window:SetCutsceneTextPreset(presentation.TextPreset, false, true)
                Window._themeAutoPresentation = true
            else
                Window:SetAnimation(value, false)
                M779_CONFIG.Intro = value
            end
            Window:Notify({Title = "4D animation", Content = value == "Use theme animation" and "Scene and copy now follow the selected theme." or value .. " saved for the next launch.", Duration = 2})
        end,
    })
    settingsSection:CreateButton({
        Name = "Preview selected cutscene",
        ButtonText = "Play cutscene preview",
        Callback = function() Window:PreviewCutscene(M779_PREFERENCES.Intro or M779_CONFIG.Intro) end,
    })

    -- A separate floating Text Studio window: choose the actual title/subtitle/caption
    -- package used by the intro without crowding the main settings page.
    textStudio = make("Frame", {
        Name = "4D_TextStudioWindow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(560, 430),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 0.03,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 300,
    }, Window.ScreenGui)
    corner(textStudio, 18)
    stroke(textStudio, Theme.Stroke, 0.12, 1.4)
    local textStudioScale = make("UIScale", {Scale = 0.94}, textStudio)
    label(textStudio, "TEXT STUDIO", 17, Theme.Text,
        UDim2.fromOffset(22, 18), UDim2.new(1, -72, 0, 24), Enum.Font.GothamBold)
    label(textStudio, "Choose the words shown during your intro cutscene.",
        12, Theme.Muted, UDim2.fromOffset(22, 46),
        UDim2.new(1, -44, 0, 20), Enum.Font.Gotham)
    local textStudioClose = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -14, 0, 13),
        Size = UDim2.fromOffset(32, 32),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Theme.Text,
        TextSize = 20,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
        ZIndex = 302,
    }, textStudio)
    corner(textStudioClose, 9)
    addConnection(Window, textStudioClose.Activated:Connect(function()
        textStudio.Visible = false
    end))
    local textChoiceList = make("Frame", {
        Position = UDim2.fromOffset(18, 84),
        Size = UDim2.new(1, -36, 1, -98),
        BackgroundTransparency = 1,
        ZIndex = 301,
    }, textStudio)
    make("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, textChoiceList)
    local textChoiceNames = {"Auto", "Minimal779"}
    local textChoiceDescriptions = {
        Auto = "Use the presentation selected by the active theme",
        Minimal779 = "MINIMAL / 4D GUI / PRESENT YOU",
    }
    for index, presetName in ipairs(textChoiceNames) do
        local choice = make("TextButton", {
            Name = "TextPreset_" .. presetName,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.Surface2,
            BackgroundTransparency = 0.08,
            BorderSizePixel = 0,
            Text = "  " .. (presetName == "Auto" and "✨ " or "✦ ") .. presetName .. "   —   " .. textChoiceDescriptions[presetName],
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false,
            LayoutOrder = index,
            ZIndex = 302,
        }, textChoiceList)
        corner(choice, 7)
        local choiceStroke = stroke(choice, Theme.Stroke, 0.62, 1)
        addConnection(Window, choice.Activated:Connect(function()
            Window:SetCutsceneTextPreset(presetName, false)
            if presetName == "Auto" then
                local presentation = THEME_PRESENTATIONS[Window._themeName or "Midnight"] or THEME_PRESENTATIONS.Midnight
                Window:SetCutsceneTextPreset(presentation.TextPreset, false, true)
                Window._themeAutoPresentation = true
            end
            for _, sibling in ipairs(textChoiceList:GetChildren()) do
                if sibling:IsA("TextButton") then
                    sibling.BackgroundColor3 = sibling == choice and Theme.Purple or Theme.Surface2
                    sibling.BackgroundTransparency = sibling == choice and 0.08 or 0.18
                end
            end
            Window:Notify({
                Title = "Intro text updated",
                Content = presetName == "Auto" and "Text will follow the active theme." or presetName .. " text preset selected.",
                Duration = 2.2,
            })
        end))
    end
    settingsSection:CreateButton({
        Name = "Intro text selection",
        ButtonText = "Open Text Studio",
        Callback = function()
            textStudio.Visible = true
            textStudioScale.Scale = 0.94
            tween(textStudioScale, 0.2, {Scale = 1}, Enum.EasingStyle.Back)
        end,
    })
    settingsSection:CreateButton({
        Name = "Preview intro with selected text",
        ButtonText = "Preview text and scene",
        Callback = function()
            Window:PreviewCutscene(Window._animationPreset)
        end,
    })
    settingsSection:CreateTextbox({
        Name = "Background image ID",
        PlaceholderText = "Roblox image asset ID",
        CurrentValue = M779_CONFIG.BackgroundImage,
        Callback = function(value)
            Window:SetBackgroundImage(value, M779_CONFIG.BackgroundImageTransparency)
        end,
    })
    settingsSection:CreateTextbox({
        Name = "Skin / background texture ID",
        PlaceholderText = "Image / decal asset ID",
        CurrentValue = M779_CONFIG.BackgroundImage,
        Callback = function(value)
            M779_CONFIG.BackgroundImage = tostring(value or "")
            Window:SetBackgroundTexture(value, M779_CONFIG.BackgroundImageTransparency)
        end,
    })
    settingsSection:CreateSlider({
        Name = "Background texture opacity",
        Range = {0, 1}, Increment = 0.05,
        CurrentValue = M779_CONFIG.BackgroundImageTransparency,
        Callback = function(value)
            M779_CONFIG.BackgroundImageTransparency = value
            if Window._backgroundArt then Window._backgroundArt.ImageTransparency = value end
        end,
    })
    settingsSection:CreateToggle({
        Name = "UI outlines",
        CurrentValue = true,
        Callback = function(value) Window:SetOutlineEnabled(value) end,
    })
    settingsSection:CreateColorPicker({
        Name = "Outline color",
        CurrentValue = Theme.Stroke,
        Callback = function(color) Window:SetOutlineColor(color) end,
    })
    settingsSection:CreateSlider({
        Name = "Outline transparency",
        Range = {0, 1}, Increment = 0.05, CurrentValue = 0.2,
        Callback = function(value) Window:SetOutlineTransparency(value) end,
    })
    settingsSection:CreateSlider({
        Name = "Outline thickness",
        Range = {0, 6}, Increment = 0.5, CurrentValue = 1,
        Callback = function(value) Window:SetOutlineThickness(value) end,
    })
    settingsSection:CreateTextbox({
        Name = "Custom skin image ID",
        PlaceholderText = "Paste Roblox image / decal ID",
        Callback = function(value)
            local ok = Window:SetBackgroundTexture(value, M779_CONFIG.BackgroundImageTransparency)
            if ok then
                M779_CONFIG.BackgroundImage = tostring(value or "")
                Window:Notify({Title = "Skin updated", Content = "Background texture applied.", Duration = 2.2})
            end
        end,
    })

    settingsSection:CreateDropdown({
        Name = "Background music",
        Options = {"Off", "Custom asset ID"},
        CurrentOption = (tostring(M779_CONFIG.BackgroundMusic or "") == "") and "Off" or "Custom asset ID",
        Callback = function(value)
            if value == "Off" then
                M779_CONFIG.BackgroundMusic = ""
                M779_PREFERENCES.BackgroundMusic = ""
                Window:StopBackgroundMusic()
                save4DPreferences()
            else
                Window:Notify({Title = "Background music", Content = "Paste an audio asset ID in the field below.", Duration = 3})
            end
        end,
    })
    settingsSection:CreateTextbox({
        Name = "Background music ID",
        PlaceholderText = "Roblox audio asset ID",
        CurrentValue = M779_CONFIG.BackgroundMusic,
        Callback = function(value)
            if tostring(value):gsub("%s", "") == "" then
                M779_CONFIG.BackgroundMusic = ""
                M779_PREFERENCES.BackgroundMusic = ""
                Window:StopBackgroundMusic()
                save4DPreferences()
            else
                local normalized = normalizeAssetId(value)
                if not normalized then
                    Window:Notify({Title = "4D audio", Content = "Enter a valid Roblox audio asset ID.", Duration = 3})
                    return
                end
                M779_CONFIG.BackgroundMusic = tostring(value)
                M779_PREFERENCES.BackgroundMusic = tostring(value)
                local ok = Window:SetBackgroundMusic(value, M779_CONFIG.MusicVolume, 1)
                save4DPreferences()
                if not ok then Window:Notify({Title = "4D audio", Content = "Could not start this audio asset. Check its ID and permissions.", Duration = 3}) end
            end
        end,
    })
    settingsSection:CreateToggle({
        Name = "Smooth animations",
        CurrentValue = true,
        Callback = function(value) Window:SetSmoothAnimations(value) end,
    })
    settingsSection:CreateToggle({
        Name = "Glass blur",
        CurrentValue = true,
        Callback = function(value) Window:SetBlur(value, 9) end,
    })
    settingsSection:CreateDropdown({
        Name = "Interface font",
        Options = {"Gotham", "GothamMedium", "GothamSemibold", "GothamBold", "GothamBlack", "SourceSans", "SourceSansBold", "Code", "Arcade", "SciFi", "Fantasy", "Antique"},
        CurrentOption = tostring(M779_PREFERENCES.Font or "Gotham"),
        Callback = function(value) Window:SetFont(value) end,
    })
    settingsSection:CreateSlider({
        Name = "Corner radius",
        Range = {0, 28},
        Increment = 2,
        CurrentValue = tonumber(M779_PREFERENCES.CornerRadius) or 12,
        Callback = function(value) Window:SetCornerRadius(value) end,
    })
    settingsSection:CreateSlider({
        Name = "Sidebar width",
        Range = {130, 300},
        Increment = 5,
        CurrentValue = Window._sidebarWidth or 250,
        Callback = function(value) Window:SetSidebarWidth(value) end,
    })
    settingsSection:CreateSlider({
        Name = "Window transparency",
        Range = {0, 0.8},
        Increment = 0.05,
        CurrentValue = Theme.WindowTransparency or 0,
        Callback = function(value) Window:SetTransparency(value) end,
    })
    settingsSection:CreateSlider({
        Name = "Visible notification limit",
        Range = {1, 8},
        Increment = 1,
        CurrentValue = 5,
        Callback = function(value) Window:SetNotificationLimit(value) end,
    })
    settingsSection:CreateButton({
        Name = "Command Deck",
        ButtonText = "Open command palette  ·  Ctrl + K",
        Callback = function() Window:OpenCommandPalette() end,
    })
    settingsSection:CreateKeybind({
        Name = "Toggle interface",
        CurrentKey = Enum.KeyCode.RightControl,
        Callback = function(value) print("Toggle key:", value) end,
    })

    local aboutSection = About:CreateSection("4D UI Framework")
    aboutSection:CreateParagraph({
        Title = "Beyond dimensions. Beyond limits.",
        Content = "4D is an open-source Roblox UI framework with reusable components, live themes, Aurora scenes, stacked notifications and a searchable Command Deck (Ctrl + K toggles the interface; RightControl remains an alternate toggle key).",
    })

    Window:RegisterCommand("Toggle interface","Show or hide the main 4D window",function()
        Window:SetVisible(not Window._visible)
    end,"window visibility show hide")
    Window:RegisterCommand("Preview Starfall","Play the Starfall intro scene",function()
        Window:PreviewCutscene("starfall")
    end,"animation cutscene stars")
    Window:RegisterCommand("Preview Sakura","Play the Sakura scene",function()
        Window:PreviewCutscene("sakura")
    end,"animation northern lights")
    Window:RegisterCommand("Theme: Midnight","Apply the Midnight palette",function()
        Window:SetTheme("Midnight")
    end,"appearance palette midnight")
    Window:RegisterCommand("Theme: Sakura","Apply the Sakura palette",function()
        Window:SetTheme("Sakura")
    end,"appearance palette pink")
    Window:RegisterCommand("Notification test","Show a stacked notification",function()
        Window:Notify({Title="Command Deck",Content="Notifications stack upward and reflow without overlapping.",Type="success"})
    end,"toast alert")
    Window:StartAmbientAnimations()
    task.spawn(function()
        while not Window._destroyed and (not Window._introFinished or Window._activeCutsceneName ~= nil) do
            task.wait(0.12)
        end
        if not Window._destroyed and Window._visible and Window.Main and Window.Main.Visible then
            Window:Notify({
                Title = "779 is ready",
                Content = "The interface loaded successfully.",
                Duration = 4,
            })
        end
    end)
    return Window
end

function Library:CreateDemo()
    return start4DDemo()
end

function Library:GetStyles()
    return {"Minimal", "Solid", "Glass"}
end

function Library:GetAnimations()
    return {"Waterfall", "Starfall", "Sakura"}
end

Library.Version = "1.0.0"
Library.Theme = Library.Theme or "Midnight"
Library.Name = "779 Minimal"
Library.Authoring = "779 Minimal • 4D GUI"
Library.LoadingScreenDefaults = {
    ImageTransparency = 0.34,
    TintTransparency = 0.48,
    CardTransparency = 0.22,
}

-- Publish the API for additional code in the same executor environment.
pcall(function()
    if type(getgenv) == "function" then
        getgenv().Minimal779 = Library
    else
        _G.Minimal779 = Library
    end
end)

-- Library mode is the default: loadstring(...)() returns the API and does not
-- create an unsolicited demo window. Set M779_CONFIG.AutoStartDemo = true above
-- when a standalone showcase is desired, or call Library:CreateDemo() manually.
if M779_CONFIG.AutoStartDemo == true then
    local startupOK, startupResult = pcall(start4DDemo)
    if not startupOK then
        warn("[779 v" .. Library.Version .. "] Demo startup failed: " .. tostring(startupResult))
    else
        Library.ActiveWindow = startupResult
        print("[779 v" .. Library.Version .. "] Demo loaded. Ctrl+K toggles the interface.")
    end
else
    print("[779 v" .. Library.Version .. "] Library loaded. Create a window with Minimal779:CreateWindow(config).")
end

-- 4D v5.3.3: automatic global customization panel and per-element overrides.
-- Defaults are intentionally restrained and inherit the active theme.
local FOURD_DEFAULT_ELEMENT_STYLE = {
    Radius = 9,
    TextSize = 11,
    AccentColor = Theme.Purple,
    StrokeColor = Theme.Stroke,
}

local function fourDGetWindowStyle(window)
    local style = fourDMergeStyle(FOURD_DEFAULT_ELEMENT_STYLE, window and window._customization)
    if not style.BackgroundColor then style.BackgroundColor = Theme.Surface2 end
    if not style.TextColor then style.TextColor = Theme.Text end
    return style
end

-- Replace the opt-in behavior: every new element receives the current window,
-- tab, section and per-control styles, in that precedence order.
for _, factoryName in ipairs(FOURD_ELEMENT_FACTORIES) do
    local currentFactory = Section[factoryName]
    if type(currentFactory) == "function" and not Section["_4DAutoStyle_" .. factoryName] then
        Section["_4DAutoStyle_" .. factoryName] = true
        local fourDOriginalFactory = currentFactory
        Section[factoryName] = function(self, config, ...)
            local before = #(self._controls or {})
            local result = fourDOriginalFactory(self, config, ...)
            local row = self._controls and self._controls[#self._controls]
            if row and #self._controls > before then
                local window = self._tab and self._tab._window
                local style = fourDGetWindowStyle(window)
                if self._customization then style = fourDMergeStyle(style, self._customization) end
                if type(config) == "table" then
                    style = fourDMergeStyle(style, config.Style)
                    style = fourDMergeStyle(style, config.Customization)
                end
                self._elementCustomizations = self._elementCustomizations or {}
                local localStyle = type(config) == "table" and fourDMergeStyle(config.Style, config.Customization) or {}
                self._elementCustomizations[#self._controls] = localStyle
                fourDApplyElementStyle(row, style)
                row:SetAttribute("4D_ElementIndex", #self._controls)
                row:SetAttribute("4D_ElementName", tostring(type(config)=="table" and config.Name or factoryName))
                if window then
                    window._elementRegistry = window._elementRegistry or {}
                    local elementName = tostring(type(config)=="table" and config.Name or factoryName)
                    table.insert(window._elementRegistry, {
                        Row=row, Tab=self._tab, Section=self, Index=#self._controls,
                        Name=elementName, Type=factoryName,
                    })
                    local editor = window._individualSection
                    if editor and self._tab ~= window._customizationTab then
                        local elementIndex = #self._controls
                        local elementOwner = self
                        local elementStyle = table.clone(style)
                        editor:CreateParagraph({Name=self._tab._name .. " / " .. tostring(self._name or "Section") .. " / " .. elementName,
                            Content="Customize this control independently. Values here override global settings."})
                        editor:CreateSlider({Name=elementName .. " radius", Range={0,24}, Increment=1,
                            CurrentValue=style.Radius or 9,
                            Callback=function(value) elementOwner:SetElementCustomization(elementIndex, {Radius=value}) end})
                        editor:CreateSlider({Name=elementName .. " text size", Range={8,20}, Increment=1,
                            CurrentValue=style.TextSize or 11,
                            Callback=function(value) elementOwner:SetElementCustomization(elementIndex, {TextSize=value}) end})
                        editor:CreateColorPicker({Name=elementName .. " accent", CurrentValue=style.AccentColor or Theme.Purple,
                            Callback=function(value) elementOwner:SetElementCustomization(elementIndex, {AccentColor=value}) end})
                    end
                end
            end
            return result
        end
    end
end

function Window:SetCustomization(style)
    if type(style) ~= "table" then return false end
    self._customization = fourDMergeStyle(self._customization, style)
    for _, tab in ipairs(self._tabs or {}) do
        for _, section in ipairs(tab._sections or {}) do
            if section.SetCustomization then section:SetCustomization(self._customization) end
        end
    end
    return true
end

function Window:ResetCustomization()
    self._customization = table.clone(FOURD_DEFAULT_ELEMENT_STYLE)
    self._customization.AccentColor = Theme.Purple
    self._customization.StrokeColor = Theme.Stroke
    self._customization.BackgroundColor = Theme.Surface2
    self._customization.TextColor = Theme.Text
    for _, tab in ipairs(self._tabs or {}) do
        for _, section in ipairs(tab._sections or {}) do
            if section.SetCustomization then section:SetCustomization(self._customization) end
        end
    end
    return true
end

local fourDBaseSectionSetCustomization = Section.SetCustomization
function Section:SetCustomization(style)
    if type(style) ~= "table" then return false end
    self._customization = fourDMergeStyle(self._customization, style)
    self._elementCustomizations = self._elementCustomizations or {}
    for index, row in ipairs(self._controls or {}) do
        local merged = fourDMergeStyle(self._customization, self._elementCustomizations[index])
        fourDApplyElementStyle(row, merged)
    end
    return true
end

function Section:SetElementCustomization(index, style)
    index = tonumber(index)
    local row = index and self._controls and self._controls[index]
    if not row or type(style) ~= "table" then return false end
    self._elementCustomizations = self._elementCustomizations or {}
    self._elementCustomizations[index] = fourDMergeStyle(self._elementCustomizations[index], style)
    return fourDApplyElementStyle(row, self._elementCustomizations[index])
end

function Window:SetElementCustomization(tabName, sectionName, index, style)
    if type(style) ~= "table" then return false end
    for _, tab in ipairs(self._tabs or {}) do
        if tab._name == tabName then
            for _, section in ipairs(tab._sections or {}) do
                if section._name == sectionName then
                    return section:SetElementCustomization(index, style)
                end
            end
            if tab._defaultSection and tab._defaultSection._name == sectionName then
                return tab._defaultSection:SetElementCustomization(index, style)
            end
        end
    end
    return false
end

-- New tabs and sections inherit the global style, including those created after
-- the Customization tab. Existing public API and return values remain unchanged.
local fourDOriginalCreateTab = Window.CreateTab
Window.CreateTab = function(self, ...)
    local tab = fourDOriginalCreateTab(self, ...)
    if tab and self._customization then tab._customization = table.clone(self._customization) end
    return tab
end
local fourDOriginalCreateSection = Tab.CreateSection
Tab.CreateSection = function(self, ...)
    local section = fourDOriginalCreateSection(self, ...)
    if section and (self._customization or self._window._customization) then
        section._customization = fourDMergeStyle(self._window._customization, self._customization)
    end
    return section
end

local fourDOriginalCreateWindow = Library.CreateWindow
Library.CreateWindow = function(selfOrConfig, maybeConfig)
    local config = selfOrConfig == Library and maybeConfig or selfOrConfig
    local window = fourDOriginalCreateWindow(selfOrConfig, maybeConfig)
    if not window or window._destroyed then return window end
    window._customization = fourDMergeStyle(FOURD_DEFAULT_ELEMENT_STYLE,
        type(config) == "table" and config.Customization or nil)
    window._customization.AccentColor = window._customization.AccentColor or Theme.Purple
    window._customization.StrokeColor = window._customization.StrokeColor or Theme.Stroke
    window._customization.BackgroundColor = window._customization.BackgroundColor or Theme.Surface2
    window._customization.TextColor = window._customization.TextColor or Theme.Text
    window._elementRegistry = {}
    if type(config) ~= "table" or config.CustomizationTab ~= false then
        local customTab = window:CreateTab("Customization", "⚙", "Global style and per-element overrides")
        local globalSection = customTab:CreateSection("Global appearance")
        globalSection:CreateParagraph({
            Name="Global customization",
            Content="These settings apply automatically to existing and newly created controls. Individual controls can override them with Customization or Style.",
        })
        globalSection:CreateSlider({Name="Corner radius", Range={0,24}, Increment=1, CurrentValue=window._customization.Radius or 9,
            Callback=function(value) window:SetCustomization({Radius=value}) end})
        globalSection:CreateSlider({Name="Text size", Range={8,20}, Increment=1, CurrentValue=window._customization.TextSize or 11,
            Callback=function(value) window:SetCustomization({TextSize=value}) end})
        globalSection:CreateColorPicker({Name="Accent color", CurrentValue=window._customization.AccentColor or Theme.Purple,
            Callback=function(value) window:SetCustomization({AccentColor=value}) end})
        globalSection:CreateColorPicker({Name="Element background", CurrentValue=window._customization.BackgroundColor or Theme.Surface2,
            Callback=function(value) window:SetCustomization({BackgroundColor=value}) end})
        globalSection:CreateColorPicker({Name="Text color", CurrentValue=window._customization.TextColor or Theme.Text,
            Callback=function(value) window:SetCustomization({TextColor=value}) end})
        globalSection:CreateColorPicker({Name="Border color", CurrentValue=window._customization.StrokeColor or Theme.Stroke,
            Callback=function(value) window:SetCustomization({StrokeColor=value}) end})
        globalSection:CreateButton({Name="Reset customization", Callback=function()
            window:ResetCustomization()
        end})
        local individual = customTab:CreateSection("Individual element customization")
        window._individualSection = individual
        individual:CreateParagraph({Name="Per-element API", Content="For a single control, pass Customization={Radius=..., TextSize=..., BackgroundColor=..., TextColor=..., AccentColor=..., StrokeColor=...} in its config. Or call Section:SetElementCustomization(index, style). This overrides the global values for that control."})
        individual:CreateParagraph({Name="Example", Content='MainTab:CreateButton({Name="Launch", Customization={Radius=4, TextSize=13, AccentColor=Color3.fromRGB(255,120,80)}, Callback=function() end})'})
        window._customizationTab = customTab
    end
    return window
end

Library.Version = "1.0.0"
Library.Name = "779 Minimal"
Library.Brand = "MINIMAL 4D GUI"

-- Required for the standard loadstring(... )() workflow. The API is also
-- published as getgenv().Minimal779 for scripts that prefer the global reference.
return Library
