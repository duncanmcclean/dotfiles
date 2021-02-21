-- Time to pair...

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "T", function ()
    if hs.spotify.isPlaying() then
        hs.spotify.pause()
    end

    hs.application.open('/Applications/Tuple.app')
end)
