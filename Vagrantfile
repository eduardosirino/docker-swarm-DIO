# -*- mode: ruby -*-
# vi: set ft=ruby :

machines = {
  "master" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04"},
  "node01" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04"},
  "node02" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04"},
  "node03" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04"}
}

ip_prefix = "192.168.56."

Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 600

  machines.each do |name, conf|
    config.vm.define "#{name}" do |machine|
      machine.vm.box = "#{conf["image"]}"
      machine.vm.hostname = "#{name}"
      machine.vm.network "private_network", ip: "#{ip_prefix}#{200 + machines.keys.index(name)}"
      machine.vm.provider "virtualbox" do |vb|
        vb.name = "#{name}"
        vb.memory = conf["memory"]
        vb.cpus = conf["cpu"]
        vb.linked_clone = true
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      machine.vm.provision "shell", path: "install-docker.sh"

      if name == "master"
        machine.vm.provision "shell", path: "master.sh"
      else
        machine.vm.provision "shell", path: "worker.sh"
      end

      if name == "node03"
        machine.trigger.after :up do |trigger|
          trigger.info = "Deploying web-app service with 15 replicas..."
          trigger.run = {inline: "vagrant ssh master -c 'bash /vagrant/deploy.sh'"}
        end
      end
    end
  end
end
