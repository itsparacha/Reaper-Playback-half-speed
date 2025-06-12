--[[
Description: HalfSpeedPlayback_WithReset
Version: 2.6
Author: Shahzaib Paracha
About:
  - Toggles half-speed playback
  - Resets to normal when stopped manually (e.g., spacebar)
License: Apache 2.0
--]]

local EXT_KEY = "HalfSpeedState"

-- We keep track of whether monitor is running
local monitor_running = false

-- Reset function
local function reset()
  reaper.OnStopButton()
  reaper.CSurf_OnPlayRateChange(1.0)
  reaper.DeleteExtState(EXT_KEY, "active", false)
end

-- Monitor function
function monitor()
  local playing = reaper.GetPlayState() & 1 == 1
  local active = reaper.GetExtState(EXT_KEY, "active") == "1"

  if not playing and active then
    reset()
    monitor_running = false
    return
  end

  if not active then
    -- The toggle has been turned off, so stop monitor
    monitor_running = false
    return
  end

  reaper.defer(monitor)
  monitor_running = true
end

-- Main toggle logic

local active = reaper.GetExtState(EXT_KEY, "active")

if active == "1" then
  -- If active, turn off and reset
  reaper.DeleteExtState(EXT_KEY, "active", false)
  reset()
else
  -- If not active, start playback at half speed and start monitor
  reaper.SetExtState(EXT_KEY, "active", "1", false)
  reaper.CSurf_OnPlayRateChange(0.5)
  reaper.OnPlayButton()
  
  -- If monitor already running, do nothing. Else start monitor.
  if not monitor_running then
    monitor()
  end
end
