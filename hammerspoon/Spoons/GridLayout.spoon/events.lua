local M = {}

-- Print focused window info to console for debugging purposes.
M.window_info = hs.window.filter.new():subscribe(hs.window.filter.windowFocused, function(window)
  local f = window:frame()
--   print(hs.inspect({
--     Focused = {
--       ['App Name'] = window:application():name(),
--       ['Bundle ID'] = window:application():bundleID(),
--       ['Window Title'] = window:title(),
--       ['Window ID'] = window:id(),
--       ['Window Frame'] = string.format("{x=%s,y=%s,w=%s,h=%s}", f._x, f._y, f._w, f._h),
--     }
--   }))
end)

-- Unsubscribe to all registered events.
function M:unsubscribeAll()
  M.window_info:unsubscribeAll()
end

return M
