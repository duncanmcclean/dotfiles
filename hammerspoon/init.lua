local hyper = {"cmd", "alt", "ctrl"}

-- Screenshot binding (Cmd + Home)

hs.hotkey.bind({"cmd"}, "home", function ()
    hs.eventtap.keyStroke({"shift", "cmd"}, "4")
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
