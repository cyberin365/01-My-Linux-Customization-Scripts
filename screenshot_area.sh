#!/bin/bash

# Define the screenshot directory
SCREENSHOT_DIR="/home/elliot/Pictures/"

# Get the current date for the filename pattern
DATE=$(date +"%b %d")

# Find the highest existing number for today's date
# We use 'ls -v' to list files in a human-friendly way (e.g., 9 comes before 10)
# 'grep' filters for files that match the date pattern
# 'awk' extracts the number from the end of the filename
# 'sort -n' sorts the numbers numerically
# 'tail -1' gets the highest number
# '|| 0' handles the case where no files exist, starting the count at 0
MAX_NUM=$(ls -v "${SCREENSHOT_DIR}" | grep "^${DATE} " | awk '{print $3}' | sed 's/\.png//' | sort -n | tail -1 || echo 0)

# Increment the highest number by 1
NEXT_NUM=$((10#$MAX_NUM + 1))

# Format the number with leading zeros and create the final filename
FINAL_COUNT=$(printf "%03d" "$NEXT_NUM")
FILENAME="${SCREENSHOT_DIR}${DATE} ${FINAL_COUNT}.png"

# Use 'xfce4-screenshooter' to capture a selected region, save it, and copy to the clipboard.
xfce4-screenshooter -r -c -s "${FILENAME}"

echo "Screenshot saved as ${FILENAME} and copied to the clipboard."
