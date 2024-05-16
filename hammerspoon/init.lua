local hyper = {'cmd', 'alt', 'ctrl'}
local bigHyper = {'cmd', 'alt', 'ctrl', 'shift'}

require('helpers')

positions = require('positions')
apps = require('apps')
layouts = require('layouts')
summon = require('summon')
chain = require('chain')

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
  :setMargins('30x30')

if (hs.screen.primaryScreen():name() == 'LG HDR WQHD+') then
  layout:setMargins('40x40')
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
