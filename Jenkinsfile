pipeline {
    agent any

    tools {
        // 👇 This MUST match the Maven name in "Manage Jenkins → Tools"
        maven 'maven-3.9.11'
    }

    stages {
        stage('Checkout') {
            steps {
                // Uses the repo & branch from your job's SCM config
                checkout scm
            }
        }

        stage('Build JAR') {
            steps {
                // Runs Maven to build your Spring Boot jar
                sh 'mvn clean package -DskipTests'
            }
        }
    }

    post {
        success {
            echo '✅ Build succeeded: JAR created in target/.'
        }
        failure {
            echo '❌ Build failed. Check the console output for errors.'
        }
    }
}
