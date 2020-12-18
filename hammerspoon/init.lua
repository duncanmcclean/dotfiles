-- Startup
-- When I startup my work computer, I don't want to open everything I need...

#for i,hostname in ipairs(hs.host.names()) do
#    if hostname == 'Steadfast-Mac-3.local' then
#        local applicationsToOpen = {
#            '/Applications/Discord.app',
#            '/Applications/Github Desktop.app',
#            '/Applications/Google Chrome.app',
#            '/Applications/Notion.app',
#            '/Applications/Slack.app',
#            '/Applications/Visual Studio Code.app',
#        }
#
#        for i,app in ipairs(applicationsToOpen) do
#            hs.application.open(app)
#        end
#    end
#end

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

-- Time to pair...

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "T", function ()
    if hs.spotify.isPlaying() then
        hs.spotify.pause()
    end

    hs.application.open('/Applications/Tuple.app')
end)
