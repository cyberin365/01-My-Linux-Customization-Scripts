#!/bin/bash

SCALE=0.7
LAPTOP_MODE="3456x2160"
LAPTOP_WIDTH=3456
LAPTOP_HEIGHT=2160

# Find the name of the external monitor (not eDP-1, and is connected)
EXT_MON=$(xrandr --query | awk '/ connected/ && $1 != "eDP-1" {print $1; exit}')

if [ -n "$EXT_MON" ]; then
  # Get the external monitor's mode (resolution)
  EXT_MODE=$(xrandr | awk -v mon="$EXT_MON" '
    $1 == mon {getline; print $1}
    ' | head -n1)
  if [ -z "$EXT_MODE" ]; then
    EXT_MODE="auto"
    EXT_WIDTH=3840
    EXT_HEIGHT=2160
  else
    EXT_WIDTH=$(echo "$EXT_MODE" | cut -d'x' -f1)
    EXT_HEIGHT=$(echo "$EXT_MODE" | cut -d'x' -f2)
  fi

  # Calculate scaled widths and heights
  LAPTOP_WIDTH_SCALED=$(awk "BEGIN {printf \"%d\", $LAPTOP_WIDTH * $SCALE}")
  EXT_WIDTH_SCALED=$(awk "BEGIN {printf \"%d\", $EXT_WIDTH * $SCALE}")
  EXT_HEIGHT_SCALED=$(awk "BEGIN {printf \"%d\", $EXT_HEIGHT * $SCALE}")

  # Calculate X offset to center laptop under external
  LAPTOP_X=$(awk "BEGIN {printf \"%d\", ($EXT_WIDTH_SCALED - $LAPTOP_WIDTH_SCALED) / 2}")
  LAPTOP_X=$(( LAPTOP_X < 0 ? 0 : LAPTOP_X )) # Prevent negative offset

  # Arrange external monitor above laptop, center-aligned
  xrandr \
    --output "$EXT_MON" --mode "$EXT_MODE" --scale ${SCALE}x${SCALE} --pos 0x0 --rotate normal \
    --output eDP-1 --primary --mode $LAPTOP_MODE --scale ${SCALE}x${SCALE} --pos ${LAPTOP_X}x${EXT_HEIGHT_SCALED} --rotate normal

  # Optionally, turn off all other outputs except eDP-1 and the detected external
  for out in $(xrandr | awk '/ connected/ {print $1}' | grep -v -e "^eDP-1$" -e "^$EXT_MON$"); do
    xrandr --output "$out" --off
  done
else
  # Only internal display is connected
  xrandr --output eDP-1 --primary --mode $LAPTOP_MODE --scale ${SCALE}x${SCALE} --pos 0x0 --rotate normal
fi