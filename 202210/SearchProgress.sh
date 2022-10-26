#Search the progress which is using high cpu or memory

#!/bin/#!/usr/bin/env bash
echo "    Top ten CPU Usage    "
ps -eo user,pid,pcpu,pmem,args --sort=-pcpu   | head -n 10

echo "    Top ten Memory Usage    "
ps -eo user,pid,pcpu,pmem,args --sort=-pmem   | head -n 10
