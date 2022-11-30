# port routing gateway

## description


## previews

* **service-user** vs. **service-admin-user**
In general there is no difference between **service-user** and **service-admin-user**.
The only exception is that the service-admin-user is allowed to create new users on the system and to modify their configuration files.

## **service-host** installation, configuration and create first **service-admin-user**

1. build docker image

```
git clone 
cd prg-docker
docker compose build
```

2. configure environment

```
cp .env-template .env
vi .env
cp docker compose.yml-template docker compose.yml
vi docker compose.yml
docker compose up -d
# test your swaks settings
EMAIL="your.mail@example.com"
SERVICE="ch01"
docker compose exec $SERVICE mail test $EMAIL
```

3. create a first **service-admin-user** (login=2)

```
SERVICE_ADMIN_USER="hugo"
vi service/users.conf # add service-admin-user. Example: "hugo ; 1001  ; service ; 1000  ;  2 ; service ;;"
docker compose down ; docker compose up -d
vi ./home/${SERVICE_ADMIN_USER}/.ssh/authorized_keys  # paste users pubkey
docker compose down ; docker compose up -d
docker compose logs -f
```

4. test **service-admin-user** access and get your service host declaration for your **service-user** and place it in your local .ssh/config

```
SERVICE_ADMIN_USER="hugo"
HOST="callhome.my.domain"
PORT="2222"
ssh -p ${PORT} ${SERVICE_ADMIN_USER}@${HOST}
  chs service # displays service host declaration sections for your local ./.ssh/config file
exit
```

5. create password protected keypair for initial autossh access to clients

```
KEY_NAME="john@example.com"
ssh-keygen -o -a 100 -t ed25519 -f ./home/clients.d/service-autossh-id -C "${KEY_NAME}"
```

## managing users, client boxs, ...

### add/remove/modify **service-user** or **service-admin-user**

```
ssh <service-admin-user>                    # login as service-admin-user
admin vi /service/users.conf                # add new user 
admin vi /home/<user>/.ssh/authorized_keys  # paste users pubkey
exit
```

### establish a new **client-box**

register a client, create configurations and send an installation package via email

```
ssh <service-admin-user>                    # login as service-admin-user
admin vi /service/users.conf
chs mail package <client-name> <service-user>|<mail-address>  # send client installation package 
```

## client-box installation

### via installation package, follow instructions in mail

### manual way

1. debian bullseye netinstall iso with minimal install openssh server and system utilities only

2. install additional packages

```
apt-get update
apt-get dist-upgrade
apt-get install sudo psmisc autossh vim net-tools netcat gpiod
chmod a+s /usr/bin/gpioset

wget -O /usr/local/bin/wstunnel https://github.com/erebe/wstunnel/releases/download/v4.1/wstunnel-x64-linux
chmod a+x /usr/local/bin/wstunnel
```

3. create admin user with sudo access

```
admin_user=""
useradd -s /bin/bash -d /home/$user/ -m ${admin_user}
usermod -a -G sudo ${admin_user}
vi /home/${admin_user}/.ssh/authorized_keys  # place pubkey from admin_user
```

4. install server prepared installation package

copy **client_install.tgz** package to the /tmp directory on **client-box**

```
mkdir /tmp/pkg
cd /tmp/pkg/
tar xzvf ../client_install.tgz
./install.sh
rm -r /tmp/pkg
```

5. tests

```
sudo -u autossh -i
cat .ssh/config
ssh autossh
sudo journalctl -u autossh.service
sudo systemctl status autossh.service
sudo systemctl restart autossh.service
```

## renew pre-defined initial client keypair

1. client-box

```
client_box_name="cl01"
sudo -u autossh -i
cd
rm ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "autossh@${client_box_name}"
cat ~/.ssh/id_ed25519.pub  # copy client-user pubkey for server activation
```

2. server

```
ssh <service-admin-user>                           # login as service-admin-user
admin vi /home/<client-user>/.ssh/authorized_keys  # paste users pubkey
exit
```

