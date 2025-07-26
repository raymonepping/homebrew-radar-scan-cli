pipeline {
  agent any
  environment {
    // You can inject secrets here if needed, e.g. for GitHub tokens
    // GIT_CREDENTIALS = credentials('your-jenkins-git-creds-id')
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Bump Version') {
      steps {
        dir('vault_radar') {
          echo '🔖 Bumping version with bump_version CLI...'
          sh 'bump_version ./bin/radar_scan --patch'
        }
      }
    }

    stage('Commit, Tag & Push') {
      steps {
        dir('vault_radar') {
          echo '📝 Committing, tagging, and pushing with commit_gh CLI...'
          sh 'commit_gh --bump patch --verify'
        }
      }
    }

    // Optional: Add this stage to run a radar scan as part of the pipeline
    stage('Vault Radar Scan (optional)') {
      when {
        expression { fileExists('vault_radar/bin/radar_scan') }
      }
      steps {
        dir('vault_radar') {
          echo '🔬 Running radar_scan...'
          sh './bin/radar_scan --type file README.md --format csv'
        }
      }
    }

    // Optional: More stages for build/test/deploy...
  }

  post {
    always {
      echo 'Pipeline finished.'
      archiveArtifacts artifacts: 'vault_radar/bin/CHANGELOG_radar_scan.md', allowEmptyArchive: true
    }
    failure {
      echo '❌ Build failed! Check the logs above for details.'
    }
    success {
      echo '✅ Build succeeded!'
    }
  }
}
