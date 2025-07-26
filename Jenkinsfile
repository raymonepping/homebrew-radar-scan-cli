pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
        VAULT_RADAR_GIT_TOKEN    = credentials('VAULT_RADAR_GIT_TOKEN')
        HCP_PROJECT_ID           = credentials('HCP_PROJECT_ID')
        HCP_RADAR_AGENT_POOL_ID  = credentials('HCP_RADAR_AGENT_POOL_ID')
        HCP_CLIENT_ID            = credentials('HCP_CLIENT_ID')
        HCP_CLIENT_SECRET        = credentials('HCP_CLIENT_SECRET')
        GITHUB_TOKEN             = credentials('GITHUB_TOKEN')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git checkout main'
            }
        }
        stage('Sanity Check') {
            steps { sh 'sanity_check ./bin/radar_scan' }
        }
        stage('Scan folder') {
            steps { sh 'radar_scan --disable-ui --type folder ./ --format json --outfile scan_file' }
        }
        stage('Bump Version') {
            steps { sh 'bump_version ./bin/radar_scan --patch' }
        }
        stage('Setup Git Credentials') {
            steps {
                sh '''
                git config --global user.email "jenkins@example.com"
                git config --global user.name "Jenkins Bot"
                git remote set-url origin https://$GITHUB_TOKEN@github.com/raymonepping/homebrew-radar-scan-cli.git
                '''
            }
        }
        stage('Commit & Push') {
            steps { sh 'commit_gh' }
            // Remove --quiet for now to debug errors!
        }
    }
}
