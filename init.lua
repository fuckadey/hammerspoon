local My = My or {}


My.SystemKey = {}

function My.SystemKey.emulate(key)
    hs.eventtap.event.newSystemKeyEvent(key, true):post()
    hs.eventtap.event.newSystemKeyEvent(key, false):post()
end


My.Sound = {}

function My.Sound.up()
    My.SystemKey.emulate("SOUND_UP")
end

function My.Sound.down()
    My.SystemKey.emulate("SOUND_DOWN")
end

function My.Sound.toggle()
    My.SystemKey.emulate("MUTE")
end


local Super = { "shift", "ctrl", "cmd" }

hs.hotkey.bind(Super, "down", My.Sound.toggle)
hs.hotkey.bind(Super, "right", My.Sound.up, nil, My.Sound.up)
hs.hotkey.bind(Super, "left", My.Sound.down, nil, My.Sound.down)