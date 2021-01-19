Installing()
{
	#predownloads win7 box
	vagrant box add boomboxes/sandbox || echo box already exists
	
	#download the vagrant file
	cd ~/henhouse/Vagrant
	pwd
	if [-f Vagrantfile]; then
		wget https://raw.githubusercontent.com/snlppy/Henhouse/main/Vagrantfile
	fi
	
	#downlaod python 2.7 installer
	if [-f python/python=2.7*]; then
		wget https://www.python.org/ftp/python/2.7.13/python-2.7.13.msi
		mkdir pyhon
		mv python-2.7.13.msi python/
	fi
	
	#build win7 machine
	echo vagrant up
	vagrant up
	
	#creates a snapshot of the completed win7 machine
	echo vagrant snapshot
	vagrant snapshot save Snapshot1
	
	#https://stackoverflow.com/questions/16987648/update-var-in-ini-file-using-bash
	#edits config files
	sed -i '/^\[mongodb\]$/,/^\[/ s/^enabled = no/enabled = yes/' ~/.cuckoo/conf/reporting.conf #enabling the results server
	sed -i '/^\[resultserver\]$/,/^\[/ s/^ip = */ip = 127.0.0.1/' ~/.cuckoo/conf/cuckoo.conf #sets the results server to the loopback address
}
Installing