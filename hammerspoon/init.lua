local hyper = {"cmd", "alt", "ctrl"}

-- Window manager --

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

hs.hotkey.bind({hyper, "T", function ()
    if hs.spotify.isPlaying() then
        hs.spotify.pause()
    end

    hs.application.open('/Applications/Tuple.app')
end)
