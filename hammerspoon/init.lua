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

hs.hotkey.bind({"cmd"}, "return", function ()
    hs.window.focusedWindow():centerOnScreen(nil,nil,0)
end)

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
