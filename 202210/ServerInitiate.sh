#!/bin/bash

#Install the System Performance Analysis tool
yum install gcc make autoconf vim sysstat net-tools iostat iftop iotp wget lrzsz lsof unzip openssh-clients net-tool vim ntpdate -y

#Set the time zone and synchronize the time
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
if ! crontab -l | grep ntpdate &> /dev/null; then
  (echo "* 1 * * * ntpdate time.windows.com > /dev/null 2>&1"; crontab -l) | crontab
fi

#Disable SeLinum
sed -i '/SELINUX/{s/permissive/disabled/} /etc/selinux/config

# Turn off the firewall
if egrep "7.[0-9]" /etc/redhat-release &> /dev/null; then
  systemctl stop firewalld
  systemctl disabled firewalld
elif egrep "6.[0-9]" /etc/redhat-release &> /dev/null; then
  service iptables stop
  chkconfig iptables off
fi

#show the running time in history

if ! grep HISTTIMEFORMAT /etc/bashrc; then
  echo 'export HISTTIMEFORMAT="%Y-%M-%d %H:%M:%S  `whoami` "' >> /bashrc
fi

# SSH Timeout
if ! grep "TMOUT=600" /etc/profile &> /dev/null; then
  echo "export TMOUT=600" >> /etc/profile
fi

# Disable remote login as root
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

#Prevent corn tasks from sending email to root
sed -i 's/^MAILTO=root/MAILTO=""' /etc/crontab

#Set the maximum number of open files
if ! grep "* soft nofile 65535" /etc/security/limits.conf &> /dev/null; then
  cat >> /etc/security/limits.conf << EOF
  * soft nofile 65535
  * hard nofile 65535
  EOF
fi
