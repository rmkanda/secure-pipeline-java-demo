pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: spring-build-ci
spec:
  containers:
  - name: maven
    image: maven:alpine
    command:
    - cat
    tty: true
    volumeMounts:
    - name: m2
      mountPath: /root/.m2/
  - name: trufflehog
    image: dxa4481/trufflehog
    command:
    - cat
    tty: true
  volumes:
  - name: m2
    hostPath:
      path: /tmp/.m2/
"""
    }
  }
  stages {
    stage('Checkout & Build') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/rmkanda/spring-app-sample.git']]])
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
                    container('trufflehog') {
                        sh 'ls -al'
                        sh 'trufflehog .'
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
                        sh 'mvn -version'
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
      }
    }
  }
}
