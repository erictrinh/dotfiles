dofile(package.searchpath("config", package.path)) -- load config file

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.notify.new({title="Hammerspoon", informativeText="Loaded Config"}):send()

local mash = {"cmd", "alt", "ctrl"}
local mashshift = {"cmd", "alt", "shift"}
local super = {'cmd', 'alt', 'ctrl', 'shift'}

local function grid(win, col, totalcols, span)
  print(win, col, totalcols, span)
  local win = hs.window.focusedWindow()
  local screen = win:screen():frame()
  local newframe = win:screen():frame()
  newframe.w = screen.w / totalcols * span
  newframe.x = (col - 1) * (screen.w / totalcols) + screen.x
  win:setFrame(newframe)
end

local function movewindow_tophalf()
  local win = hs.window.focusedWindow()
  local winframe = win:frame()
  local newframe = win:screen():frame()
  newframe.h = newframe.h / 2
  newframe.x = winframe.x
  newframe.w = winframe.w
  win:setFrame(newframe)
end

local function movewindow_bottomhalf()
  local win = hs.window.focusedWindow()
  local winframe = win:frame()
  local newframe = win:screen():frame()
  newframe.h = newframe.h / 2
  newframe.y = newframe.y + newframe.h
  newframe.x = winframe.x
  newframe.w = winframe.w
  win:setFrame(newframe)
end

local function fullscreen()
  local win = hs.window.focusedWindow()
  local newframe = win:screen():frame()
  win:setFrame(newframe)
end

local function togglescreen()
  local win = hs.window.focusedWindow()
  local winframe = win:frame()
  local currscreen = win:screen()
  local currframe = currscreen:frame()

  local nextscreen = currscreen:next()
  local nextframe = nextscreen:frame()

  win:setFrame({
    w = winframe.w / currframe.w * nextframe.w,
    h = winframe.h / currframe.h * nextframe.h,
    x = (winframe.x - currframe.x) / currframe.w * nextframe.w + nextframe.x,
    y = (winframe.y - currframe.y) / currframe.h * nextframe.h + nextframe.y
  })
end

local gridsize = 3
local lastKey = 0
local lastTime = 0
local function processKey(key)
  if key > gridsize then
    do return end
  end

  local thisTime = os.time()
  if (thisTime - lastTime <= 1) then
    grid(hs.window.focusedWindow(), math.min(key, lastKey), gridsize, math.abs(key - lastKey) + 1)
  else
    grid(hs.window.focusedWindow(), key, gridsize, 1)
  end

  lastTime = thisTime
  lastKey = key
end

hs.hotkey.bind(super, '`', togglescreen)

hs.hotkey.bind(super, 'RETURN', fullscreen)
hs.hotkey.bind(super, 'j', movewindow_bottomhalf)
hs.hotkey.bind(super, 'k', movewindow_tophalf)

-- hs.hotkey.bind(super, 'H', function()
--   hs.application.launchOrFocus("Things3")
-- end)

-- hs.hotkey.bind(super, 'C', function()
--   hs.application.launchOrFocus("Google Chrome")
-- end)

hs.hotkey.bind(super, '-', function()
  gridsize = math.max(gridsize - 1, 3)
  hs.alert("Grid is now " .. gridsize)
end)
hs.hotkey.bind(super, '=', function()
  gridsize = math.min(gridsize + 1, 4)
  hs.alert("Grid is now " .. gridsize)
end)
hs.hotkey.bind(super, 'h', function() grid(hs.window.focusedWindow(), 1, 2, 1) end)
hs.hotkey.bind(super, 'l', function() grid(hs.window.focusedWindow(), 2, 2, 1) end)

hs.hotkey.bind(super, '1', function() processKey(1) end)
hs.hotkey.bind(super, '2', function() processKey(2) end)
hs.hotkey.bind(super, '3', function() processKey(3) end)
hs.hotkey.bind(super, '4', function() processKey(4) end)

for shortcut, app in pairs(config) do
  hs.hotkey.bind(super, shortcut, function() hs.application.launchOrFocus(app) end)
end