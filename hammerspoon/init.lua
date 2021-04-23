local hyper = {"cmd", "alt", "ctrl"}

hs.console.darkMode(true)

-- json = require("json")

-- Ray

function ray(dump)
    hs.execute("ray 'test' --large", true)
end

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

hs.hotkey.bind(hyper, "O", function ()
    local currentWindow = hs.window.focusedWindow()
    local visibleWindows = 	hs.window.visibleWindows()

    ray('me say hellow')

    -- for window in visibleWindows
    -- do
    --     print(window.new():title())
    -- end

    -- hs.application.open('/Applications/Loom.app')
end)

-- Reload Hammerspoon config

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end

    ray('whatever')
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.dotfiles/hammerspoon/", reloadConfig):start()
hs.alert.show("🥄 Reloaded")
hs.console.clearConsole()
