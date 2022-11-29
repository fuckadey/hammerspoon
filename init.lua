local my = {
    leader = { "shift", "ctrl", "cmd" },
}


my.system = {
    key = {},
}

function my.system.key.emulate (name)
    hs.eventtap.event.newSystemKeyEvent(name, true):post()
    hs.eventtap.event.newSystemKeyEvent(name, false):post()
end


my.sound = {
    input = {},
    output = {},
}

hs.microphoneState(true)

function my.sound.input.device ()
    return hs.audiodevice.defaultInputDevice()
end

function my.sound.input.mute ()
    local mic = my.sound.input.device()

    if mic then
        mic:setMuted(true)
    end
end

my.sound.input.mute()

function my.sound.input.unmute ()
    local mic = my.sound.input.device()

    if mic then
        mic:setMuted(false)
    end
end

function my.sound.output.up ()
    my.system.key.emulate("SOUND_UP")
end

function my.sound.output.down ()
    my.system.key.emulate("SOUND_DOWN")
end

function my.sound.output.toggle ()
    my.system.key.emulate("MUTE")
end

hs.hotkey.bind(my.leader, "up", my.sound.input.unmute, my.sound.input.mute)
hs.hotkey.bind(my.leader, "right", my.sound.output.up, nil, my.sound.output.up)
hs.hotkey.bind(my.leader, "left", my.sound.output.down, nil, my.sound.output.down)
hs.hotkey.bind(my.leader, "down", my.sound.output.toggle)