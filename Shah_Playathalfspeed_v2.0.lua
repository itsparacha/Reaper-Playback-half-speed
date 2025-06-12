--[[
Description: HalfSpeedPlayback_WithReset
Version: 2.0
Author: Shahzaib Paracha
About:
  - Toggles half-speed playback
  - Resets to normal when stopped manually (e.g., spacebar) or the same key bind
License: Apache 2.0
--]]

function stopAndReset()
    reaper.OnStopButton()
    reaper.CSurf_OnPlayRateChange(1.0)
    reaper.DeleteExtState("HalfSpeed", "active", false)
end

function monitor()
    local isPlaying = reaper.GetPlayState() & 1 == 1
    local currentRate = reaper.Master_GetPlayRate()
    local isActive = reaper.GetExtState("HalfSpeed", "active") == "1"

    if not isPlaying and currentRate ~= 1.0 and isActive then
        -- Playback stopped externally
        stopAndReset()
    else
        reaper.defer(monitor)
    end
end

function main()
    local isActive = reaper.GetExtState("HalfSpeed", "active")

    if isActive == "1" then
        -- Script already running, so this is a manual stop (toggle off)
        stopAndReset()
    else
        -- Start playback at half speed
        reaper.CSurf_OnPlayRateChange(0.5)
        reaper.OnPlayButton()
        reaper.SetExtState("HalfSpeed", "active", "1", false)
        reaper.defer(monitor)
    end
end

main()
