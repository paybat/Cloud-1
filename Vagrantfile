Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "cloud1"
  config.vm.network "private_network", ip: "192.168.56.20"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "cloud1-practice"
    vb.memory = 2048
    vb.cpus = 2
  end
end
