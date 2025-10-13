pipeline {
  agent any
          
  stages {
    stage('Git Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/sanjayras/healthcare.git'
                        }
            }
    stage('Create Package') {
      steps {
        sh 'mvn package'
                          }
            }
    
    stage('Create Docker Image') {
      steps {
        echo 'This stage will Create a Docker image'
        sh 'docker build -t sanjayras/healthcare:1.0 .'
                          }
            }
     stage('Docker-Login') {
           steps {
              withCredentials([usernamePassword(credentialsId: 'docker_id', passwordVariable: 'docker_passwd', usernameVariable: 'docker_username')]) {
               sh 'docker login -u ${docker_username} -p ${docker_passwd}'
                             
                        }
                }
}
    stage('Docker Push-Image') {
      steps {
        sh 'docker push sanjayras/healthcare:1.0'
            }
      } 
    stage('AWS-Login') {
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws_id', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
         }
      }
    }

  }
}
