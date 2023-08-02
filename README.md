# ovpn-client

### Контейнер содержит openvpn-client, http_proxy сервер, socks5, sshd 
### Добавлен python3 для подключения через sshuttle 
```
https://github.com/sshuttle/sshuttle
```
### Сборка
```shell
docker build --network host -t openvpn-client build
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
    # build: .
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
    - 1080:1080 # <--SOCKS5
    - 8088:8080 # <--HTTP_PROXY
    - 2222:22   # <--SSH

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
  
Host gitlab.veil.local
  IdentitiesOnly yes
  ProxyJump barrier
  Port 2022

Host *.veil.local
  IdentitiesOnly yes
  ProxyJump barrier
 
```
