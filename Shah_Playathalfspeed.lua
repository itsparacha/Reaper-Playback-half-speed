--[[
Description: Shah_HalfSpeedPlayback
Version: 1
About:
  # Shah_Playback at half speed and reset
License: Apache 2.0

--]]

-- Toggle Half-Speed Playback Script for Reaper

-- Get current playback state
local isPlaying = reaper.GetPlayState() & 1 == 1
local currentRate = reaper.Master_GetPlayRate()

if not isPlaying or currentRate ~= 0.5 then
    -- Start playback at 0.5x
    reaper.CSurf_OnPlayRateChange(0.5)
    reaper.OnPlayButton()
else
    -- Stop playback and reset rate
    reaper.OnStopButton()
    reaper.CSurf_OnPlayRateChange(1.0)
end
