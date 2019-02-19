pipeline {
  agent any
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

    stage('email1') {
      steps {
        mail bcc: '', body: 'BBB', cc: '', from: 'baikin.fish@gmail.com', replyTo: 'baikin.fish@gmail.com', subject: 'AAA', to: 'essenchang@gmail.com'
      }
    }


    stage('email2') {
      steps {
        emailext attachLog: true, body: '''項目名稱: $PROJECT_NAME<br/>

        建置狀態: $BUILD_STATUS<br/>

        建置編號: $BUILD_NUMBER<br/><hr/>

        git Branch: ${GIT_BRANCH}<br/>

        git版本號: ${GIT_REVISION}<br/>

        git Log : ${CHANGES}<br/><hr/>

        觸發原因: ${CAUSE}<br/><hr/>

        建置位址: <a href="$BUILD_URL">$BUILD_URL</a><br/><hr/>

        <table width="80%" border="0">
          <tr>
            <td align="center" colspan="3">自動測試報告彙整</td>
          </tr>
          <tr>
            <td align="center"><a href="${BUILD_URL}testReport">測試報告</a></td>
            <td align="center"><a href="${BUILD_URL}jacoco">測試覆蓋率</a></td>
            <td align="center"><a href="${BUILD_URL}androidLintResult">Android Lint</a></td>
          </tr>
        </table>
        <br/><hr/>

        終端機輸出: <a href="${BUILD_URL}console">${BUILD_URL}console</a><br/><hr/>

        變更集: ${JELLY_SCRIPT,template="html"}<br/><hr/>''',
        compressLog: true,
        subject: 'FFFF',
        to: 'essenchang@gmail.com'

      }
    }


  }
}