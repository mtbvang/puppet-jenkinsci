import 'init.pp'
import 'params.pp'
import 'ubuntu/*.pp'

node 'jenkins.dev.local' {
  class { 'jenkinsci::master': }
}

node 'jenkins-slave1.dev.local' {
  class { 'jenkinsci::slave': labels => "docker" }

}

node 'jenkins-slave2.dev.intnet' {
  class { 'jenkinsci::slave': labels => "windows" }
}

node 'jenkins-slave3.dev.intnet' {
  class { 'jenkinsci::slave': labels => "virtualbox" }
}