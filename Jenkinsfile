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
    stage('Terraform EC2 create') {
      steps {
        dir('terraform_files'){
          sh 'terraform init'
          sh 'terraform validate'
          sh 'chmod 600 bank.pem'
          sh 'terraform apply --auto-approve'
          sh 'sleep 20'
        }
      }
    }
    stage('deploy kubernetes prod'){
steps{
  sh 'sudo chmod 600 ./terraform_files/bank.pem'    
  sh 'minikube start'
  sh 'sleep 30'
  sh 'sudo scp -o StrictHostKeyChecking=no -i ./terraform_files/sir.pem deployment.yml ubuntu@172.31.17.230:/home/ubuntu/'
  sh 'sudo scp -o StrictHostKeyChecking=no -i ./terraform_files/sir.pem service.yml ubuntu@172.31.17.230:/home/ubuntu/'
script{
  try{
  sh 'ssh -o StrictHostKeyChecking=no -i ./terraform_files/sir.pem ubuntu@172.31.17.230 kubectl apply -f .'
  }catch(error)
  {
  sh 'ssh -o StrictHostKeyChecking=no -i ./terraform_files/sir.pem ubuntu@172.31.17.230 kubectl apply -f .'
  }
}
}
}

  }
}
