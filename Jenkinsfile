pipeline {
  agent any

  def emailBody = '${SCRIPT, template="regressionfailed.groovy"}'
  def emailSubject = "${env.JOB_NAME} - Build# ${env.BUILD_NUMBER} - ${env.BUILD_STATUS}"

  stages {
    stage('Build APK') {
      steps {
        sh './gradlew assemble'
      }
    }

    stage('apk') {
      steps {
        archiveArtifacts '**/*.apk'
      }
    }

    stage('Static Analytics') {
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

    stage('fabric') {
      steps {
        fabric apiKey: '4187a95331ec5371aa2c71c73b09b012d2274803',
        apkPath: 'app/build/outputs/apk/debug/app-debug.apk',
        buildSecret: '4e79a2e1f318cd79b3ac0877ef6f5d6cf40af9928033fb8846e783e9a0c7894d',
        notifyTestersType: 'NOTIFY_TESTERS_EMAILS',
        organization: '',
        releaseNotesFile: 'release_notes.txt',
        releaseNotesParameter: 'FABRIC_RELEASE_NOTES',
        releaseNotesType: 'RELEASE_NOTES_FROM_CHANGELOG',
        testersEmails: 'essenchang@gmail.com',
        testersGroup: '',
        useAntStyleInclude: false
      }
    }

/*
    stage('email') {
      steps {
        mail bcc: '', body: 'BBB', cc: '', from: 'baikin.fish@gmail.com', replyTo: 'baikin.fish@gmail.com', subject: 'AAA', to: 'essenchang@gmail.com'
      }
    }
*/

    stage('emailExt') {
      steps {

        emailext(mimeType: 'text/html', replyTo: 'baikin.fish@gmail.com', subject: emailSubject, to: 'essenchang@gmail.com', body: emailBody)

      }
    }


  }
}