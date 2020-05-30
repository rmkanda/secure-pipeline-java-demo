pipeline {
  agent {
    kubernetes {
      yamlFile 'build-agent.yaml'
      defaultContainer 'maven'
      idleMinutes 1
    }
  }
  stages {
    stage('Setup') {
      parallel {
        stage('Install Dependencies') {
          steps {
            container('maven') {
              sh 'mvn install'
            }
          }
        }
        stage('Secrets scanner') {
          steps {
            container('trufflehog') {
              sh 'git clone https://github.com/rmkanda/spring-app-sample.git'
              sh 'cd spring-app-sample && ls -al'
              sh 'cd spring-app-sample && trufflehog .'
              sh 'rm -rf spring-app-sample'
            }
          }
        }
      }
    }
    stage('Static Analysis') {
      parallel {
        stage('OWASP Dependency Checker') {
          steps {
            container('maven') {
              sh 'mvn org.owasp:dependency-check-maven:check'
            }
          }
          post {
            always {
              echo "success"
            }
          }
        }
        stage('OWASP Spot Bugs') {
          steps {
            container('maven') {
              sh 'mvn compile spotbugs:check'
            }
          }
        }
      }
    }
    stage('Build') {
      steps {
        container('maven') {
          sh 'mvn package'
        }
        container('docker-cmds') {
          sh 'ls -al'
          sh 'docker build . -t sample-app'
        }
      }
    }
  }
}
