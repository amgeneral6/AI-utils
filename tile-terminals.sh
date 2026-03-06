#!/bin/bash
# Tile all Terminal.app windows evenly across the screen.
# Usage: ./tile-terminals.sh [layout]
#   layout: row | grid | stack (default: grid)

LAYOUT="${1:-grid}"

osascript << EOF
tell application "Finder"
  set sb to bounds of window of desktop
  set sw to (item 3 of sb) as integer
  set sh to (item 4 of sb) as integer
end tell

set menuBar to 24
set usableH to sh - menuBar

tell application "Terminal"
  set wins to every window
  set n to count of wins
  if n is 0 then return

  if "${LAYOUT}" is "row" then
    set cols to n
    set rows to 1
  else if "${LAYOUT}" is "stack" then
    set cols to 1
    set rows to n
  else
    set cols to 1
    repeat while (cols * cols) < n
      set cols to cols + 1
    end repeat
    if (cols - 1) * (cols - 1) >= n then set cols to cols - 1
    set rows to (n + cols - 1) div cols
  end if

  set cellW to sw div cols
  set cellH to usableH div rows

  repeat with idx from 1 to n
    set w to item idx of wins
    set i to idx - 1
    set col to i mod cols
    set rowIdx to i div cols
    set x1 to col * cellW
    set y1 to menuBar + rowIdx * cellH

    if col = cols - 1 then
      set x2 to sw
    else
      set x2 to x1 + cellW
    end if
    if rowIdx = rows - 1 then
      set y2 to sh
    else
      set y2 to y1 + cellH
    end if

    set bounds of w to {x1, y1, x2, y2}
  end repeat
end tell
EOF
