pipeline {
  agent any
  stages {
    stage('Compile') {
      steps {
        sh './gradlew compileDebugSources'
      }
    }
    stage('Build APK') {
      steps {
        sh './gradlew assemble'
      }
    }
    stage('Lint') {
      parallel {
        stage('Lint') {
          steps {
            sh './gradlew app:lint'
            androidLint()
          }
        }
        stage('checkstyle') {
          steps {
            sh './gradlew app:checkstyle'
            checkstyle()
          }
        }
        stage('pmd') {
          steps {
            sh './gradlew app:pmd'
            pmd()
          }
        }
        stage('findbugs') {
          steps {
            sh './gradlew app:findbugs'
            findbugs()
          }
        }
        stage('scan workspace') {
          steps {
            openTasks(ignoreCase: true, high: 'bug', normal: 'todo')
          }
        }
      }
    }
    stage('apk') {
      steps {
        archiveArtifacts '**/*.apk'
      }
    }
    stage('print msg') {
      parallel {
        stage('print msg') {
          steps {
            echo 'Done'
          }
        }
        stage('slack') {
          steps {
            slackSend(failOnError: true, message: 'From Fish MBP', teamDomain: 'projectnemo1', token: 'v10W4HsJsbGsYvtGf2rJJeGF')
          }
        }
      }
    }
  }
}