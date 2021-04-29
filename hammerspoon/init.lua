local hyper = {"cmd", "alt", "ctrl"}

hs.console.darkMode(true)

-- local lunajson = require 'lunajson' -- installed via Luarocks https://github.com/grafi-tt/lunajson

-- Ray

function ray(dump)
    if (type(dump) == 'string') then
        hs.execute(string.format("ray '" .. dump .. "' "), true)
    else
        local wip = string.format("ray '" .. hs.json.encode(dump) .. "' --json")

        print(wip) -- ya see, it looks fine here

        print(hs.execute(wip, true)) -- but when it gets sent to ray, it comes out as 'null'
    end
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

    ray('Sand')
    ray({ 1, 2, 3, { x = 10 } })
    ray(os.execute('php -v', true))

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
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.dotfiles/hammerspoon/", reloadConfig):start()
hs.alert.show("🥄 Reloaded")
hs.console.clearConsole()
