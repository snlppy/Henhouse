Vagrant.configure("2") do |config|
  config.vm.box_download_insecure = true
  config.vm.box = "boomboxes/sandbox"
  config.vm.box_check_update = false

  config.vm.boot_timeout = 600
  config.winrm.transport = :plaintext
  config.vm.communicator = "winrm"
  config.winrm.basic_auth_only = true
  config.winrm.timeout = 300
  config.winrm.retry_limit = 20

  #disable windows defender
  config.vm.provision "shell", inline: 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /f /d 1', privileged: true
  #disable windows firewall
  config.vm.provision "shell", inline: 'Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False', powershell_args: "PowerShell", privileged: true
  #disable windows update
  config.vm.provision "shell", inline: 'sc.exe config wuauserv start=disabled', privileged: true
  #stop windows firewall service
  config.vm.provision "shell", inline: 'sc.exe stop wuauserv', privileged: true
  #config.vm.provision "shell", inline: '', privileged: true
  #fix network
  config.vm.provision "shell", inline: 'Remove-NetIPAddress 192.168.30.100 -Confirm:$false', powershell_args: "PowerSVagrant.configure("2") do |config|
  config.vm.box_download_insecure = true
  config.vm.box = "boomboxes/sandbox"
  config.vm.box_check_update = false

  config.vm.boot_timeout = 600
  config.winrm.transport = :plaintext
  config.vm.communicator = "winrm"
  config.winrm.basic_auth_only = true
  config.winrm.timeout = 300
  config.winrm.retry_limit = 20

  #disable windows defender
  config.vm.provision "shell", inline: 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /f /d 1', privileged: true
  #disable windows firewall
  config.vm.provision "shell", inline: 'Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False', powershell_args: "PowerShell", privileged: true
  #disable windows update
  config.vm.provision "shell", inline: 'sc.exe config wuauserv start=disabled', privileged: true
  #stop windows firewall service
  config.vm.provision "shell", inline: 'sc.exe stop wuauserv', privileged: true
  #config.vm.provision "shell", inline: '', privileged: true
  #fix network
  config.vm.provision "shell", inline: 'Remove-NetIPAddress 192.168.30.100 -Confirm:$false', powershell_args: "PowerShell", privileged: true
  config.vm.provision "shell", inline: "New-NetIPAddress -InterfaceAlias 'Ethernet 2' -IPAddress '192.168.30.100' -PrefixLength 24 -DefaultGateway '192.168.30.1'", privileged: true
  config.vm.provision "shell", inline: "Set-DnsClientServerAddress -InterfaceAlias 'Ethernet 2' -ServerAddresses 192.168.30.1", privileged: true

  config.vm.provision "file", source: "~/.cuckoo/agent/agent.py", destination:"C:\\Users\\vagrant\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\"
  config.vm.provision "file", source: "python/python-2.7.13.msi", destination:"C:\\Users\\vagrant\\Desktop\\"
  config.vm.provision "shell", path: "python/python-2.7.13.msi", privileged: true #todo:check if it needs to be privilaged
  
  config.vm.provider "virtualbox" do |vb|
	vb.name = "cuckoo1"
	#https://superuser.com/questions/846964/how-to-add-a-host-only-adapter-to-a-virtualbox-mac$
	config.vm.network "private_network", :type => 'dhcp', :name => 'vboxnet0', :adapter => 2
	vb.cpus = 2
	vb.memory = 2048
	vb.gui = true
	vb.customize ["modifyvm", :id, "--vram", "32"]
  end
endhell", privileged: true
  config.vm.provision "shell", inline: "New-NetIPAddress -InterfaceAlias 'Ethernet 2' -IPAddress '192.168.30.100' -PrefixLength 24 -DefaultGateway '192.168.30.1'", privileged: true
  config.vm.provision "shell", inline: "Set-DnsClientServerAddress -InterfaceAlias 'Ethernet 2' -ServerAddresses 192.168.30.1", privileged: true
  
  config.vm.provision "shell", path: "python/python-2.7.13.msi", privileged: true #todo:check if it needs to be privilaged
  config.vm.provision "file", source: "~/.cuckoo/agent/agent.py", destination:"C:\\Users\\vagrant\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\"
  #install pip
  config.vm.provision "shell", path: "", privilaged: true
  #install pillow
  config.vm.provision "shell", inline: "", privilaged: true
  
  config.vm.provider "virtualbox" do |vb|
      vb.name = "cuckoo1"
	  #https://superuser.com/questions/846964/how-to-add-a-host-only-adapter-to-a-virtualbox-mac$
      config.vm.network "private_network", :type => 'dhcp', :name => 'vboxnet0', :adapter => 2
	  vb.cpus = 2
	  vb.memory = 2048
	  vb.gui = true
	  vb.customize ["modifyvm", :id, "--vram", "32"]
  end
end
