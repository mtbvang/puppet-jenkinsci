#!/usr/bin/env bash

PUPPET_VERSION=$1

# Work around for upstart docker issues. https://github.com/docker/docker/issues/1024 that
# causes error: "initctl: Unable to connect to Upstart: Failed to connect to socket /com/ubuntu/upstart: Connection refused"
if [ ! -L  "/sbin/initctl" ]; then
	echo "/sbin/initctl not found! Linking to it /bin/true"
	dpkg-divert --local --rename --add /sbin/initctl
	ln -s /bin/true /sbin/initctl
fi

# Install Java 8
touch /etc/init.d/cgroup-lite
DEBIAN_FRONTEND=noninteractive apt-get install -y ssh software-properties-common cgroup-lite && apt-get clean && apt-get update
add-apt-repository -y ppa:webupd8team/java
apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get -y install oracle-java8-installer

# Install puppet
add-apt-repository multiverse
DEBIAN_FRONTEND=noninteractive apt-get install -y wget dialog
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update
apt-get install -y puppet-common=${PUPPET_VERSION}puppetlabs1 puppet=${PUPPET_VERSION}puppetlabs1
echo "sudo puppet apply --modulepath=/vagrant_data/modules /vagrant_data/manifests/site.pp " > /usr/local/bin/runpuppet
chmod 755 /usr/local/bin/runpuppet
echo "sudo puppet apply --modulepath=/vagrant_data/modules -e \"include '\$1'\"" > /usr/local/bin/runpuppetclass
chmod 755 /usr/local/bin/runpuppetclass
