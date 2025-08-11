#!/bin/bash

# Define the window title of the app-mode browser window
WINDOW_TITLE="Tasks"

# Define the command to launch the browser in app mode
BROWSER_COMMAND="chromium --app=https://tasks.google.com/embed/list/%7Edefault?origin=https://mail.google.com"

# Check if a window with the specified title exists.
WINDOW_ID=$(xdotool search --name "$WINDOW_TITLE")

# If the window exists...
if [ ! -z "$WINDOW_ID" ]; then
    # Check if the window is currently visible.
    if xdotool getwindowgeometry "$WINDOW_ID" | grep -q "Position: -1"; then
        # The window is not visible, so map it (make it visible).
        # You could also set a specific position here if you want.
        xdotool windowmap "$WINDOW_ID"
        xdotool windowactivate "$WINDOW_ID"
    else
        # The window is visible, so unmap it (hide it).
        xdotool windowunmap "$WINDOW_ID"
    fi
# If the window does not exist, launch a new one.
else
    $BROWSER_COMMAND &
fi

