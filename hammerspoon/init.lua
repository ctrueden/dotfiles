-- Hammerspoon config, read in place via the MJConfigFile default (see setup.sh).

hs.autoLaunch(true)

-- F12 toggles kitty's quick-access (drop-down) terminal.
-- Unlike a macOS Services shortcut, a Hammerspoon hotkey fires
-- even when the frontmost app (e.g. Firefox) swallows the key.
-- Without kitty, we leave F12 alone rather than swallow it.
local kitten = "/Applications/kitty.app/Contents/MacOS/kitten"
if hs.fs.attributes(kitten) then
  hs.hotkey.bind({}, "f12", function()
    hs.task.new(kitten, nil, {"quick-access-terminal"}):start()
  end)
end
