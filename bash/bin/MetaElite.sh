#!/usr/bin/env bash
set -x
elite_dangerous_id=359320
pfx="$(protontricks --command 'echo $WINEPREFIX' "$elite_dangerous_id" 2>/dev/null)"
cd "$pfx/drive_c/Program Files/raxxla.org/MetaElite" || exit
protontricks-launch --appid "$elite_dangerous_id" ./MetaElite*.exe

