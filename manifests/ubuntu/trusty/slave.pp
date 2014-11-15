# Attaches a slave node to the master. Look at https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin
# for the parameter descriptions.
class jenkinsci::ubuntu::trusty::slave (
  $masterurl                = $jenkinsci::params::masterUrl,
  $ui_user                  = undef,
  $ui_pass                  = undef,
  $version                  = '1.16',
  $executors                = 2,
  $manage_slave_user        = false,
  $slave_user               = $jenkinsci::params::jenkinsUser,
  $slave_uid                = undef,
  $slave_home               = $jenkinsci::params::jenkinsHome,
  $slave_mode               = 'normal',
  $disable_ssl_verification = false,
  $labels                   = undef,
  $install_java             = false,
  $enable                   = true) {

  class { 'jenkinsci::slave::users': stage => pre }

  class { 'jenkinsci::slave::install': } ->
  class { 'jenkinsci::slave::config': }

}

class jenkinsci::slave::install {
  class { 'jenkinsci::common::install': } ->
  class { 'jenkinsci::slave::install::packages': }

  class { '::jenkins::slave':
    masterurl                => $::jenkinsci::slave::masterurl,
    ui_user                  => $::jenkinsci::slave::ui_user,
    ui_pass                  => $::jenkinsci::slave::ui_pass,
    version                  => $::jenkinsci::slave::version,
    executors                => $::jenkinsci::slave::executors,
    manage_slave_user        => $::jenkinsci::slave::manage_slave_user,
    slave_user               => $::jenkinsci::slave::slave_user,
    slave_uid                => $::jenkinsci::slave::slave_uid,
    slave_home               => $::jenkinsci::slave::slave_home,
    slave_mode               => $::jenkinsci::slave::slave_mode,
    disable_ssl_verification => $::jenkinsci::slave::disable_ssl_verification,
    labels                   => $::jenkinsci::slave::labels,
    install_java             => $::jenkinsci::slave::install_java,
    enable                   => $::jenkinsci::slave::enable
  }

  contain 'jenkinsci::common::install'
  contain 'jenkinsci::slave::install::packages'
  contain 'jenkins::slave'
}

class jenkinsci::slave::users {
  $jenkinsUser = $jenkinsci::params::jenkinsUser

  users { $jenkinsUser:
    usersname   => $jenkinsUser,
    usersgroups => [$jenkinsci::params::devAdminGroup]
  }

  class { 'jenkinsci::common::users':
  }
  contain 'jenkinsci::common::users'

}

class jenkinsci::slave::install::packages {
  class { common::ubuntu::vagrant:
    user     => 'root',
    userHome => '/root'
  }
  contain 'common::ubuntu::vagrant'

  package { 'virtualbox': ensure => 'latest' }

  common::librarianpuppet { 'slavelibrarianpuppet': userhome => $jenkinsci::params::jenkinsHome }

  class { 'common::ubuntu::installdocker':
    service_provider => 'base',
    docker_sudo_user => 'vagrant',
    service_enable   => true,
    service_state    => running,
    service_start    => 'service docker start',
    service_stop     => 'service docker stop',
    service_status   => 'service docker status',
    service_restart  => 'service docker restart',
  }
  contain 'common::ubuntu::installdocker'

}

class jenkinsci::slave::config {
  # Only create the jenkins slave startup scripts for the Docker containers because they use the phusion base image.
  if $::phusion_baseimage {
    file { "/etc/my_init.d/jenkins.sh":
      content => "service jenkins-slave start",
      mode    => '0744',
      owner   => 'root',
      group   => 'root',
    }
  }
}

