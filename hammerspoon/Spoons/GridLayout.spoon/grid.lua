-- This might be a nice FR / PR to hammerspoon, so we'll keep it out
-- of sight as a separate module that could be deleted later on.
--
-- Normally hs.grid.getCell() does not respect margins, so this helper
-- accepts a cell string and returns a frame with margins respected.
-- Most of this code was ripped from hs.grid.set(), and is just
-- modified to return a frame that respects margin settings.
--
-- Unfortunately, for this to work we also need to know the user's
-- desired margins, but there doesn't seem to be an easy way to
-- hs.grid.getMargins() or similar, so we need to set here.

local M = {}

local grid = require('hs.grid')
local geom = require('hs.geometry')
local screen = require('hs.screen')

local margins = geom'5x5'

function M.setMargins(mar)
  mar=geom.new(mar)
  if geom.type(mar)=='point' then mar=geom.size(mar.x,mar.y) end
  if geom.type(mar)~='size' then error('invalid margins',2)end
  margins=mar
end

local min,max = math.min,math.max

function M.getCellWithMargins(cell, scr)
  scr=screen.find(scr)
  if not scr then scr=hs.screen.mainScreen() end
  cell=geom.new(cell)
  local screenrect = grid.getGridFrame(scr)
  local screengrid = grid.getGrid(scr)
  cell.x=max(0,min(cell.x,screengrid.w-1)) cell.y=max(0,min(cell.y,screengrid.h-1))
  cell.w=max(1,min(cell.w,screengrid.w-cell.x)) cell.h=max(1,min(cell.h,screengrid.h-cell.y))
  local cellw, cellh = screenrect.w/screengrid.w, screenrect.h/screengrid.h
  local newframe = {
    x = (cell.x * cellw) + screenrect.x + margins.w,
    y = (cell.y * cellh) + screenrect.y + margins.h,
    w = cell.w * cellw - (margins.w * 2),
    h = cell.h * cellh - (margins.h * 2),
  }

  if cell.h < screengrid.h and cell.h % 1 == 0 then
    if cell.y ~= 0 then
      newframe.h = newframe.h + margins.h / 2
      newframe.y = newframe.y - margins.h / 2
    end

    if cell.y + cell.h ~= screengrid.h then
      newframe.h = newframe.h + margins.h / 2
    end
  end

  if cell.w < screengrid.w and cell.w % 1 == 0 then
    if cell.x ~= 0 then
      newframe.w = newframe.w + margins.w / 2
      newframe.x = newframe.x - margins.w / 2
    end

    if cell.x + cell.w ~= screengrid.w then
      newframe.w = newframe.w + margins.w / 2
    end
  end

  -- Return newframe instead of setting window frame like hs.grid.set() does
  return newframe
end

return M
