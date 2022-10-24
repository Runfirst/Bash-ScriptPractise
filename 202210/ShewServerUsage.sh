#!/bin/bash

function cpu(){

  util=$( vmstat | awk '{if(NR==3) print $13+$14 }' )
  iowait=$(vmstat | awk '{if(NR==3) print $16}')
  echo "CPU -usage: ${util}%, Waiting for the correspond usage of the disk I/O: ${iowait}:${iowait}%
}

function memory {

  total=`free -m | awk '{if(NR==2) printf "%.1f", $2/1024}'`
  used=`free -m | aws '{if(NR==2) printf "%.1f", ($2-$NF)/1024}'`
  available=`free -m | aws '{if(NR==2) print "%.1f", $NF/1024}'`
  echo "Memory: Size: ${total}G , Using: ${used}G , Free: ${available}G"
}

function disk(){
  fs=$(df -h | awk '/^\/dev/{print $1}')
    for p in $fs; do
      mounted=$(df -h | awk '$1=="'$p'" {print $NF}')
      size=$(df -h | awk '$1=="'$p'" {print $2}')
      used=$(df -h | awk '$1=="'$p'" {print $3}')
      used_precent=$(df -h | awk '$1=="'$p'" {print $5}')
      echo "Disk: Mount Place: $mounted , Size: $size , Using: $used , Usage: $used_precent"
    done
}

function tcp_status(){
  summary=$(ss -antp | awk '{status[$1]++}END{for(i in status) printf i":"status[i]" "}')
  echo "TCP Connecting Status: $summary"
}

cpu
memory
disk
tcp_status
