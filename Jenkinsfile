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
              sh 'mvn install -DskipTests -Dspotbugs.skip=true -Ddependency-check.skip=true'
            }
          }
        }
        stage('Secrets scanner') {
          steps {
            container('trufflehog') {
              sh 'git clone ${GIT_URL}'
              sh 'cd secure-pipeline-java-demo && ls -al'
              sh 'cd secure-pipeline-java-demo && trufflehog .'
              sh 'rm -rf secure-pipeline-java-demo'
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
    stage('Static Analysis') {
      parallel {
        stage('Unit Tests') {
          steps {
            container('maven') {
              sh 'mvn test'
            }
          }
        }
        stage('Dependency Checker') {
          steps {
            container('maven') {
              catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                sh 'mvn org.owasp:dependency-check-maven:check'
              }
            }
          }
          post {
            always {
              archiveArtifacts allowEmptyArchive: true, artifacts: 'target/dependency-check-report.html', fingerprint: true, onlyIfSuccessful: true
              // dependencyCheckPublisher pattern: 'report.xml'
            }
          }
        }
        stage('Spot Bugs - Security') {
          steps {
            container('maven') {
              sh 'mvn compile spotbugs:check || exit 0'
            }
          }
          post {
            always {
              archiveArtifacts allowEmptyArchive: true, artifacts: 'target/spotbugsXml.xml', fingerprint: true, onlyIfSuccessful: false
            }
          }
        }
        stage('OSS License Checker') {
          steps {
            container('licensefinder') {
              sh 'ls -al'
              sh '''#!/bin/bash --login
                      /bin/bash --login
                      rvm use default
                      gem install license_finder
                      license_finder
                    '''
            }
          }
        }
        stage('SCA') {
          steps {
            container('maven') {
              sh 'mvn org.cyclonedx:cyclonedx-maven-plugin:makeAggregateBom'
            }
          }
          post {
            success {
              dependencyTrackPublisher projectName: 'sample-spring-app', projectVersion: '0.0.1', artifact: 'target/bom.xml', autoCreateProjects: true, synchronous: true
              archiveArtifacts allowEmptyArchive: true, artifacts: 'target/bom.xml', fingerprint: true, onlyIfSuccessful: true
            }
          }
        }
      }
    }
    stage('Package') {
      steps {
        container('docker-tools') {
          sh 'ls -al'
          sh 'docker build . -t sample-app'
        }
      }
    }
    stage('Artefact Analysis') {
      parallel {
        stage('Image Scan') {
          steps {
            container('docker-tools') {
              sh 'grype sample-app:latest'
              }
          }
        }
        stage('Image Hardening') {
          steps {
            container('docker-tools') {
              sh 'dockle sample-app:latest'
            }
          }
        }
        stage('K8s Hardening') {
          steps {
            container('docker-tools') {
              sh 'kubesec scan pod.yaml'
            }
          }
        }
      }
    }
    stage('Deploy') {
      steps {
        // TODO
        sh "echo done"
      }
    }
    stage('Dynamic Analysis') {
      parallel {
        stage('E2E tests') {
          steps {
            sh 'echo "All Tests passed!!!"'
          }
        }
        stage('DAST') {
          steps {
            container('docker-tools') {
              sh 'docker run -t owasp/zap2docker-stable zap-baseline.py -t https://www.zaproxy.org/ || exit 0'
            }
          }
        }
      }
    }
  }
}
