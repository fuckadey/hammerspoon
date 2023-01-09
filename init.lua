local my = {
    leader = { "shift", "ctrl", "cmd" },
    std = {},
}

function my.std.rgba (red, green, blue, alpha)
    alpha = alpha or 1

    return { red = red / 255, green = green / 255, blue = blue / 255, alpha = alpha, }
end

function my.std.customKey(app, leader, key, callback)
    local key = hs.hotkey.new(leader, key, callback)

    local enable = function ()
        key:enable()
    end

    local disable = function ()
        key:disable()
    end

    local map = {
        [hs.application.watcher.activated] = enable,
        [hs.application.watcher.deactivated] = disable,
    }

    local handle = function (name, event, more)
        if app ~= name then
            return
        end

        local action = map[event]

        if action ~= nil then
            action()
        end
    end

    hs.application.watcher.new(handle):start()
end


my.hud = {
    padding = 2,
    radius = 9,
    clock = {
        timer = nil,
        instance = nil,
        size = {
            h = 18,
            w = 100,
        },
    },
}

do
    local padding, radius = my.hud.padding, my.hud.radius
    local h = my.hud.clock.size.h + (padding * 2)
    local w = my.hud.clock.size.w + (padding * 2)
    local frame = hs.screen.primaryScreen():fullFrame()
    local x = frame.w - w
    local y = frame.h - h
    local canvas = hs.canvas.new( { x = x, y = y, h = h, w = w, } )

    canvas:insertElement( {
        action = "build",
        type = "rectangle",
        padding = 0,
    } )

    canvas:insertElement( {
        action = "clip",
        type = "rectangle",
        padding = padding,
    } )

    canvas:insertElement( {
        action = "fill",
        type = "rectangle",
        padding = padding,
        fillColor = my.std.rgba(251, 220, 117),
        frame = {
            x = padding,
            y = padding,
            h = my.hud.clock.size.h,
            w = my.hud.clock.size.w,
        },
        roundedRectRadii = { xRadius = radius, yRadius = radius, },
    } )

    canvas:insertElement( {
        action = "fill",
        type = "text",
        padding = padding,
        frame = { x = "0", y = "5%", w = "1", h = "1", },
        text = "👾",
        textAlignment = "center",
        textColor = { white = 0.35, },
        textSize = 13,
    } )

    my.hud.clock.instance = canvas
end

do
    local count = my.hud.clock.instance:elementCount()

    my.hud.clock.timer = hs.timer.new(0.5, function () -- To redraw the date every half a second is precise enough for my needs
        my.hud.clock.instance:elementAttribute(count, "text", os.date("%d %b %H:%M"))
    end )
end

-- Hammerspoon uses positional booleans to start watching for certain mouse events on canvas
-- See https://www.hammerspoon.org/docs/hs.canvas.html#canvasMouseEvents
my.hud.clock.instance:canvasMouseEvents(true)

my.hud.clock.instance:mouseCallback( function (_, name)
    if name == "mouseDown" then
        hs.application.launchOrFocus("Calendar")
    end
end )

my.hud.clock.instance:show()

my.hud.clock.timer:start()


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

-- Ensure microphone is disabled when system starts
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

-- Ensure speaker is disabled when system starts
hs.audiodevice.defaultOutputDevice():setMuted(true)

hs.hotkey.bind(my.leader, "up", my.sound.input.unmute, my.sound.input.mute)
hs.hotkey.bind(my.leader, "right", my.sound.output.up, nil, my.sound.output.up)
hs.hotkey.bind(my.leader, "left", my.sound.output.down, nil, my.sound.output.down)
hs.hotkey.bind(my.leader, "down", my.sound.output.toggle)


my.mail = {}

function my.mail.open ()
    hs.application.launchOrFocus("Mail")
end

hs.hotkey.bind(my.leader, "m", my.mail.open)