sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y ffmpeg libmariadb3 libpq5 libmicrohttpd12
sudo wget https://github.com/Motion-Project/motion/releases/download/release-4.2.2/pi_buster_motion_4.2.2-1_armhf.deb
sudo dpkg -i pi_buster_motion_4.2.2-1_armhf.deb
sudo apt-get install -y python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev
sudo pip install motioneye
sudo mkdir -p /etc/motioneye
sudo cp /usr/local/share/motioneye/extra/motioneye.conf.sample  /etc/motioneye/motioneye.conf
sudo mkdir -p /var/lib/motioneye
sudo cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
sudo systemctl daemon-reload
sudo systemctl enable motioneye
sudo systemctl start motioneye
sudo pip install motioneye --upgrade
sudo systemctl restart motioneye
hostname -I
