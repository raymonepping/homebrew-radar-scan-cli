pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
    }
    stages {
        stage('Bump Version') {
            steps {
                sh 'bump_version ./bin/radar_scan --patch'
            }
        }
    }
    stages {
        stage('Scan folder') {
            steps {
                sh 'radar_scan --type folder ./ --format json --outfile scan_file'
            }
        }
    }    
}