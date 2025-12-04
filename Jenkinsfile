pipeline {
    agent any

    tools {
        // Must match the Maven name in Manage Jenkins → Tools
        maven 'maven-3.9.11'
    }

    environment {
        // 👉 Change this to the Repository URL from Nexus,
        // e.g. from a hosted "maven-releases" repo
        // Example:
        // NEXUS_REPO_URL = 'http://192.168.49.2:8081/repository/maven-releases/'
        NEXUS_REPO_URL = 'http://192.168.49.2:30081/repository/maven-releases/'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Upload JAR to Nexus') {
            steps {
                // No credentials: this assumes the Nexus repo allows anonymous deploy
                sh '''
                    mvn deploy -DskipTests \
                      -DaltDeploymentRepository=nexus::default::${NEXUS_REPO_URL}
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Build succeeded and JAR was deployed to Nexus (if repo allows anonymous deploy).'
        }
        failure {
            echo '❌ Pipeline failed. Check the logs for the failing stage.'
        }
    }
}

