# ovpn-client

### Контейнер содержит openvpn-client, http_proxy сервер, socks5, sshd 
### Добавлен python3 для подключения через sshuttle 
```
https://github.com/sshuttle/sshuttle
```
### Сборка
#### DOCKER
```shell
./build.sh
```
##### For info:
  docker build  --platform linux/arm64 --network host -t registry.home.local/openvpn-client:v0.0.1-arm64 build <br>
  docker build  --platform linux/amd64 --network host -t registry.home.local/openvpn-client:v0.0.1-amd64 build <br>
  docker manifest create registry.home.local/openvpn-client:v0.0.1 --amend registry.home.local/openvpn-client:v0.0.1-arm64  --amend registry. home.local/openvpn-client:v0.0.1-amd64 <br>
#### PODMAN
```shell
podman-remote build --log-level debug --platform linux/arm64 --platform linux/amd64 --manifest registry.home.local/openvpn-client:v0.0.1 .
```
### Настройка параметров
Скопировать файл конфигурации config.ovpn в каталог ovpn.<br> 
Для авторизации по паролю в каталоге ovpn создать файл credentials.txt
```shell
echo "username" > ovpn/credentials.txt
echo "password" >> ovpn/credentials.txt
```
Отредактировать файл конфигурации config.ovpn, изменить строку auth-user-pass
```text
auth-user-pass credentials.txt
```
### Запуск
```shell
docker-compose up -d
```

### docker-compose.yml
```yaml
services:
  vpn:
    image: openvpn-client
    container_name: openvpn-client
    cap_add:
    - NET_ADMIN
    devices:
    - /dev/net/tun:/dev/net/tun
    environment:
     #- SUBNETS=192.168.10.0/24
      - HTTP_PROXY=on
      - SOCKS_PROXY=on
      - KILL_SWITCH=nftable
      - SSHD=on
      - SSH_PASSWORD=password #<--ssh password  
    # - PROXY_USERNAME_SECRET=username # <-- If used, these must match the name of a
    # - PROXY_PASSWORD_SECRET=password # <-- secret (NOT the file used by the secret)
    volumes:
      - ./ovpn:/data/vpn
      - ~/.ssh:/home/ovpn/.ssh
      
    ports:
    - "1080:1080" # <--SOCKS5
    - "8088:8080" # <--HTTP_PROXY
    - "2222:22"   # <--SSH

```
### Подключение по ssh
```shell
ssh ovpn@<hostname> -p 2222
```
### ssh config
```text
Host barrier  
  HostName <hostname>
  port 2222
  user ovpn
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  LogLevel ERROR
  
Host gitlab.home.local
  IdentitiesOnly yes
  ProxyJump barrier
  Port 2022

Host *.home.local
  IdentitiesOnly yes
  ProxyJump barrier
```
