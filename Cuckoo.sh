
Checking_system_status()
{
	#check if the system is running automatic updates and thus apt is busy
	#https://itsfoss.com/could-not-get-lock-error/
	#ps aux | grep -i apt
	echo hello
}

#requirements
installing()
{
	echo installing packages
	sudo apt-get install python2.7 python2.7-dev libffi-dev libssl-dev -y
	sudo apt-get install libjpeg-dev zlib1g-dev swig -y
	
	#TODO: avaliable in ubuntu 18.04 but not in ubuntu 20.04
	sudo apt-get install python-virtualenv python-setuptools -y

	#needed in ubuntu 20.04
	#TODO: review
	sudo apt install curl -y
	
	if [Check_pip]; then
		echo Pip is all ready installed
	else
		echo installing pip
		#wget https://bootstrap.pypa.io/get-pip.py -o get-pip.py
		wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate
		#TODO: add check for 404 error
		sudo python2 get-pip.py
		#sudo rm get-pip.py
	fi

	#installing Databases
	echo installing databases
	sudo apt-get install mongodb -y
	sudo apt-get install postgresql libpq-dev -y

	#TODO: install pydeep option
	#mkdir pydeep
	#cd pydeep
	#sudo apt install ssdeep
	#wget https://github.com/kbandla/pydeep/archive/master.zip
	#unzip master.zip
	#python setup.py build
	#python setup.py test
	#sudo python setup.py install
		#		-libfuzy-dev
	#TODO: check if fuzzy is actually requrired
	#sudo apt install libfussy-dev
	#cd ..
	
	#TODO: install mitm for SSL/TLS. requires python venv to be configured as it uses python 3.6
	
	#installing virtualbox
	echo installing virtualbox
	#following code does not work in ubuntu 18.04 {
	#echo deb http://download.virtualbox.org/virtualbox/debian xenial contrib | sudo tee -a /etc/apt/sources.list.d/virtualbox.list
	#wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
	#sudo apt-get update
	#sudo apt-get install virtualbox-5.2
	#}
	sudo apt-get install virtualbox=5.2.*
	
	
	#installing tcpdump
	echo installing tcpdump
	sudo apt-get install tcpdump apparmor-utils -y
	#sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump
	sudo aa-disable /usr/sbin/tcpdump
	
	#installing pcap
	sudo groupadd pcap
	sudo usermod -a -G pcap cuckoo
	sudo chgrp pcap /usr/sbin/tcpdump
	sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

	getcap /usr/sbin/tcpdump

	sudo apt-get install libcap2-bin -y
	sudo chmod +s /usr/sbin/tcpdump

	#TODO: Install volatility
	
	#installing m2crypto
	echo installing m2crypto
	sudo apt-get install libssl1.0-dev -y #https://github.com/appknox/m2crypto/issues/1
	sudo pip install m2crypto==0.24.0

	#installing guacamole and tomcat9
	echo guacd
	#next line does not work
	#sudo apt install libguac-client-rdp0 libguac-client-vnc0 libguac-client-ssh0 guacd

	#following instructions from https://www.howtoforge.com/how-to-install-and-configure-guacamole-on-ubuntu-2004/

	sudo apt install make gcc g++ libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin libossp-uuid-dev libavcodec-dev libavutil-dev libswscale-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev libssl-dev libvorbis-dev libwebp-dev -y
	sudo apt install tomcat9 tomcat9-admin tomcat9-common tomcat9-user -y
	sudo systemctl start tomcat9
	sudo systemctl enable tomcat9
	#systemctl status tomcat9
	#installing guacaomole
	wget https://downloads.apache.org/guacamole/1.1.0/source/guacamole-server-1.1.0.tar.gz --no-check-certificate #server
	tar -xvzf guacamole-server-1.1.0.tar.gz
	cd guacamole-server-1.1.0
	./configure --with-init-dir=/etc/init.d
	#TODO: code couldnt find libpulse for VNC and libwebsockets for kubernetes
	#		according to the instructions that is ok
	make
	sudo make install
	sudo ldconfig
	sudo systemctl enable guacd
	sudo systemctl start guacd
	#systemctl status guacd
	wget https://mirrors.estointernet.in/apache/guacamole/1.1.0/binary/guacamole-1.1.0.war --no-check-certificate#client
	sudo mkdir /etc/guacamole
	sudo mv guacamole-1.1.0.war /etc/guacamole/guacamole.war
	sudo ln -s /etc/guacamole/guacamole.war /var/lib/tomcat9/webapps/
	sudo systemctl restart tomcat9
	sudo systemctl restart guacd

	#TODO configure guacd
	if ! grep -q "guacd-hostname: localhost" /etc/guacamole/guacamole.properties; then
		sudo echo "guacd-hostname: localhost" | sudo tee -a /etc/guacamole/guacamole.properties
		sudo echo "guacd-port:    4822" | sudo tee -a /etc/guacamole/guacamole.properties
		sudo echo "user-mapping:    /etc/guacamole/user-mapping.xml" | sudo tee -a /etc/guacamole/guacamole.properties
	fi

	sudo mkdir /etc/guacamole/{extensions,lib}
	
	if ! grep -q "GUACAMOLE_HOME=/etc/guacamole" /etc/default/tomcat9; then
		echo "GUACAMOLE_HOME=/etc/guacamole" | sudo tee -a /etc/default/tomcat9
		code=$(echo -n yoursecurepassword | openssl md5)
		code=${code//'(stdin)= '/}
	fi

	#nano /etc/guacamole/user-mapping.xml
	mkdir /etc/guacamole/
	touch /etc/guacamole/user-mapping.xml
	
	if ! grep -q "GUACAMOLE_HOME=/etc/guacamole" /etc/guacamole/user-mapping.xml; then
		sudo echo "<user-mapping>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "    <authorize " | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "            username=\"admin\"" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "            password=\"$code\"" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "            encoding=\"md5\">" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "        <connection name=\"Ubuntu20.04-Server\">" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "            <protocol>ssh</protocol>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "            <param name=\"hostname\">192.168.56.102</param>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "            <param name=\"port\">22</param>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "            <param name=\"username\">root</param>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "        </connection>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "        <connection name="Windows Server">" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "            <protocol>rdp</protocol>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "            <param name=\"hostname\">192.168.56.100</param>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "            <param name=\"port\">3389</param>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "        </connection>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "    </authorize>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo echo "</user-mapping>" | sudo tee -a /etc/guacamole/user-mapping.xml
		sudo systemctl restart tomcat9
		sudo systemctl restart guacd
	fi
	
	#sudo apt -y install libcairo2-dev libjpeg-turbo8-dev libpng-dev libossp-uuid-dev libfreerdp-dev
	#mkdir /tmp/guac-build && cd /tmp/guac-build
	#wget https://www.apache.org/dist/guacamole/0.9.14/source/guacamole-server-0.9.14.tar.gz
	#tar xvf guacamole-server-0.9.14.tar.gz && cd guacamole-server-0.9.14
	#./configure --with-init-dir=/etc/init.d
	#make && sudo make install && cd ..
	#sudo ldconfig
	#sudo /etc/init.d/guacd start
	cd ~
	sudo rm guacamole-server-1.1.0.tar.gz
	sudo rm -r guacamole-server-1.1.0

	#installing cuckoo
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
	
	#installing vagrant
	sudo apt-get install vagrant -y
	wget -c https://releases.hashicorp.com/vagrant/2.0.3/vagrant_2.0.3_x86_64.deb
    sudo dpkg -i vagrant_2.0.3_x86_64.deb
	
	#vagrant plugin install vagrant-windows
	
	sudo apt-get install mongodb -y
	
	sudo apt-get install vagrant -y
}
Checking(){
	echo checking packages
	list=("python2.7" "python2.7-dev" "libffi-dev" 
	"libssl-dev" "libjpeg-dev" "zlib1g-dev" "swig" "curl" "mongodb" "postgresql"
	"libpq-dev" "tcpdump" "apparmor-utils" "libcap2-bin"
	"gcc" "g++" "libcairo2-dev" "libjpeg-turbo8-dev" "libpng-dev"
	"libtool-bin" "libossp-uuid-dev" "libavcodec-dev" "libavutil-dev"
	"libswscale-dev" "freerdp2-dev" "libpango1.0-dev" "libssh2-1-dev"
	"libvncserver-dev" "libtelnet-dev" "libssl-dev" "libvorbis-dev"
	"libwebp-dev" "tomcat9" "tomcat9-admin" "tomcat9-common" 
	"tomcat9-user" "libcairo2-dev" "libjpeg-turbo8-dev" "libpng-dev" 
	"libossp-uuid-dev" "libfreerdp-dev" "mongodb" "vagrant"
	)
	
	#
	for val in ${list[*]}; do
			s1="$(dpkg -s $val 2>/dev/null | grep 'install ok installed')"
			if [ "$s1" = "Status: install ok installed" ]; then
					echo -e "$val \033[0;32minstalled\033[0m"
			else
					echo -e "$val \033[0;31mnot installed\033[0m"
			fi
	done
	
	#checking for pip
	echo checking pip
	s1="$(pip --version 2>/dev/null | grep 'python 2.7')"
	if [[ "$s1" == "pip"*"from /usr/local/lib/python2.7/dist-packages/pip (python 2.7)" ]]; then #spaces next to variables matter
			echo -e "pip \033[0;32minstalled\033[0m"
	else
		echo -e "pip \033[0;31mnot installed\033[0m"
	fi
	
	#checking pip installed packages
	echo checking pip installations
	list=("virtualenv" "setuptools" "M2Crypto")
	for val in ${list[*]}; do
			s1="$(pip list 2>/dev/null | grep $val)"
			if [[ "$s1" == "$val"* ]]; then
					echo -e "$val \033[0;32minstalled\033[0m"
			else
					echo -e "$val \033[0;31mnot installed\033[0m"
			fi
	done
	
	#checking virtualbox version
	echo checking virtualbox
	s1="$(dpkg -s virtualbox 2>/dev/null | grep 'Version')"
	if [[ "$s1" == *"5.2."* ]]; then #spaces next to variables matter
			echo -e "virtualbox $s1 \033[0;32minstalled\033[0m"
	else
		echo -e "virtualbox \033[0;31mnot installed\033[0m"
	fi
	
	#checking if guacd is running
	s1="$(systemctl status guacd.service 2>/dev/null | grep 'Active: active (running)')"
	if [[ "$s1" == *"active (running)"* ]]; then #spaces next to variables matter
			echo -e "guacamole \033[0;32mactive (running)\033[0m"
	else
		echo -e "guacamole \033[0;31minactive\033[0m"
	fi
}
Check_pip{
	s1="$(pip --version 2>/dev/null | grep 'python 2.7')"
	if [[ "$s1" == "pip"*"from /usr/local/lib/python2.7/dist-packages/pip (python 2.7)" ]]; then #spaces next to variables matter
		return 1
	else
		return 0
	fi
}

installing
Checking