pipeline {
    agent any 
    
    tools {
        maven 'MAVEN_HOME'
    }
    stages {
        stage("Build Maven") {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ShahadSha/spring-boot-hello-world-argocd.git']]])
                sh "mvn clean install -DskipTests"
            }
        }

        stage("Build Docker Image") {
            steps {
                script {
                    sh 'docker build -t springboot .'
                }
            }
        }
        stage("AWS ECR Login") {
            steps {
                script {
                    sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws'
                }
            }
        }
        stage("AWS ECR Push") {
            steps {
                script {
                    sh 'docker tag springboot:latest public.ecr.aws/x3x3m9h6/springboot:${BUILD_NUMBER}'
                    sh 'docker push public.ecr.aws/x3x3m9h6/springboot:${BUILD_NUMBER}'
                }
            }
        }

        stage("Clone Charts") {
            steps {
                sh 'rm -r ./*'
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ShahadSha/BG-with-ArgoRollouts-and-Istio.git']]])
                sh 'ls -a'
                
                
            }
        }
        stage("Editing image id") {
            steps {
                //sh 'git pull https://github.com/ShahadSha/argocd-app-config.git'
                //sh '''sed -i 's/name:/name: hello/g' myapplication.yaml'''
                sh 'cd springboot'
                sh '''sed -i "s@image: .*@image: public.ecr.aws/x3x3m9h6/springboot:${BUILD_NUMBER}@g" springboot/rollout.yaml'''
                sh '''git add springboot/rollout.yaml && git commit -m "commit id ${BUILD_NUMBER}" '''

            }
        }
        stage("git push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-secret', passwordVariable: 'password', usernameVariable: 'username')]) {
                    sh '''git push https://$username:$password@github.com/ShahadSha/BG-with-ArgoRollouts-and-Istio.git HEAD:master --force'''
                }
            }
        }
        

        
    }
}