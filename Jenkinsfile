pipeline {
    agent any
    
    tools{
        jdk 'JDK11'
        maven 'maven3'
    }
    environment{
        SCANNER_HOME= tool "sonarScanner"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'master', changelog: false, credentialsId: '3230f525-54b9-4a60-932b-ec4c898718be', poll: false, url: 'https://github.com/Srinatha-T-D/eCommerce'
            }
        }
        
        stage('sonarqube') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh """
                        /var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonarScanner/bin/sonar-scanner \
                        -Dsonar.projectKey=eCommerce \
                        -Dsonar.projectName=eCommerce \
                        -Dsonar.sources=. \
                        -Dsonar.java.binaries=. \
                        -Dsonar.host.url=http://localhost:9000 """
                }
            }
        }
        
        stage('OWASP') {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('BUILD') {
            steps {
                sh '''
            cd src
            python3 -m venv venv
            . venv/bin/activate
            pip install -r requirements.txt

            # Run Django checks / tests (adjust if needed)
            python manage.py check
            python manage.py test
        '''
            }
        }
        
        stage('Docker') {
            steps {
               script{
                  withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker', url: 'https://index.docker.io/v1/') {
                sh 'docker build --no-cache -t srinathatd/ecommerce:latest -f Dockerfile .'
                sh 'docker push srinathatd/ecommerce:latest'
                   }
               }
            }
        }
        
        stage('Trigger CI') {
            steps {
                build job:"CD-eCommerce", wait:true
            }
        }
    }
}
