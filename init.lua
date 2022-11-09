function enableMicrophone()
   local microphone = hs.audiodevice.defaultInputDevice()

   if microphone then
      microphone:setInputMuted(false)
   end
end

function disableMicrophone()
   local microphone = hs.audiodevice.defaultInputDevice()

   if microphone then
      microphone:setInputMuted(true)
   end
end

function toggleMicrophone()
   local microphone = hs.audiodevice.defaultInputDevice()

   if not microphone then
      return
   end

   local next = not microphone:muted()

   microphone:setInputMuted(next)

   local state

   if next then
      state = "muted"
   else
      state = "unmuted"
   end

   hs.alert("Your microphone is now " .. state .. ".")
end

hs.hotkey.bind({}, "pad0", toggleMicrophone)
hs.hotkey.bind({}, "padenter", enableMicrophone, disableMicrophone)

function reloadConfiguration()
   hs.reload()
end

hs.hotkey.bind({}, "pad/", reloadConfiguration)
