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
        stage('sloc') {
          steps {
            sh 'sloccount --duplicates --wide --details **/src > sloccount.sc'
            sloccountPublish encoding: '', pattern: ''
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


  }

  post {
      // 下面這些狀態的內容不得為空, 否則會發生錯誤.

      failure {
        echo "post failure"
        //sendNotification()
      }

      unstable {
        echo "post unstable"
        //sendNotification()
      }

      fixed {
        echo "post fixed"
        //sendNotification()
      }

      always {
        echo "post always"
        echo "Build completed. currentBuild.result = ${currentBuild.result}"
        sendNotification()
        getChangeLogs()
      }

      changed {
        echo "post changed"
      }

      regression {
        echo "post regression"
      }

      aborted {
        echo "post aborted"
      }

      success {
        echo "post success"
      }

      unsuccessful {
        echo "post unsuccessful"
      }

      cleanup {
        echo "post cleanup"
      }
    }
}

/*
* 依照建置狀態取得顏色
*/
def getColorByStatus() {
  echo 'getColorByStatus'
  // 建置成功時 status = null.
  def status = "${currentBuild.result}";
  def color = '#1e90ff' // blue
  if(status=='FAILURE'){
    color = '#F400A1' // red
  } else if(status=='UNSTABLE') {
    color = '#FFEF00' // yellow
  }

  echo 'status:'+status+' ,color:'+color
  return color
}

/*
* 取得 git commit logs.
*/
def getChangeLogs() {
  //echo 'getChangeLogs'

  def str = ""

  def changeLogSets = currentBuild.changeSets
  for (int i = 0; i < changeLogSets.size(); i++) {
    def entries = changeLogSets[i].items
    for (int j = 0; j < entries.length; j++) {
        def entry = entries[j]
        //echo "${entry.commitId} by ${entry.author} on ${new Date(entry.timestamp)}: ${entry.msg}"
        str = str + "\n[${entry.author}] ${entry.msg}"
        // 下面是有變更的檔案之資訊.
        // def files = new ArrayList(entry.affectedFiles)
        // for (int k = 0; k < files.size(); k++) {
        //     def file = files[k]
        //     echo "  ${file.editType.name} ${file.path}"
        // }
    }
  }

  return str
}

/*
* 發通知
*/
def sendNotification() {
  echo "sendNotification"
  sendSlack()
  sendEmailExt()
}

/*
* 發 slack 訊息
*/
def sendSlack() {
  echo "sendSlack"
  // slack.
  slackSend color: getColorByStatus(), failOnError: false, message: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER}\nBUILD_URL:${env.BUILD_URL}\n${getChangeLogs()}\n", teamDomain: 'myrewards', token: 'yf7TQbL4E6WfaEt70ldNawTI'
}

/*
* 寄增強型 email
*/
def sendEmailExt() {
  echo "sendEmailExt"
  // body 裡的變數是 eamilext plugin 才能用的, 不要拿去別的地方用. fish.
  // emailext
  emailext mimeType: 'text/html',
  replyTo: 'baikin.fish@gmail.com',
  subject: "${env.JOB_NAME} - Build# ${env.BUILD_NUMBER} - ${currentBuild.result}",
  to: 'essenchang@gmail.com',
  body: '''
  項目名稱: $PROJECT_NAME<br/>

  建置狀態: <font color="${getColorByStatus()}">$BUILD_STATUS</font><br/>

  建置編號: <font color="${getColorByStatus()}">$BUILD_NUMBER</font><br/><hr/>

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

  變更集: ${JELLY_SCRIPT,template="html"}<br/><hr/>
  ''',
  recipientProviders: [developers()]
}
