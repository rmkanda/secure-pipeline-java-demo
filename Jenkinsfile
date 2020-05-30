pipeline {
  agent {
    kubernetes {
      yamlFile 'build-agent.yaml'
      defaultContainer 'maven'
      idleMinutes 1
    }
  }
  stages {
    stage('Checkout & Build') {
      steps {
        container('maven') {
          sh 'ls -l'
          sh 'mvn install'
        }
      }
    }
    stage('Static Analysis') {
        parallel {
          stage('Secrets scanner') {
                steps {
                    container('maven') {
                        sh 'ls -al'
                    }
                }
            }
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
