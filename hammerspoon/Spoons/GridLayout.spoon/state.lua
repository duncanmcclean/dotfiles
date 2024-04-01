local M = {}

M.layouts = {}
M.apps = {}
M.current_layout_key = 1
M.current_layout_variant = 1
M.layout_customizations = {}

-- Reset current layout state.
function M:resetLayout()
  M.current_layout_variant = 1
  M.layout_customizations[M.current_layout_key] = {}
end

-- Reset all state.
function M:resetAll()
  M.current_layout_key = 1
  M.current_layout_variant = 1
  M.layout_customizations = {}
end

-- Select next variant.
function M:selectNextVariant()
  if M.current_layout_key == nil then
    return
  end

  M.current_layout_variant = M.current_layout_variant + 1

  if M.layouts[M.current_layout_key].cells[1][M.current_layout_variant] == nil then
    M.current_layout_variant = 1
  end
end

-- Add window as temporary layout customization.
function M.addLayoutCustomization(app_id, window, cell)
  if not M.layout_customizations[M.current_layout_key] then
    M.layout_customizations[M.current_layout_key] = {}
  end

  M.layout_customizations[M.current_layout_key][window:id()] = {
    ['app_id'] = app_id,
    ['window'] = window,
    ['cell'] = cell,
  }
end

return M
