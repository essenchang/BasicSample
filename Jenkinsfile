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
}