pipeline{
    agent any
    stages{
        stage("Git Check out for cicd-3"){
            steps{
                git branch: 'main', url: 'https://github.com/honeytttt/CICD-3.git'
            }
        }
        stage("Unit testing for cicd-3"){
            steps{
                sh 'mvn test'
            }
        }
        stage("Integration testing for cicd-3"){
            steps{
                sh 'mvn verify -DskipUnitTests'
            }
        }
        stage('Building the application war for cicd-3'){
            steps{
                sh 'mvn clean install'
            }
        }
        stage('Adding static code analysis with sonarqube'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh 'mvn clean package sonar:sonar'
                    }
                }
            }
        }
        stage('Adding quality gate stage'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }
        }
        stage('adding war file to nexus repository'){
            steps{
                script{

                    def readPomVersion = readMavenPom file: 'pom.xml'
                    nexusArtifactUploader artifacts: 
                    [
                        [
                            artifactId: 'springboot', 
                            classifier: '', 
                            file: 'target/Uber.jar', 
                            type: 'jar'
                        ]
                    ], 
                        credentialsId: 'nexus-login', 
                        groupId: 'com.example', 
                        nexusUrl: '34.142.233.78:8081', 
                        nexusVersion: 'nexus3', 
                        protocol: 'http', 
                        repository: 'cicd-3', 
                        version: "${readPomVersion.version}"
                }
            }
        }
        stage('Docker iamge build'){
            steps{
                script{
                    sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID honeyttt/$JOB_NAME:v1.$BUILD_ID'
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID honeyttt/$JOB_NAME:latest'
                }
            }
        }
        stage('Push the images to Dockerhub repo'){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_pass')]) {
                        sh 'docker login -u honeyttt -p ${docker_pass}'
                        sh 'docker image push honeyttt/$JOB_NAME:v1.$BUILD_ID'
                        sh 'docker image push honeyttt/$JOB_NAME:latest'
                    }
                }
            }
        }
    }
    
}