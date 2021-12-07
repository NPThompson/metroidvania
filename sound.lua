-- sound.lua



sound = 
{
    play = function(str, volume, pitch)
        local snd = sound[str]
        volume = volume or 1.0
        pitch  = pitch  or 1.0
        if snd and not snd:isPlaying() then 
            snd:setVolume(volume)
            snd:setPitch(pitch)
            snd:play()
        end
    end
}