# installation

## debian bullseye netinstall iso with minimal install openssh server and system utilities only

## install additional packages

```
apt-get update
apt-get dist-upgrade
apt-get install sudo psmisc autossh vim net-tools netcat

wget -O /usr/local/bin/wstunnel https://github.com/erebe/wstunnel/releases/download/v4.1/wstunnel-x64-linux
chmod a+x /usr/local/bin/wstunnel
```
## create admin users and put them into sudo group

```
admin_user=""
useradd -s /bin/bash -d /home/$user/ -m ${admin_user}
usermod -a -G sudo ${admin_user}
vi /home/${admin_user}/.ssh/authorized_keys  # place pubkey from admin_user
```

## create autossh user, su into it, generate ed25519 key with no passphrase

```
client_box_name="ch01"
useradd -s /bin/bash -d /home/autossh/ -m autossh
passwd autossh
sudo -u autossh -i
cd
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "autossh@${client_box_name}"
# service key für autossh user
vi .ssh/authorized_keys  # place .pubkey from server:/home/clients.d/${client_box_name}/service-id_ed25519.pub
vi .ssh/config           # get pre-configured file from server:/home/clients.d/${client_box_name}/ssh_config
```

## TBD: create the .ssh/config

with the values from https://github.com/unimock/callhome-server-docker/tree/master/callhome-client and adjust it to your needs - username and http-pw in proxy-command section, assigned callhome-base-id i.e. 1NNxxx with your ID NN and the service ports xxx. Name the destination section to your callhome-server

 - /home/autossh/.ssh/config

## TBD: create a corresponding wstunnel customer-user

i.e. florida on callhome-server and put the pubkey from 6. into users home, adjust docker-compose with the basic-auth user i.e. florida and set a password for the http-auth i.e. wstunnelpwd, adjust the login of the user to nologin, restart the container

* try to invoke a manual autossh with i.e. autossh -f -M 0 -N florida@callhome-server

* check if the forwarded ports from 7 on callhome-server are open

* if everything works killall autossh

* create the systemd service from https://github.com/unimock/callhome-server-docker/tree/master/callhome-client and start it

## install and activate services 

```
#install autossh-watchdog script and service
vi /home/autossh/autossh-watchdog
chown autossh:autossh /home/autossh/autossh-watchdog
chmod a+x /home/autossh/autossh-watchdog
vi /etc/systemd/system/autossh-watchdog.service
systemctl daemon-reload
systemctl start autossh-watchdog.service
systemctl enable autossh-watchdog.service
# install autossh service
vi /etc/systemd/system/autossh.service
systemctl daemon-reload
systemctl start autossh.service
systemctl enable autossh.service
```

