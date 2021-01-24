# SerialSnooper

Caveat: I've only tested this on Windows so far with a handful of USB serial devices. YMMV on other OSes, hardware, etc., 
---


## Why?
USB serial ports are a one-to-one connection; if a program is talking to the USB device, you can't just open a terminal/serial monitor to listen in on the traffic. If you're trying to debug the communication, this makes life difficult.

A number of older programs like portmon were designed to fill this role, but modern Windows doesn't seem to play nicely with them.

Wireshark is great for listening in on communications, but it also gobbles up and displays a lot of information you're probably not interested in for a simple Arduino project. This plugin simplifies the interface so you can find your bugs faster.

## What else do I need?

- Download [Wireshark](https://www.wireshark.org/download.html)
- For Windows, make sure you have the box checked to also install [USBPcap](https://desowin.org/usbpcap/) when you install Wireshark. For other OSes, check the discussion [here](https://gitlab.com/wireshark/wireshark/-/wikis/CaptureSetup/USB)

## How to use this?
In Wireshark, find the location of your Lua plugins 
(Help > About Wireshark > Folders), and copy this repo's .lua file there. You'll need to restart Wireshark or reload the Lua plugins (under Analyze menu) before this will work.

- Start capturing with the USB interface.
- Put "usb-serial" in the filter bar, and you'll only see USB traffic containing the serial communication.
- To switch between text (ASCII) display and raw hex values, right click on an entry and change Protocol Preferences > Virtual serial  > istext

For a basic, Arduino-style serial monitor, go to Tools > Serial Spy