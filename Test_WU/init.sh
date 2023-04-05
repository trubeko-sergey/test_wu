#! /bin/bash
## Install 
ufw allow  22
ufw allow 80
ufw allow 443
ufw enable
adduser dev
ysermod -aG sudo dev
echo 'dev ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/dev