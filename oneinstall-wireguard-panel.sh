#!/usr/bin/env bash
### Author:wolian
### Date:2022/11/17
### E-mail:www@wolian.net
ufw disable && apt update -y 
apt install git gunicorn python3-pip  -y
curl -O https://raw.githubusercontent.com/Nyr/wireguard-install/master/wireguard-install.sh
chmod +x wireguard-install.sh
./wireguard-install.sh
git clone -b v3.0.6 https://github.com/donaldzou/WGDashboard.git wgdashboard
cd wgdashboard/src
chmod u+x wgd.sh
./wgd.sh install
chmod -R 755 /etc/wireguard
cat > /etc/systemd/system/wg-dashboard.service << EOF
[Unit]
After=netword.service

[Service]
WorkingDirectory=/root/wgdashboard/src
ExecStart=/usr/bin/python3 /root/wgdashboard/src/dashboard.py
Restart=always

[Install]
WantedBy=default.target
EOF
chmod 664 /etc/systemd/system/wg-dashboard.service
systemctl daemon-reload
systemctl enable wg-dashboard.service
systemctl start wg-dashboard.service
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p
exit 0
