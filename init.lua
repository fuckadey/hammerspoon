local SystemKey = SystemKey or {}

function SystemKey.emulate(key)
    hs.eventtap.event.newSystemKeyEvent(key, true):post()
    hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

local Sound = Sound or {}

function Sound.up()
    SystemKey.emulate("SOUND_UP")
end

function Sound.down()
    SystemKey.emulate("SOUND_DOWN")
end

function Sound.toggle()
    SystemKey.emulate("MUTE")
end

local Super = { "shift", "ctrl", "cmd" }

hs.hotkey.bind(Super, "down", Sound.toggle)
hs.hotkey.bind(Super, "right", Sound.up)
hs.hotkey.bind(Super, "left", Sound.down)

