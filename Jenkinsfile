pipeline {
    agent any

    tools {
        // Change this to match the Maven installation name in Jenkins (Manage Jenkins → Global Tool Configuration)
        maven 'maven-3.9.11'
    }

    environment {
        NEXUS_REPO_URL = 'http://192.168.49.2:30081/repository/maven-releases/'

        // Name of your Kubernetes Deployment that runs the Spring Boot app
        K8S_DEPLOYMENT_NAME = 'springboot-app'

        // Namespace where that deployment lives (probably "default" for your assignment)
        K8S_NAMESPACE = 'default'
    }

    stages {
        stage('Checkout from GitHub') {
            steps {
                // Uses the repo + branch configured in the Jenkins job
                checkout scm
            }
        }

        stage('Build JAR with Maven') {
            steps {
                // If your tests require MySQL and that’s not set up in CI, keep -DskipTests
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Upload JAR to Nexus') {
            steps {
                // This assumes your pom.xml + settings.xml are already configured
                // to deploy to the Nexus repo you set up (like when you practiced manually).
                //
                // If your class had you run "mvn deploy" from the command line to push to Nexus,
                // this should be the same thing, now automated in Jenkins.
                sh '''
                    mvn deploy -DskipTests \
                      -DaltDeploymentRepository=nexus::default::${NEXUS_REPO_URL}
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    echo "Restarting Kubernetes deployment \${K8S_DEPLOYMENT_NAME} in namespace \${K8S_NAMESPACE}..."

                    # If you need a specific context, uncomment and adjust:
                    # kubectl config use-context minikube

                    kubectl -n \${K8S_NAMESPACE} rollout restart deployment \${K8S_DEPLOYMENT_NAME}
                    kubectl -n \${K8S_NAMESPACE} rollout status deployment \${K8S_DEPLOYMENT_NAME}
                """
            }
        }
    }

    post {
        success {
            echo 'Pipeline finished: JAR built, pushed to Nexus, and Spring Boot deployment restarted in Kubernetes.'
        }
        failure {
            echo 'Pipeline failed. Check which stage broke in the logs.'
        }
    }
}

