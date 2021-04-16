local hyper = {"cmd", "alt", "ctrl"}

-- Window manager

hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0.3
spoon.MiroWindowsManager:bindHotkeys({
    up = {hyper, "up"},
    right = {hyper, "right"},
    down = {hyper, "down"},
    left = {hyper, "left"},
    fullscreen = {hyper, "f"}
})

-- Time to pair...

hs.hotkey.bind(hyper, "T", function ()
    if hs.spotify.isPlaying() then
        hs.spotify.pause()
    end

    hs.application.open('/Applications/Tuple.app')
end)

-- 🔒 Lock the computer

hs.hotkey.bind(hyper, "L", function ()
    hs.caffeinate.lockScreen()
end)

-- Activate Loom mode

-- 1. hide desktop icons
-- 2. minimise all apps, apart from current one
-- 3. make current app take up most of screen, apart from border on outside
-- 4. open Loom window?