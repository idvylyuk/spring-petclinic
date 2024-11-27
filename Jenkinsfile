pipeline{
    agent{
        label "ubuntu-agent"
    }
    tools {
        gradle 'gradle-8.10.2' 
    }
    stages{
        stage("Test & Build"){
            when {
                branch 'main'
            }
            steps{
                echo "===================== Running Checkstyle ====================="
                sh './gradlew checkstyleMain checkstyleTest'
            }
        }

        stage("B"){
            when {
                changeRequest()
            }
            steps {
                echo "PR TEST 2"
                sh "printenv"
            }
        }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ======="
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}
