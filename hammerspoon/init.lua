-- Window management
-- Ideally I'd like to make it so I can have a consistent window layout with the
-- same window size and windows split between Mac desktops.

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
    local primaryDisplay = hs.screen.primaryScreen()

    local openApplications = hs.application.runningApplications()

    local windowLayout = {}
    local windowLayoutCount = 0

    for k,v in pairs(openApplications) do
        local currentItem = openApplications[k]

        windowLayout[windowLayoutCount] = {currentItem:name(), nil, primaryDisplay:name(), hs.layout.left50, nil, nil}
        windowLayoutCount = windowLayoutCount + 1
    end
end)

-- Maximise current window

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "F", function ()
--    local currentWindow = hs.window.focusedWindow

--    ha.layout.apply({ currentWindow.name, nil, nil, hs.layout.maximized, nil, nil  })
-- end)

-- Time to pair...

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "T", function ()
    if hs.spotify.isPlaying() then
        hs.spotify.pause()
    end

    hs.application.open('/Applications/Tuple.app')
end)

-- Lunchtime

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "L", function ()
    -- Set slack status

    -- Stop music
    if hs.spotify.isPlaying() then
        hs.spotify.pause()
    end

    -- Stop Harvest timer
    hs.application.launchOrFocus('/Applications/Slack.app')
end)
