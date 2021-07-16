pipeline {
    
    agent {
        kubernetes {
          defaultContainer 'jnlp'
          //cloud 'kubernetes'
          containerTemplate {
            name 'kubectl'
            image 'bitnami/kubectl:1.20.8'
            command 'sleep'
            args '99d'
            runAsUser '1000'
          }
        }
  }

    stages {
        stage('Debug Output') {

            steps {
                echo "------------------------"
                echo "DT TENANT URL: ${env.DT_TENANT}"
                echo "DT API : ${env.DT_API_TOKEN}"
                echo "------------------------"
            }
        }
        stage ('Clone Main Repository') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/KevLeng/sockshop'
            }
        }
        stage ('Download Monaco') {
            steps {
                sh './deploy-monaco.sh'
                sh 'ls $WORKSPACE'
            }
        }
        stage ('Apply Dynatrace Configuration') {
            steps {
                script {
                    monaco_command = "./monaco --environments=environments.yaml"
                    //if (env.Project_Value == "BaseConfig") monaco_command += " --project=projects/baseconfig"
                    //if (env.Project_Value == "TeamA") monaco_command += " --project=projects/teama"
                    //if (env.Environment_Value == "Preprod") monaco_command += " --specific-environment=preproduction"
                    //if (env.Environment_Value == "Prod") monaco_command += " --specific-environment=production"
                }
                container('kubectl') {
                    sh './push-monaco.sh'
                }
            }
        }
    }
}