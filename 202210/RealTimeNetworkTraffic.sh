#View the real-time network traffic
#!/bin/#!/usr/bin/env bash

eth0=$1
echo -e "Traffic In -- Traffic Out    "

while true; do
  old_in=$(cat /proc/net/dev | grep $eth0 | awk '{print $2}')
  old_out=$(cat /proc/net/dev | grep $eth0 | awk '{print $10}')
  sleep 1
  new_in=$(cat /proc/net/dev | grep $eth0 | awk '{print $2}')
  new_out=$(cat /proc/net/dev | grep $eth0 | awk '{print $10}')
  in=$(printf "%.1f%s" "$((($new_in-$old_in)/1024))" "KB/s")
  out=$(printf "$.1f%s" "$((($new_out-$old_out)/1024))" "KB/s")
  echo "$in $out"
done
