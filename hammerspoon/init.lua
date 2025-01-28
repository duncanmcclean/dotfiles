--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

local hyper = {'alt', 'shift', 'ctrl'} -- or D+F
local bigHyper = {'alt', 'shift', 'ctrl', 'cmd'} -- or S+D+F

require('helpers')

positions = require('positions')
apps = require('apps')
layouts = require('layouts')
summon = require('summon')
chain = require('chain')


--------------------------------------------------------------------------------
-- Summon Specific Apps
--------------------------------------------------------------------------------
-- F13 to open summon modal
-- See `apps.lua` for `summon` modal bindings

local summonModalBindings = tableFlip(hs.fnutils.map(apps, function(app)
    return app.summon
end))

registerModalBindings(nil, 'f17', hs.fnutils.map(summonModalBindings, function(app)
    return function() summon(app) end
end), true)


--------------------------------------------------------------------------------
-- Misc Macros
--------------------------------------------------------------------------------

local macros = {
    s = function() hs.eventtap.keyStroke({'cmd', 'shift'}, '4') end, -- screenshot
    e = function() hs.eventtap.keyStroke({'cmd', 'ctrl'}, 'space') end, -- emoji picker
    -- f = function() hs.eventtap.keyStroke({'cmd'}, '`') end, -- next window of focused apps
    c = function() hs.eventtap.keyStroke({'cmd', 'ctrl'}, 'c') end, -- color picker
    d = function() hs.eventtap.keyStroke({'cmd', 'shift'}, 'd') end, -- dark mode
    h = function() hs.application.open('com.openai.chat') end, -- ChatGPT
}

registerModalBindings(nil, 'f16', macros, true)


--------------------------------------------------------------------------------
-- Setup GridLayout.spoon
-- See https://github.com/jesseleite/GridLayout.spoon
--------------------------------------------------------------------------------

hs.window.animationDuration = 0

local layout = hs.loadSpoon('GridLayout')
    :start()
    :setLayouts(layouts)
    :setApps(apps)
    :setGrid('60x20')
    :setMargins('10x10')

if (hs.screen.primaryScreen():name() == 'LG HDR WQHD+') then
  layout:setMargins('25x25')
end

hs.screen.watcher.new(function ()
  hs.reload()
end):start()


--------------------------------------------------------------------------------
-- Multi Window Management
--------------------------------------------------------------------------------
-- hjkl  focus window west/south/north/east
-- a     unide [a]ll application windows
-- p     [p]ick layout
-- m     [m]aximize window
-- n     [n]ext window in current cell, like `n/p` in vim
-- u     warp [u]nder another window cell
-- ;     toggle alternate layout

hs.window.animationDuration = 0

local layout = hs.loadSpoon('GridLayout')
  :start()
  :setLayouts(layouts)
  :setApps(apps)
  :setGrid('60x20')
  :setMargins('15x15')

if (hs.screen.primaryScreen():name() == 'LG HDR WQHD+') then
  layout:setMargins('30x30')
end

local windowManagementBindings = {
  ['h'] = function() hs.window.focusedWindow():focusWindowWest(nil, true) end,
  ['j'] = function() hs.window.focusedWindow():focusWindowSouth(nil, true) end,
  ['k'] = function() hs.window.focusedWindow():focusWindowNorth(nil, true) end,
  ['l'] = function() hs.window.focusedWindow():focusWindowEast(nil, true) end,
  ['a'] = function() hs.application.frontmostApplication():unhide() end,
  ['p'] = layout.selectLayout,
  ['u'] = layout.bindToCell,
  [';'] = layout.selectNextVariant,
  ["'"] = layout.resetLayout,
  -- ['m'] = toggleMaximized, -- Re-implement in GridLayout?
  -- ['n'] = focusNextCellWindow, -- Re-implement in GridLayout?
}

registerKeyBindings(hyper, hs.fnutils.map(windowManagementBindings, function(fn)
  return function() fn() end
end))


--------------------------------------------------------------------------------
-- Single Window Movements
--------------------------------------------------------------------------------
-- hl    side column movements
-- k     fullscreen and middle column movements
-- j     centered window movements
-- yu    top corner movements
-- nm    bottom corner movements
-- i     insert/snap to nearest grid region

local chainX = { 'thirds', 'halves', 'twoThirds', 'fiveSixths', 'sixths' }
local chainY = { 'full', 'thirds' }

local singleWindowMovements = {
  ['h'] = chain(getPositions(chainX, 'left')),
  ['k'] = chain(getPositions(chainY, 'center')),
  ['j'] = chain({ positions.center.large, positions.center.medium, positions.center.small, positions.center.tiny, positions.center.mini }),
  ['l'] = chain(getPositions(chainX, 'right')),
  ['y'] = chain(getPositions(chainX, 'left', 'top')),
  ['u'] = chain(getPositions(chainX, 'right', 'top')),
  ['n'] = chain(getPositions(chainX, 'left', 'bottom')),
  ['m'] = chain(getPositions(chainX, 'right', 'bottom')),
  -- ['i'] = function() hs.grid.snap(hs.window.focusedWindow()) end, -- seems buggy?
}

registerKeyBindings(bigHyper, hs.fnutils.map(singleWindowMovements, function(fn)
  return function() fn() end
end))


--------------------------------------------------------------------------------
-- Hammerspoon auto-reloading
--------------------------------------------------------------------------------

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
