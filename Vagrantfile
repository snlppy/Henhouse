Vagrant.configure("2") do |config|
  config.vm.box_download_insecure = true
  config.vm.box = "boomboxes/sandbox"
  config.vm.box_check_update = false

  config.vm.boot_timeout = 600
  cfg.winrm.transport = :plaintext
  cfg.vm.communicator = "winrm"
  config.winrm.basic_auth_only = true
  config.winrm.timeout = 300
  config.winrm.retry_limit = 20

  #config.vm.provision "file", source: "python/python27", destination:"/"
  config.vm.provision "file", source: "python/agent.py", destination:"C:\Users\vagrant\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
  config.vm.provision "shell", path: "python/python-2.7.13.msi", privileged: true #todo:check if it needs to be privilaged
  #cfg.vm.provision "shell", path: "python/agent.py", privileged: true #todo:check if it needs to be privilaged

  config.vm.provider "virtualbox" do |vb|
      vb.name = "cuckoo1"
	  #https://superuser.com/questions/846964/how-to-add-a-host-only-adapter-to-a-virtualbox-mac$
      config.vm.network "private_network", :type => 'dhcp', :name => 'vboxnet0', :adapter => 2
  end
end
