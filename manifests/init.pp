# == Class: jenkinsci
#
# Full description of class jenkinsci here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'jenkinsci':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class jenkinsci::master inherits params {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/", "/usr/local/bin"] }

  $updatePkgManager = $jenkinsci::params::updatePkgManager

  exec { "updatePackageManager":
    command => $updatePkgManager,
    timeout => 600
  }

  case $::osfamily {
    'Debian' : {
      case $::lsbdistcodename {
        'trusty' : {
          class { 'jenkinsci::ubuntu::trusty::master': require => [Exec["updatePackageManager"],] }
        }
        default  : {
          fail("Unsupported Debian distribution: ${::lsbdistcodename}")
        }
      }
    }
    default  : {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }
}

class jenkinsci::slave inherits params {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/", "/usr/local/bin"] }

  $updatePkgManager = $jenkinsci::params::updatePkgManager

  exec { "updatePackageManager":
    command => $updatePkgManager,
    timeout => 600
  }

  case $::osfamily {
    'Debian' : {
      case $::lsbdistcodename {
        'trusty' : {
          class { 'jenkinsci::ubuntu::trusty::slave': require => [Exec["updatePackageManager"],] }
        }
        default  : {
          fail("Unsupported Debian distribution: ${::lsbdistcodename}")
        }
      }
    }
    default  : {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }
}