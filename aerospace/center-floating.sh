#!/bin/bash
# Auto-center floating windows that are off-screen (stuck in AeroSpace's hidden corner)
# Called from on-focus-changed in aerospace.toml

focused=$(aerospace list-windows --focused --json 2>/dev/null)
[ -z "$focused" ] || [ "$focused" = "[]" ] && exit 0

app_id=$(echo "$focused" | /usr/bin/python3 -c "import sys,json; print(json.load(sys.stdin)[0].get('app-name',''))" 2>/dev/null)
[ -z "$app_id" ] && exit 0

osascript -e "
tell application \"System Events\"
    try
        set p to first process whose name is \"$app_id\"
        set frontWin to first window of p
        set {wx, wy} to position of frontWin
        set {ww, wh} to size of frontWin

        tell application \"Finder\"
            set screenBounds to bounds of window of desktop
            set screenW to item 3 of screenBounds
            set screenH to item 4 of screenBounds
        end tell

        -- If window x is past 90% of screen width, it's in the hidden corner
        if wx > (screenW * 0.9) then
            set newX to ((screenW - ww) / 2) as integer
            set newY to ((screenH - wh) / 2) as integer
            if newX < 0 then set newX to 0
            if newY < 25 then set newY to 25
            set position of frontWin to {newX, newY}
        end if
    end try
end tell
" &
