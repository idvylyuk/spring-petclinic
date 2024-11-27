pipeline{
    agent{
        label "ubuntu-agent"
    }
    stages{
        stage("Test & Build"){
            when {
                branch 'main'
            }
            steps{
                sh 'ls -a'
                echo "===================== Running Checkstyle ====================="
                sh './gradlew checkstyleMain checkstyleTest'
                archiveArtifacts artifacts: 'build/reports/checkstyle/main.html', fingerprint: true
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
