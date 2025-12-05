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
        NEXUS_REPO_URL = 'http://192.168.49.2:30081/repository/maven-snapshots/'

        //KUBECONFIG = credentials('k8s-creds')
        // 👇 Adjust these to match your K8s Deployment
        K8S_NAMESPACE       = 'default'
        K8S_DEPLOYMENT_NAME = 'springboot-webapp'  // or springboot-webapp, etc.
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
                          -DaltDeploymentRepository=nexus::default::http://${NEXUS_USER}:${NEXUS_PASS}@192.168.49.2:30081/repository/maven-snapshots/
                    '''
                }
            }
        }

         // 🔽 NEW LAST STAGE
        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    echo "Applying Kubernetes manifests..."

                    curl -LO "https://storage.googleapis.com/kubernetes-release/release/\$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
                    chmod u+x ./kubectl
                    
                    kubectl get pods

                    # 👇 These files should be in your repo
                    kubectl apply -f k8s/springboot-deployment.yaml
                    kubectl apply -f k8s/springboot-service.yaml

                    echo "Waiting for rollout of deployment \${K8S_DEPLOYMENT_NAME}..."
                    kubectl -n \${K8S_NAMESPACE} rollout status deployment/\${K8S_DEPLOYMENT_NAME}
                """
            }
        }
    }

    post {
        success {
            echo '✅ Build succeeded and JAR was deployed to Nexus, and webapp deployed to Kubernetes.'
        }
        failure {
            echo '❌ Pipeline failed. Check the logs for the failing stage.'
        }
    }
}
