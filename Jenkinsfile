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
    }
    
}