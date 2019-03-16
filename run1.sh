#!/bin/bash
A=$(curl https://linktoyournightscout/api/v1/entries)
B=$(curl -s 'https://linktoyournightscout/pebble/' | jq -r '.bgs')
E=$(echo "$A" | head -n1 | awk -F '\t' '{print $3}')
EC=$(echo "scale=1; $E / 18" | bc)

F=$(echo "$A" | head -n2 | tail -1 | awk -F '\t' '{print $3}')
FC=$(echo "scale=1; $F / 18" | bc)
G=$(printf '%.1f\n' "$(echo "scale=1; $EC - $FC" | bc)")


iobb=$(echo "$B" | sed '1d;$d')
iocc=$(echo "$iobb" | jq -r '.iob')

rm -rf ledpanel.py
echo "import RPi.GPIO as GPIO" >> ledpanel.py
echo "from time import sleep, strftime" >> ledpanel.py
echo "from datetime import datetime" >> ledpanel.py
echo "from luma.core.interface.serial import spi, noop" >> ledpanel.py
echo "from luma.core.render import canvas" >> ledpanel.py
echo "from luma.core.virtual import viewport" >> ledpanel.py
echo "from luma.led_matrix.device import max7219" >> ledpanel.py
echo "from luma.core.legacy import text, show_message" >> ledpanel.py
echo "from luma.core.legacy.font import proportional, CP437_FONT, LCD_FONT" >> ledpanel.py
echo "serial = spi(port=0, device=0, gpio=noop())" >> ledpanel.py
echo "device = max7219(serial, width=32, height=8, block_orientation=-90)" >> ledpanel.py
echo "device.contrast(5)" >> ledpanel.py
echo "virtual = viewport(device, width=32, height=16)" >> ledpanel.py
echo "show_message(device, '$EC D $G IOB $iocc', fill='"'white'"', font=proportional(LCD_FONT), scroll_delay=0.08)" >> ledpanel.py

while :
do
  python ledpanel.py
done
