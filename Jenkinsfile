pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
        VAULT_RADAR_GIT_TOKEN    = credentials('VAULT_RADAR_GIT_TOKEN')
        HCP_PROJECT_ID           = credentials('HCP_PROJECT_ID')
        HCP_RADAR_AGENT_POOL_ID  = credentials('HCP_RADAR_AGENT_POOL_ID')
        HCP_CLIENT_ID            = credentials('HCP_CLIENT_ID')
        HCP_CLIENT_SECRET        = credentials('HCP_CLIENT_SECRET')
    }
    stages {
        stage('Sanity Check') {
            steps {
                sh 'sanity_check ./bin/radar_scan'
            }
        }        
        stage('Scan folder') {
            steps {
                sh 'radar_scan --disable-ui --type folder ./ --format json --outfile scan_file'
            }
        }
        stage('Bump Version') {
            steps {
                sh 'bump_version ./bin/radar_scan --patch'
            }
        }
    }
}
