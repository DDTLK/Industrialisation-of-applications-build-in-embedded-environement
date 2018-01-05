pipeline {
  agent any
  stages {
    stage('XDS-install') {
      agent {
        node {
          label 'opensuse'
        }
        
      }
      steps {
        echo 'install ........................'
        sh '''export DISTRO="openSUSE_Leap_42.3"
sudo zypper ar http://download.opensuse.org/repositories/isv:/LinuxAutomotive:/app-Development/${DISTRO}/isv:LinuxAutomotive:app-Development.repo
sudo zypper ref
sudo zypper install -y agl-xds-agent agl-xds-cli agl-xds-gdb agl-xds-server
systemctl --user enable xds-agent.service
systemctl --user start xds-agent.service
systemctl --user start xds-server.service
systemctl --user status xds-server.service | grep "(running)" || { echo "xds-server not running"; exit 1}
systemctl --user status xds-agent.service | grep "(running)" || { echo "xds-agent not running"; exit 1}'''
      }
    }
    stage('Next') {
      steps {
        echo 'next'
      }
    }
  }
}