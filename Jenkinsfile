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
    }
    
}