dofile(package.searchpath("config", package.path)) -- load config file

hydra.alert "Hail Hydra."

pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()
autolaunch.set(true)

menu.show(function()
    return {
      {title = "About Hydra", fn = hydra.showabout},
      {title = "-"},
      {title = "Quit", fn = os.exit},
    }
end)

local mash = {"cmd", "alt", "ctrl"}
local mashshift = {"cmd", "alt", "shift"}
local super = {'cmd', 'alt', 'ctrl', 'shift'}

local function centermouse()
  hydra.alert('Center Mouse', 0.75)
  local screenrect = window.focusedwindow():screen():frame_without_dock_or_menu()
  mouse.set({
    x = screenrect.w / 2,
    y = screenrect.h / 2
  })
end

local function grid(win, col, totalcols, span)
  print(win, col, totalcols, span)
  local win = window.focusedwindow()
  local screen = win:screen():frame_without_dock_or_menu()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = screen.w / totalcols * span
  newframe.x = (col - 1) * (screen.w / totalcols) + screen.x
  win:setframe(newframe)
end

local function movewindow_tophalf()
  local win = window.focusedwindow()
  local winframe = win:frame()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.h = newframe.h / 2
  newframe.x = winframe.x
  newframe.w = winframe.w
  win:setframe(newframe)
end

local function movewindow_bottomhalf()
  local win = window.focusedwindow()
  local winframe = win:frame()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.h = newframe.h / 2
  newframe.y = newframe.y + newframe.h
  newframe.x = winframe.x
  newframe.w = winframe.w
  win:setframe(newframe)
end

local function fullscreen()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  win:setframe(newframe)
end

local function togglescreen()
  local win = window.focusedwindow()
  local winframe = win:frame()
  local currscreen = win:screen()
  local currframe = currscreen:frame_without_dock_or_menu()

  local nextscreen = currscreen:next()
  local nextframe = nextscreen:frame_without_dock_or_menu()

  win:setframe({
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
  local thisTime = os.time()
  if (thisTime - lastTime <= 1) then
    grid(window.focusedwindow(), math.min(key, lastKey), gridsize, math.abs(key - lastKey) + 1)
  else
    grid(window.focusedwindow(), key, gridsize, 1)
  end

  lastTime = thisTime
  lastKey = key
end

hotkey.bind(super, 'DELETE', centermouse)
hotkey.bind(super, '`', togglescreen)

hotkey.bind(super, 'RETURN', fullscreen)
hotkey.bind(super, 'DOWN', movewindow_bottomhalf)
hotkey.bind(super, 'UP', movewindow_tophalf)

hotkey.bind(super, '-', function()
  gridsize = math.max(gridsize - 1, 3)
  hydra.alert("Grid is now " .. gridsize)
end)
hotkey.bind(super, '=', function()
  gridsize = math.min(gridsize + 1, 9)
  hydra.alert("Grid is now " .. gridsize)
end)
hotkey.bind(super, 'LEFT', function() grid(window.focusedwindow(), 1, 2, 1) end)
hotkey.bind(super, 'RIGHT', function() grid(window.focusedwindow(), 2, 2, 1) end)

hotkey.bind(super, '1', function() processKey(1) end)
hotkey.bind(super, '2', function() processKey(2) end)
hotkey.bind(super, '3', function() processKey(3) end)
hotkey.bind(super, '4', function() processKey(4) end)
hotkey.bind(super, '5', function() processKey(5) end)
hotkey.bind(super, '6', function() processKey(6) end)
hotkey.bind(super, '7', function() processKey(7) end)
hotkey.bind(super, '8', function() processKey(8) end)
hotkey.bind(super, '9', function() processKey(9) end)

for shortcut, app in pairs(ext.config) do
  hotkey.bind(super, shortcut, function() application.launchorfocus(app) end)
end

hotkey.bind(mash, 'X', logger.show)
hotkey.bind(mash, 'R', repl.open)

function checkforupdates()
  -- I'm fine with making this a global; then I can call it in the REPL if I want.
  updates.check(function(hasone)
      if hasone then
        notify.show("Hydra update available", "Go download it!", "Click here to see the release notes.", "hasupdate")
      end
  end)
end
notify.register("hasupdate", function() os.execute("open " .. updates.changelogurl) end)

checkforupdates()

timer.new(timer.days(1), checkforupdates):start()
