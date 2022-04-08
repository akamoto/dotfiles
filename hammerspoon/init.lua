-- put at beginning so this hotkey always works
-- reload config
hs.hotkey.bind({"alt", "shift" }, "r", function() hs.reload() end)
hs.alert.show("Config loaded")
-- disable hide app cmd+h
hs.hotkey.bind({"cmd"}, "h", function() hs.alert.show("there is no hiding") end)

-- a global variable for the Hyper Mode / bind capslock to esc/hyper
k = hs.hotkey.modal.new({}, "F17")
hyperBindings = {"Left", "Right", "[", "]", "h", "l", "j", "k", "m", "b", "s", "d", "f", "g", "w", "e", "r", "t", "p"}
for i,key in ipairs(hyperBindings) do
  --k:bind({}, key, nil, function() hs.eventtap.keyStroke({'cmd','alt','shift','ctrl'}, key)
  k:bind({}, key, nil, function() hs.eventtap.keyStroke({'cmd','alt','ctrl'}, key)
    k.triggered = true
  end)
end
-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
end
-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end
-- Bind the Hyper keY
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
-- AppleScript bindings
--k:bind({}, 'o', nil, function() hs.execute ('osascript /Users/manthei/Dropbox/AppleScripts/OmniFocus/QuickOpen.scpt') k.TrIgGeReD = TRUE ENd)


-------------------
-- defaults
-------------------
-- disable all window animations
hs.window.animationDuration=0

-- Make the alerts look nicer.
hs.alert.defaultStyle.strokeColor =  {white = 1, alpha = 0}
hs.alert.defaultStyle.fillColor =  {white = 0.05, alpha = 0.75}
hs.alert.defaultStyle.radius =  10


-------------------
-- load spoons
-------------------
function setUpClipboardTool()
  ClipboardTool = hs.loadSpoon('ClipboardTool')
  ClipboardTool.show_in_menubar = false
  ClipboardTool:start()
  ClipboardTool:bindHotkeys({
    toggle_clipboard = {{"ctrl", "alt", "cmd"}, "p"}
  })
end

-------------------
-- keybindings
-------------------
-- functions have to be declared before using them: see bottom for keybindings
-- modifier keys
--local mashApp = {"cmd", "ctrl"}


-------------------
-- my functions
-------------------

-- Show date time and battery
function batteryAndDate()
  local seconds = 3
  local message = os.date("%Y-%m-%d %H:%M ") .. "\n" ..  hs.battery.percentage() .. "% battery"
  hs.alert.show(message, seconds)
end

-- move window to left half of the screen
function moveLeftHalf()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end
-- move window to right half of the screen
function moveRightHalf()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end
--[[ this is not really working as expected - I do not get the unitrect
-- move window to left half of the screen
function moveLeftHalf()
  local win = hs.window.focusedWindow()
  win:moveToUnit'[50,100,0,0]'
end
-- move window to upper half of the screen
function moveRightHalf()
  local win = hs.window.focusedWindow()
  win:moveToUnit'[50,3,0,0]'
end
-- move windows to upper half of the screen
function moveUpperHalf()
  local win = hs.window.focusedWindow()
  win:moveToUnit'[100,50,0,0]'
end
-- move windows to lower half of the screen
function moveLower()
  local win = hs.window.focusedWindow()
  win:moveToUnit'[100,50,0,0]'
end
]]


local spaces = require('hs.spaces')
-- move current window to the space sp
function MoveWindowToSpace(sp)
    local win = hs.window.focusedWindow()      -- current window
    local uuid = win:screen():spacesUUID()     -- uuid for current screen
    local spaceID = spaces.layout()[uuid][sp]  -- internal index for sp
    spaces.moveWindowToSpace(win:id(), spaceID) -- move window to new space
    --spaces.changeToSpace(spaceID)              -- follow window to new space
    -- hs.alert.show("move win to " .. sp .. ":" .. spaceID .. "on: " .. uuid)

end


--function MoveToSpace(sp)
----    local win = hs.window.focusedWindow()      -- current window
----    local uuid = win:screen():spacesUUID()     -- uuid for current screen
----    local spaceID = spaces.layout()[uuid][sp]  -- internal index for sp
--    spaces.gotoSpace(sp)              -- switch to space
--    -- hs.alert.show("move focus to " .. sp .. ":" .. spaceID .. "on: " .. uuid)
--end

-- Launch new iTerm window on current desktop
hs.hotkey.bind({"ctrl", "alt"}, "z", function()
    if hs.application.find("iTerm") then
        hs.applescript.applescript([[
            tell application "iTerm"
                create window with default profile
            end tell
        ]])
    else
        hs.application.open("iTerm")
    end
end)
-- Launch new iTerm window on current desktop
hs.hotkey.bind({"ctrl", "alt"}, "x", function()
    if hs.application.find("iTerm") then
        hs.applescript.applescript([[
            tell application "iTerm"
                create window with profile "external"
            end tell
        ]])
    else
        hs.application.open("iTerm")
    end
end)

-- reconfigure keyboard keys
hs.hotkey.bind({"ctrl", "alt"}, "i", function()
    hs.execute("$HOME/.bin/mac_map_keys")
end)

-- volume control
function changeVolume(diff)
  return function()
    local current = hs.audiodevice.defaultOutputDevice():volume()
    local new = math.min(100, math.max(0, math.floor(current + diff)))
    if new > 0 then
      hs.audiodevice.defaultOutputDevice():setMuted(false)
    end
    hs.alert.closeAll(0.0)
    hs.alert.show("Volume " .. new .. "%", {}, 0.5)
    hs.audiodevice.defaultOutputDevice():setVolume(new)
  end
end

hs.hotkey.bind({'alt'}, 'c', changeVolume(-3))
hs.hotkey.bind({'alt'}, 'v', changeVolume(3))

-- set up your windowfilter
--switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
--switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}) -- include minimized/hidden windows, current Space only
--switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true)) -- current Space only, only unminimized windows
--switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}:setAppFilter("KeePassXC", false)) -- minimized, ignore keypass
switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setAppFilter("KeePassXC", false)) -- minimized, ignore keypass
--switcher_browsers = hs.window.switcher.new{'Safari','Google Chrome'} -- specialized switcher for your dozens of browser windows :)


-------------------
-- keybindings
-------------------
-- esc+cmd unfortunatly treats the bindind as "cmd" ..
-- window controls
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Left", moveLeftHalf)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Right", moveRightHalf)
--hs.hotkey.bind({"cmd", "alt", "ctrl"}, "h", focusWindowLeft)
--hs.hotkey.bind({"cmd", "alt", "ctrl"}, "l", focusWindowRight)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "[", function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "]", function() hs.window.focusedWindow():moveOneScreenEast() end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "h", function() hs.window.focusedWindow():focusWindowWest() end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "l", function() hs.window.focusedWindow():focusWindowEast() end)

-- select window to focus
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "j", function() switcher_space:next() end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "k", function() switcher_space:previous() end)

-- move window to spaces
hs.hotkey.bind({"ctrl", "alt"}, "s", function() MoveWindowToSpace(1) end)
hs.hotkey.bind({"ctrl", "alt"}, "d", function() MoveWindowToSpace(2) end)
hs.hotkey.bind({"ctrl", "alt"}, "f", function() MoveWindowToSpace(3) end)
hs.hotkey.bind({"ctrl", "alt"}, "g", function() MoveWindowToSpace(4) end)
hs.hotkey.bind({"ctrl", "alt"}, "w", function() MoveWindowToSpace(5) end)
hs.hotkey.bind({"ctrl", "alt"}, "e", function() MoveWindowToSpace(6) end)
hs.hotkey.bind({"ctrl", "alt"}, "r", function() MoveWindowToSpace(7) end)
hs.hotkey.bind({"ctrl", "alt"}, "t", function() MoveWindowToSpace(8) end)

--hs.hotkey.bind({"alt"}, "s", function() MoveToSpace(1) end)
--hs.hotkey.bind({"alt"}, "d", function() MoveToSpace(2) end)
--hs.hotkey.bind({"alt"}, "f", function() MoveToSpace(3) end)
--hs.hotkey.bind({"alt"}, "g", function() MoveToSpace(4) end)
--hs.hotkey.bind({"alt"}, "w", function() MoveToSpace(5) end)
--hs.hotkey.bind({"alt"}, "e", function() MoveToSpace(6) end)
--hs.hotkey.bind({"alt"}, "r", function() MoveToSpace(7) end)
--hs.hotkey.bind({"alt"}, "t", function() MoveToSpace(8) end)

-- other
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "m", function() hs.window.focusedWindow():maximize() end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "b", batteryAndDate)

-- lock screen
-- todo: if the esc+cmd option works out, make cmd+control+option +l the
-- lockscreen
-- for some reason the lockScreen dies after a while..
hs.hotkey.bind({"cmd", "shift"}, "l", function() hs.caffeinate.lockScreen() end)


-- show keyevents
-- hs.eventtap.new({hs.eventtap.event.types.keyUp},function(e)print(hs.inspect(e:getRawEventData()))end):start()

-- print real names of all running applications
-- hs.fnutils.each(hs.application.runningApplications(), function(app) print(app:title()) end)
-- hs.fnutils.each(hs.application.runningApplications(), function(app) print(app:title()) end)

--[[
-- function factory that takes the muLTipliers of screen width
-- and height to produce the window's x pos, y pos, width, and height
-- function baseMove(x, y, w, h)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        -- add max.x so it stays on the same screen, works with my second screen
        f.x = max.w * x + max.x
        f.y = max.h * y
        f.w = max.w * w
        f.h = max.h * h
        win:setFrame(f, 0)
    end
end

-- feature spectacle/another window sizing apps
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'Left', baseMove(0, 0, 0.5, 1))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'Right', baseMove(0.5, 0, 0.5, 1))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'Down', baseMove(0, 0.5, 1, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'Up', baseMove(0, 0, 1, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '1', baseMove(0, 0, 0.5, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '2', baseMove(0.5, 0, 0.5, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '3', baseMove(0, 0.5, 0.5, 0.5))
hS.kotkey.bind({'ctrl', 'alt', 'cmd'}, '4', baseMove(0.5, 0.5, 0.5, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'M', hs.grid.maximizeWindow)
]]

--[[
- quick jump to important applications
hs.grid.setMargins({0, 0})
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'J', function () hs.application.launchOrFocus("Intellij IDEA") end)
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'C', function () hs.application.launchOrFocus("Google Chrome") end)
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'S', function () hs.application.launchOrFocus("Slack") end)
-- even though the app is named iTerm2, iterm is the correct name
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'K', function () hs.application.launchOrFocus("iTerm") end)

-- reload config
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
  hs.notify.new({title="Hammerspoon config reloaded", informativeText="Manually via keyboard shortcut"}):send()
end)
]]

--[[
function muteOnWake(eventType)
  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    local output = hs.audiodevice.defaultOutputDevice()
    output:setMuted(true)
  end
end
caffeinateWatcher = hs.caffeinate.watcher.new(muteOnWake)
caffeinateWatcher:start()
]]

--[[
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "E", function()
  -- emulates a click
  hs.application.get("Hammerspoon"):selectMenuItem("Console...")
  hs.application.launchOrFocus("Hammerspoon")
end)
]]

setUpClipboardTool()

