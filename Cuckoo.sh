
#requirements

echo installing packages
sudo apt-get install python python-pip python-dev libffi-dev libssl-dev
sudo apt-get install python-virtualenv python-setuptools
sudo apt-get install libjpeg-dev zlib1g-dev swig

echo installing databases
sudo apt-get install mongodb
sudo apt-get install postgresql libpq-dev

#TODO: install pydeep option
#		-libfuzy-dev

#TODO: install mitm for SSL/TLS

echo installing virtualbox
echo deb http://download.virtualbox.org/virtualbox/debian xenial contrib | sudo tee -a /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox-5.2

echo installing tcpdump
sudo apt-get install tcpdump apparmor-utils
sudo aa-disable /usr/sbin/tcpdump

sudo groupadd pcap
sudo usermod -a -G pcap cuckoo
sudo chgrp pcap /usr/sbin/tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

getcap /usr/sbin/tcpdump
#TODO run checks

sudo apt-get install libcap2-bin
sudo chmod +s /usr/sbin/tcpdump

#TODO: Install volatility

echo m2crypto
sudo apt-get install swig
sudo pip install m2crypto==0.24.0

echo guacd
sudo apt install libguac-client-rdp0 libguac-client-vnc0 libguac-client-ssh0 guacd

sudo apt -y install libcairo2-dev libjpeg-turbo8-dev libpng-dev libossp-uuid-dev libfreerdp-dev
mkdir /tmp/guac-build && cd /tmp/guac-build
wget https://www.apache.org/dist/guacamole/0.9.14/source/guacamole-server-0.9.14.tar.gz
tar xvf guacamole-server-0.9.14.tar.gz && cd guacamole-server-0.9.14
./configure --with-init-dir=/etc/init.d
make && sudo make install && cd ..
sudo ldconfig
sudo /etc/init.d/guacd start


echo installing cuckoo
sudo adduser cuckoo
sudo usermod -a -G vboxusers cuckoo
sudo usermod -a -G libvirtd cuckoo

#TODO: install cuckoo into a venv

sudo pip install -U pip setuptools
sudo pip install -U cuckoo

#TODO: dont know if i need this next bit
#pip download cuckoo
#pip install Cuckoo-2.0.0.tar.gz
#pip install *.tar.gz

echo running cuckoo for first time

cuckoo -d
