class jenkinsci::common::install {
  class { 'common::ubuntu::puppet': }
  contain 'common::ubuntu::puppet'

  package { $jenkinsci::params::jenkinsInstallPkgs: ensure => installed }
}

class jenkinsci::common::users {
  $autoUser = $jenkinsci::params::autoUser
  $devUser = $jenkinsci::params::devUser

  users { $autoUser:
    usersname   => $autoUser,
    usersgroups => [$jenkinsci::params::devAdminGroup]
  }

  users { $devUser:
    usersname   => $devUser,
    usersgroups => [$jenkinsci::params::devAdminGroup],
    sudoer      => true,
  }

}
