--[[
Simple dissector for emulated Serial over USB

Enter "USB-serial" as display filter to ignore the USB protocol
overhead and just show the serial traffic

You may wish to add "serial.direction" and "serial.text" (ASCII) or 
"serial.data" (raw hex) as columns to monitor the stream in real time

---]]
-- declare protocol
local usbSerial_protocol = Proto("USB-serial",  "Virtual serial over USB")

local useMonitor=false

-- add fields to protocol (can display stream as text or hex vals)
local dir=ProtoField.bool("serial.direction","Direction",base.NONE, {"RX","TX"})
local data=ProtoField.bytes("serial.data","Data",base.space)
local text=ProtoField.string("serial.text","Text",base.ASCII)

usbSerial_protocol.fields = {dir, data,text}

usbSerial_protocol.prefs.istext = Pref.bool("istext",false, "Display as ASCII")

function usbSerial_protocol.dissector(buffer, pinfo, tree)
  -- baseUSBdissector:call(buffer, pinfo, tree)
  length = buffer:len()

  if (length > 0) then
    pinfo.cols.protocol = usbSerial_protocol.name

    dirVal=pinfo.p2p_dir
    
    local subtree = tree:add(usbSerial_protocol, buffer(), "Serial")
    subtree:add(dir,dirVal)

    if (useMonitor) then
      win:append(dirVal and "RX: " or "TX: ")
    end

    --subtree:add_le(data,usbDir())
    if (usbSerial_protocol.prefs.istext) then
      subtree:add(text,buffer(0,length))
      if (useMonitor) then
        win:append(buffer():string())
      end
    else
      subtree:add_le(data,buffer(0,length))
      if (useMonitor) then
        win:append(buffer():bytes():tohex(true," ") .. "\n")
      end
    end
  end
end

local usb_func = DissectorTable.get("usb.bulk")
baseUSBdissector = usb_func:get_dissector(0xffff)
usb_func:add(0xffff, usbSerial_protocol)

local function launch()
  win=TextWindow.new("Serial Spy")
  useMonitor=true
  win:add_button("Clear window", function() win:clear() end)

  --[[ I want to add a toggle between hex/ASCII here, but doesn't seem possible to change prefs programmatically
  -- win:add_button("Display hex", function() usbSerial_protocol.prefs.istext=false end)
  -- win:add_button("Display text", function() usbSerial_protocol.prefs.istext=true end)

  --]]
end

register_menu("Serial spy", launch, MENU_TOOLS_UNSORTED)
