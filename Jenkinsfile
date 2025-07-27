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
                    vault-radar scan folder -p . -o scan_file -f csv --disable-ui || exit_code=$?
                    if [ -f scan_file ]; then
                        echo "✅ scan_file generated"
                        cat scan_file
                        # Check for findings (any non-header line = secret/PII found)
                        if grep -q -v '^category' scan_file; then
                            echo "🛑 SECRETS/PII FOUND! Failing build."
                            exit 1
                        else
                            echo "✅ No secrets found."
                        fi
                    else
                        echo "❌ scan_file NOT generated"
                        ls -lh .
                        exit 2
                    fi
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
                sh 'echo "Git remote before:"; git remote -v'
                sh "git remote set-url origin https://x-access-token:${GITHUB_TOKEN}@github.com/raymonepping/homebrew-radar-scan-cli.git"
                sh 'echo "Git remote after:"; git remote -v'
            }
        }
        stage('Commit & Push') {
            steps {
                sh '''
                    git add README.md FOLDER_TREE.md || true
                    git commit -m "Update self-documentation and folder tree [ci skip]" || echo "No changes to commit"
                '''
                sh "echo \"GitHub remote: \$(git config --get remote.origin.url)\""
                sh "echo \"Token length: \${#GITHUB_TOKEN}\""
                sh "git push origin main"
            }
        }
    }
}
