class jenkinsci::params {
  $masterUrl = 'http://jenkins:8080'
  $jenkinsInstallDir = '/var/lib/jenkins'
  $jenkinsUser = 'jenkins'
  $jenkinsHome = "/home/${jenkinsUser}"
  $jenkinsSshDir = "${jenkinsHome}/.ssh"

  $autoUser = 'ci'
  $autoHome = "/home/${autoUser}"
  $autoSshDir = "${autoHome}/.ssh"

  case $::osfamily {
    'Debian' : {
      $jenkinsInstallPkgs = ['htop', 'git', 'curl', 'sysstat', 'iotop', 'rpm']

      case $::lsbdistcodename {
        'trusty' : {
          $updatePkgManager = 'apt-get update'
          $puppetPackageName = "puppetlabs-release-precise.deb"
          $puppetVersion = '3.7.3-1puppetlabs1'
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
