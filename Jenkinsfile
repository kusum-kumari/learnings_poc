pipeline {
    agent any 
    stages {
        stage('Stage 1') {
            steps {
                echo 'Hello Kusum, from Jenkins!' 
            }
        }
        stage('Stage 2') {
        	environment { 
                DEBUG_FLAGS = '-g'
            }
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
                echo "JAVA_HOME ${env.JAVA_HOME}"
                echo "NODE_NAME        ${env.NODE_NAME}     JOB_NAME    ${env.JOB_NAME}      WORKSPACE     ${env.JWORKSPACE}  "
                sh 'printenv'
            }
        }
    }
}