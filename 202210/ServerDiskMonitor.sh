#Multiple Servers Disk Monitoring
#!/bin/#!/usr/bin/env bash
HOST_INFO=host.info

for IP in $(awk '/^[^#]/{print $1}' $HOST_INFO); do
  #User ID and Port
  USER=$(awk -v ip=$IP 'ip==$1{print $2}' $HOST_INFO)
  PORT=$(awk -v ip=$IP 'ip==$1{print $3}' $HOST_INFO)

  #Create a temporary file to save info
  TMP_FILE=/tmp/disk.tmp

  #Use the public key to get the server disk info
  ssh -p $PORT $USER@$IP 'df -h' > $TMP_FILE

  #Analyze the disk usage
  USE_RATE_LIST=$(awk 'BEGIN{OFS="="}/^\/dev/{print $NF, int($5)}' $TMP_FILE)

  #Loop disk list, and determine
  for USE_RATE in $USE_RATE_LIST; do
    #Mount name
    PART_NAME=${USE_RATE%=*}
    #DISK usage
    USE_RATE=${USE_RATE%=*}

    #Determine whether an early warning is required.
    if [ $USE_RATE -ge 80 ]; then
      echo "Warning: $PART_NAME Partition usage $USE_RATE%!"
      echo "The disk usage in Server $IP is high, please deal with" | mail -s "The disk usage in Server $IP is high, please deal with" xxxx@gmail.com
    else
      echo "The disk usage in Server $IP is good."
    fi
  done
done
