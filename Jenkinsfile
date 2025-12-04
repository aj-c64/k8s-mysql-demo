pipeline {
    agent any

    tools {
        // Must match the Maven name in Manage Jenkins → Tools → Maven
        maven 'maven-3.9.11'
    }

    environment {
        // Your Nexus Maven repo URL (from Nexus → Repositories → maven-releases → Repository URL)
        // Example:
        // NEXUS_REPO_URL = 'http://192.168.49.2:30081/repository/maven-releases/'
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
                // Use Jenkins credentials (ID: nexus-creds) to inject user/pass
                withCredentials([usernamePassword(
                    credentialsId: 'nexus-creds',
                    usernameVariable: 'NEXUS_USER',
                    passwordVariable: 'NEXUS_PASS'
                )]) {
                    // Quick + understandable approach for homework:
                    // put credentials directly in the repo URL (HTTP basic auth)
                    sh '''
                        mvn deploy -DskipTests \
                          -DaltDeploymentRepository=nexus::default::http://${NEXUS_USER}:${NEXUS_PASS}@192.168.49.2:30081/repository/maven-releases/
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build succeeded and JAR was deployed to Nexus.'
        }
        failure {
            echo '❌ Pipeline failed. Check the logs for the failing stage.'
        }
    }
}
