Installing()
{
	#predownloads win7 box
	vagrant box add boomboxes/sandbox || echo box already exists
	
	#download the vagrant file
	cd ~/henhouse/Vagrant
	if [ -f "Vagrantfile" ]; then
		echo vagrantfile exists
	else
		wget https://raw.githubusercontent.com/snlppy/Henhouse/main/Vagrantfile
	fi
	
	#downlaod python 2.7 installer
	if [ -f python/python-2.7* ]; then
		wget https://www.python.org/ftp/python/2.7.13/python-2.7.13.msi
		mkdir pyhon
		mv python-2.7.13.msi python/
	fi
	cd ..
	#TODO: check for hostonlyif
	#net1=$(vboxmanage list hostonlyifs)
	if grep -q "192.168.30.1"; then
		s1=$(vboxmanage list hostonlyifs | sed -n '/Name/,/192.168.30.1/p')
		net1=${s1:6:19}
		echo net1 already exists
	else
		s1=$(vboxmanage hostonlyif create)
		vboxmanage hostonlyif ipconfig ${s1:11:-26} --ip 192.168.30.1
		net1=${s1:11:-26}
		echo $net1 created
	fi
	
	
	
	#config.vm.network "private_network", :type => 'dhcp', :name => 'vboxnet0', :adapter => 2
	
	sed -i 's/^config.vm.network \"private_network\", :type => 'dhcp', :name => .*/config.vm.network "private_network", :type => 'dhcp', :name => '$net1', :adapter => 2/' vagrant/Vagrantfile #sets the results server to the loopback address
	
	
	
	#build win7 machine
	echo vagrant up
	vagrant up
	
	#VBoxManage modifyvm cuckoo1 --nic2 hostonly --hostonlyadapter2 $net1
	
	#creates a snapshot of the completed win7 machine
	echo vagrant snapshot
	vagrant snapshot save Snapshot1
	
	#https://stackoverflow.com/questions/16987648/update-var-in-ini-file-using-bash
	#edits config files
	sed -i '/^\[mongodb\]$/,/^\[/ s/^enabled = no/enabled = yes/' ~/.cuckoo/conf/reporting.conf #enabling the results server
	
	sed -i '/^\[resultserver\]$/,/^\[/ s/^ip = .*/ip = 127.0.0.1/' ~/.cuckoo/conf/cuckoo.conf #sets the results server to the loopback address
	sed -i '/^\[cuckoo1\]$/,/^\[/ s/^ip = .*/ip = 192.168.56.100/' ~/.cuckoo/conf/virtualbox.conf #sets the results server to the loopback address
}
Installing