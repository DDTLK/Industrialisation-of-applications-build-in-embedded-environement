pipeline {
  agent {
    node {
      label 'xds'
    }
    
  }
  stages {
    stage('XDS-install') {
      steps {
        echo 'install ........................'
        sh 'xds-cli sdks ls'
        deleteDir()
      }
    }
    stage('Start') {
      steps {
        echo 'next'
        deleteDir()
      }
    }
  }
  post {
    always {
      deleteDir()
      
    }
    
  }
}