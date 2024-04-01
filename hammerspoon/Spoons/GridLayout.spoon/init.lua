local M = {}

local state
local events
local helpers

-- Start GridLayout.spoon.
function M:start()
  state = dofile(hs.spoons.resourcePath('state.lua'))
  events = dofile(hs.spoons.resourcePath('events.lua'))
  helpers = dofile(hs.spoons.resourcePath('helpers.lua'))

  return M
end

-- Stop GridLayout.spoon.
function M:stop()
  events:unsubscribeAll()
  state:resetAll()
end

-- Set preset layouts to be managed by this spoon.
-- See README.md for table conventions.
function M:setLayouts(v)
  state.layouts = v

  return M
end

-- Set apps to be managed by this spoon.
-- See README.md for table conventions.
function M:setApps(v)
  state.apps = v

  return M
end


-- Alias of hs.grid.setGrid(), in case the user isn't using hs.grid
-- separately, because grid config is required for this spoon.
function M:setGrid(v)
  hs.grid.setGrid(v)

  return M
end

-- This spoon needs to manage margins because neither hs.layout.apply(),
-- nor hs.grid.getCell(), properly respects margins when set through
-- hs.grid.setMargins(). That said, we still set margins on the
-- hs.grid object, in case user is using hs.grid separately.
function M:setMargins(v)
  helpers.grid.setMargins(v)
  hs.grid.setMargins(v)

  return M
end

-- Open layout selector and apply layout.
function M:selectLayout(layout_key, variant_key)
  if layout_key then
    return helpers.applyLayout(layout_key, variant_key, state)
  end

  local choices = {}

  for key,layout in pairs(state.layouts) do
    table.insert(choices, {
      ['text'] = layout.name,
      ['subText'] = layout.description,
      ['key'] = key,
    })
  end

  local chooser = hs.chooser.new(function(choice)
    helpers.applyLayout(choice.key, nil, state)
  end)

  chooser:searchSubText(true):choices(choices):query(''):show()
end

-- Select and apply next layout variant.
function M:selectNextVariant()
  state:selectNextVariant()
  helpers.applyLayout(nil, nil, state)
end

-- Bind current app window to a specific cell.
function M:bindToCell()
  local layout = state.layouts[state.current_layout_key]
  local cells = helpers.listAppsInCells(layout, state)

  local choices = {}

  for _,cell in pairs(cells) do
    table.insert(choices, {
      ['text'] = 'Cell '..cell.key,
      ['subText'] = table.concat(cell.apps, ', '),
      ['cell'] = cell.key,
    })
  end

  local chooser = hs.chooser.new(function(choice)
    local app_id = hs.window.focusedWindow():application():bundleID()
    local window = hs.window.focusedWindow()

    hs.layout.apply({helpers.normalizeElementForApply(app_id, window, choice.cell, layout, state)})

    state.addLayoutCustomization(app_id, window, choice.cell)
  end)

  chooser:searchSubText(true):choices(choices):query(''):show()
end

-- Reset layout customizations
function M:resetLayout()
  state:resetLayout()
  helpers.applyLayout(nil, nil, state)

  return M
end

-- Reset all state
function M:resetAll()
  state:resetAll()
  helpers.applyLayout(nil, nil, state)

  return M
end

return M
