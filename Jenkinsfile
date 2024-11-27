pipeline{
    agent{
        label "ubuntu-agent"
    }
    environment {
        NEXUS_URL = 'http://10.0.2.2:8081/repository/maven-central/'
        NEXUS_PASSWORD = credentials('NEXUS_PASSWORD')
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
                sh 'printenv'
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
