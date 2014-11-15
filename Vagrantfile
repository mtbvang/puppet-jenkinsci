# -*- mode: ruby -*-
# vi: set ft=ruby :
#
VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'docker'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  DOCKER_IMAGE_REPO = "mtbvang"
  DOCKER_IMAGE_NAME = "ubuntu-vagrant"
  DOCKER_IMAGE_TAG = "14.04"

  DOCKER_SYNC_FOLDER_HOST = "/home/dev/code"
  DOCKER_SYNC_FOLDERL_GUEST = "/vagrant_data"
  DOCKER_CMD = ["/usr/sbin/sshd", "-D", "-e"]

  # Create symlinks to access graph files
  config.vm.provision "shell", inline: "mkdir -p /var/lib/puppet/state/graphs && ln -sf /vagrant /var/lib/puppet/state/graphs"

  # Boostrap docker containers with shell provisioner.
  config.vm.provision "shell" do |s|
    s.path = "bootstrap.sh"
    s.args = "3.6.2-1"
  end

  config.vm.define "git" do |r|
    r.vm.hostname = "git.dev.local"

    r.vm.provider "docker" do |d|
      d.cmd     = DOCKER_CMD
      d.image   = "#{DOCKER_IMAGE_REPO}/#{DOCKER_IMAGE_NAME}:#{DOCKER_IMAGE_TAG}"
      d.has_ssh = true
      d.privileged = true
      d.name = "git"
    end
  end

  config.vm.define "nexus" do |n|
    n.vm.hostname = "nexus.dev.local"

    n.vm.provider "docker" do |d|
      d.cmd     = DOCKER_CMD
      d.image   = "#{DOCKER_IMAGE_REPO}/#{DOCKER_IMAGE_NAME}:#{DOCKER_IMAGE_TAG}"
      d.has_ssh = true
      d.privileged = true
      d.name = "nexus"
    end
  end

  config.vm.define "jenkins" do |j|
    j.vm.hostname = "jenkins.dev.local"

    j.vm.provider "docker" do |d|
      d.cmd     = DOCKER_CMD
      d.image   = "#{DOCKER_IMAGE_REPO}/#{DOCKER_IMAGE_NAME}:#{DOCKER_IMAGE_TAG}"
      d.has_ssh = true
      d.privileged = true
      d.name = "jenkins"
      d.link "git:git"
      d.link "nexus:nexus"
    end
  end

  config.vm.define "slave1" do |s|
    s.vm.hostname = "slave1.dev.local"

    s.vm.provider "docker" do |d|
      d.cmd     = DOCKER_CMD
      d.image   = "#{DOCKER_IMAGE_REPO}/#{DOCKER_IMAGE_NAME}:#{DOCKER_IMAGE_TAG}"
      d.has_ssh = true
      d.privileged = true
      d.name = "slave1"
    end
  end
end
