-- refers to grid.lua in this directory, taken from the Hydra wiki: https://github.com/sdegutis/hydra/wiki/Useful-Hydra-libraries
require "config"

hydra.alert "Hydra, at your service."

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
  local halfscreenwidth = screenrect.w / 2
  local halfscreenheight = screenrect.h / 2
  local newframe = {
    x = halfscreenwidth,
    y = halfscreenheight
  }
  mouse.set(newframe)
end

function movewindow_righthalf()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  newframe.x = newframe.x + newframe.w
  win:setframe(newframe)
end

function movewindow_lefthalf()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  win:setframe(newframe)
end

function movewindow_tophalf()
  local win = window.focusedwindow()
  local winframe = win:frame()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.h = newframe.h / 2
  newframe.x = winframe.x
  newframe.w = winframe.w
  win:setframe(newframe)
end

function movewindow_bottomhalf()
  local win = window.focusedwindow()
  local winframe = win:frame()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.h = newframe.h / 2
  newframe.y = newframe.y + newframe.h
  newframe.x = winframe.x
  newframe.w = winframe.w
  win:setframe(newframe)
end

function fullscreen()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  win:setframe(newframe)
end

function togglescreen()
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


hotkey.bind(super, 'DELETE', centermouse)
hotkey.bind(super, '`', togglescreen)

hotkey.bind(super, 'RETURN', fullscreen)
hotkey.bind(super, 'DOWN', movewindow_bottomhalf)
hotkey.bind(super, 'UP', movewindow_tophalf)
hotkey.bind(super, 'LEFT', movewindow_lefthalf)
hotkey.bind(super, 'RIGHT', movewindow_righthalf)

for shortcut, app in pairs(ext.config) do
  hotkey.bind(super, shortcut, function() application.launchorfocus(app) end)
end

-- hotkey.bind(mash, ';', function() ext.grid.snap(window.focusedwindow()) end)
-- hotkey.bind(mash, "'", function() fnutils.map(window.visiblewindows(), ext.grid.snap) end)

-- hotkey.bind(mash, '=', function() ext.grid.adjustwidth( 1) end)
-- hotkey.bind(mash, '-', function() ext.grid.adjustwidth(-1) end)

-- hotkey.bind(mashshift, 'H', function() window.focusedwindow():focuswindow_west() end)
-- hotkey.bind(mashshift, 'L', function() window.focusedwindow():focuswindow_east() end)
-- hotkey.bind(mashshift, 'K', function() window.focusedwindow():focuswindow_north() end)
-- hotkey.bind(mashshift, 'J', function() window.focusedwindow():focuswindow_south() end)

-- hotkey.bind(mash, 'M', ext.grid.maximize_window)

-- hotkey.bind(mash, 'N', ext.grid.pushwindow_nextscreen)
-- hotkey.bind(mash, 'P', ext.grid.pushwindow_prevscreen)

-- hotkey.bind(mash, 'J', ext.grid.pushwindow_down)
-- hotkey.bind(mash, 'K', ext.grid.pushwindow_up)
-- hotkey.bind(mash, 'H', ext.grid.pushwindow_left)
-- hotkey.bind(mash, 'L', ext.grid.pushwindow_right)

-- hotkey.bind(mash, 'U', ext.grid.resizewindow_taller)
-- hotkey.bind(mash, 'O', ext.grid.resizewindow_wider)
-- hotkey.bind(mash, 'I', ext.grid.resizewindow_thinner)

hotkey.bind(mash, 'X', logger.show)
hotkey.bind(mash, "R", repl.open)

updates.check()
