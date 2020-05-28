pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: maven
    image: maven:alpine
    command:
    - cat
    tty: true
  - name: busybox
    image: busybox
    command:
    - cat
    tty: true
  volumeMounts:
  - name: m2
    mountPath: /root/.m2/
volumes:
- name: m2
  hostPath:
    path: /root/.m2/
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
            stage('Test On Windows') {
                steps {
                    container('maven') {
                        sh 'mvn -version'
                    }
                    container('busybox') {
                        sh '/bin/busybox'
                    }
                }
                post {
                    always {
                        echo "success"
                    }
                }
            }
            stage('Test On Linux') {
                steps {
                    container('maven') {
                        sh 'mvn -version'
                    }
                    container('busybox') {
                        sh '/bin/busybox'
                    }
                }
                post {
                    always {
                        echo "success"
                    }
                }
            }
        }
    }
    stage('Run maven') {
      steps {
        container('maven') {
          sh 'mvn -version'
        }
        container('busybox') {
          sh '/bin/busybox'
        }
      }
    }
  }
}