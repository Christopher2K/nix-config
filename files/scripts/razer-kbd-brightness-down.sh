#!/bin/sh
SERIAL="$1"
CURRENT=$(dbus-send --session --type=method_call --print-reply \
  --dest=org.razer /org/razer/device/$SERIAL \
  razer.device.lighting.brightness.getBrightness | grep double | awk '{print $2}')
NEW=$(echo "$CURRENT - 10" | bc)
[ "$(echo "$NEW < 0" | bc)" -eq 1 ] && NEW=0
dbus-send --session --type=method_call --dest=org.razer \
  /org/razer/device/$SERIAL razer.device.lighting.brightness.setBrightness double:$NEW
