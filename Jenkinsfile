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
        stage('Cleanup Workspace') { steps { deleteDir() } }
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git checkout main'
            }
        }
        stage('Sync Branch') {
            steps {
                sh 'git fetch origin main'
                sh 'git reset --hard origin/main'
            }
        }
        stage('Sanity Check') {
            steps { sh 'sanity_check ./bin/radar_scan' }
        }
        stage('Scan folder') {
            steps {
                sh '''
                    radar_scan --disable-ui --type folder ./ --format json --outfile scan_file || exit_code=$?
                    if [ -f scan_file ]; then
                        echo "✅ scan_file generated"
                        cat scan_file
                    else
                        echo "❌ scan_file NOT generated"
                        ls -lh .
                    fi
                    exit ${exit_code:-0}
                '''
            }
        }
        stage('Bump Version') {
            steps { sh 'bump_version ./bin/radar_scan --patch' }
        }
        stage('Generate Folder Tree') {
            steps {
                sh 'folder_tree --output markdown --hidden > FOLDER_TREE.md'
            }
        }
        stage('Generate Self Doc') {
            steps {
                sh '''
                    chmod +x ./bin/radar_scan
                    self_doc -t ./tpl -f ./bin/radar_scan -d . -o README.md
                '''
            }
        }
        stage('Setup Git Credentials') {
            steps {
                sh 'git config --global user.email jenkins@example.com'
                sh 'git config --global user.name "Jenkins Bot"'
                // Diagnostics:
                sh 'echo "Git remote before:"; git remote -v'
                sh 'git remote set-url origin https://$GITHUB_TOKEN@github.com/raymonepping/homebrew-radar-scan-cli.git'
                sh 'echo "Git remote after:"; git remote -v'
            }
        }
        stage('Commit & Push') {
            steps {
                sh '''
                    git add README.md FOLDER_TREE.md || true
                    git commit -m "Update self-documentation and folder tree [ci skip]" || echo "No changes to commit"
                    echo "GitHub remote: $(git config --get remote.origin.url)"
                    echo "Token length: ${#GITHUB_TOKEN}"
                    git push origin main
                '''
            }
        }
    }
}
