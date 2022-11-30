#!/bin/bash

useradd -s /bin/bash -d /home/autossh/ -m autossh

mkdir -p                                  /home/autossh/.ssh
cp -v ./rfs/home/autossh/.ssh/*           /home/autossh/.ssh
chown -R autossh:autossh                  /home/autossh/.ssh
chmod 755                                 /home/autossh/.ssh
chmod 600                                 /home/autossh/.ssh/id_ed25519
chmod 644                                 /home/autossh/.ssh/config
chmod 644                                 /home/autossh/.ssh/authorized_keys

cp -v ./rfs/home/autossh/autossh-watchdog /home/autossh/
chown autossh:autossh                     /home/autossh/autossh-watchdog
chmod a+x                                 /home/autossh/autossh-watchdog

cp -v ./rfs/etc/systemd/system/*          /etc/systemd/system/
chmod a+x                                 /etc/systemd/system/autossh.service
chmod a+x                                 /etc/systemd/system/autossh-watchdog.service

systemctl daemon-reload
systemctl start  autossh-watchdog.service
systemctl enable autossh-watchdog.service
systemctl start  autossh.service
systemctl enable autossh.service

exit 0

