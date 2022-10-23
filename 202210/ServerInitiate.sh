#!/bin/bash

#Install the System Performance Analysis tool
yum install gcc make autoconf vim sysstat net-tools iostat iftop iotp wget lrzsz lsof unzip openssh-clients net-tool vim ntpdate -y

#Set the time zone and synchronize the time
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
if ! crontab -l | grep ntpdate &> /dev/null; then
  (echo "* 1 * * * ntpdate time.windows.com > /dev/null 2>&1"; crontab -l) | crontab
fi
