
#requirements

echo installing packages
sudo apt-get install python2 python-pip python-dev libffi-dev libssl-dev -y
sudo apt-get install python-virtualenv python-setuptools
sudo apt-get install libjpeg-dev zlib1g-dev swig -y

#needed in ubuntu 20.04
sudo apt install curl -y
echo installing pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
#TODO: add check for 404 error
sudo python2 get-pip.py


echo installing databases
sudo apt-get install mongodb -y
sudo apt-get install postgresql libpq-dev -y

#TODO: install pydeep option
#		-libfuzy-dev

#TODO: install mitm for SSL/TLS

echo installing virtualbox
echo deb http://download.virtualbox.org/virtualbox/debian xenial contrib | sudo tee -a /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox-5.2

echo installing tcpdump
sudo apt-get install tcpdump apparmor-utils -y
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
#next line does not work
#sudo apt install libguac-client-rdp0 libguac-client-vnc0 libguac-client-ssh0 guacd

#following instructions from https://www.howtoforge.com/how-to-install-and-configure-guacamole-on-ubuntu-2004/

sudo apt install make gcc g++ libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin libossp-uuid-dev libavcodec-dev libavutil-dev libswscale-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev libssl-dev libvorbis-dev libwebp-dev -y
sudo apt install tomcat9 tomcat9-admin tomcat9-common tomcat9-user -y
sudo systemctl start tomcat9
systemctl enable tomcat9
#systemctl status tomcat9
#installing guacaomole
wget https://downloads.apache.org/guacamole/1.1.0/source/guacamole-server-1.1.0.tar.gz
tar -xvzf guacamole-server-1.1.0.tar.gz
cd guacamole-server-1.1.0
./configure --with-init-dir=/etc/init.d
#TODO: code dcouldnt find libpulse for VNC and libwebsockets for kubernetes
#		according to the instructions that is ok
make
sudo make install
sudo ldconfig
sudo systemctl enable guacd
sudo systemctl start guacd
#systemctl status guacd
wget https://mirrors.estointernet.in/apache/guacamole/1.1.0/binary/guacamole-1.1.0.war
sudo mkdir /etc/guacamole
sudo mv guacamole-1.1.0.war /etc/guacamole/guacamole.war
sudo ln -s /etc/guacamole/guacamole.war /var/lib/tomcat9/webapps/
sudo systemctl restart tomcat9
sudo systemctl restart guacd

#TODO configure guacd
sudo echo "guacd-hostname: localhost" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "guacd-port:    4822" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "user-mapping:    /etc/guacamole/user-mapping.xml" | sudo tee -a /etc/guacamole/guacamole.properties

sudo mkdir /etc/guacamole/{extensions,lib}
echo "GUACAMOLE_HOME=/etc/guacamole" | sudo tee -a /etc/default/tomcat9
code=(echo -n yoursecurepassword | openssl md5)
code=${code//'(stdin)= '/}

nano /etc/guacamole/user-mapping.xml

sudo echo "<user-mapping>" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "    <authorize " | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "            username=\"admin\"" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "            password=\"$code\"" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "            encoding=\"md5\">" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "        <connection name=\"Ubuntu20.04-Server\">" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "            <protocol>ssh</protocol>" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "            <param name=\"hostname\">192.168.10.50</param>" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "            <param name=\"port\">22</param>" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "            <param name=\"username\">root</param>" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "        </connection>" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "        <connection name="Windows Server">" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "            <protocol>rdp</protocol>" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "            <param name=\"hostname\">192.168.10.51</param>" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "            <param name=\"port\">3389</param>" | sudo tee -a /etc/guacamole/guacamole.properties
sudo echo "        </connection>
sudo echo "    </authorize>
sudo echo "</user-mapping>






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
