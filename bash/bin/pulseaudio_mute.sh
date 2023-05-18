#!/bin/bash
# Toggle the mute status of all pulse audio sinks

for i in $(pactl list sinks short | cut -f1)
do 
  pactl set-sink-mute $i toggle
done
