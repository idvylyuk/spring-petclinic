pipeline{
    agent{
        label "ubuntu-agent"
    }
    environment {
        NEXUS_URL = 'http://10.0.2.2:8081/repository/maven-central/'
        NEXUS_USER = "admin"
        NEXUS_PASSWORD = credentials('NEXUS_PASSWORD')
        DOCKER_MR_REPO = "10.0.2.2:8082"
        DOCKER_MAIN_REPO = "10.0.2.2:8083"
        DOCKER_IMAGE = "spring-petclinic"

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
                echo "===================== Running Tests ====================="
                sh "./gradlew test"
                echo "===================== Packaging ====================="
                sh './gradlew build -x test'
                archiveArtifacts artifacts: "build/libs/*.jar", fingerprint: true

            }
        }

        stage("Docker build"){
            when {
                anyOf {
                    branch 'main'
                    changeRequest()
                }
            }
            steps {
                    script {
                    def DOCKER_TAG = env.GIT_COMMIT.take(7)
                    def DOCKER_REPO
                    if (env.BRANCH_NAME == 'main') {
                        DOCKER_REPO = "${DOCKER_MAIN_REPO}"
                    } else if (env.BRANCH_NAME ==~ /^PR-.*/) {
                        DOCKER_REPO = "${DOCKER_MR_REPO}"
                    }
                    echo "Shortened Git Commit: ${DOCKER_TAG}"
                }
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} -f Dockerfile ."
                sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
                sh "echo ${NEXUS_PASSWORD} | docker login -u ${NEXUS_USERNAME} --password-stdin ${DOCKER_REPO}"
                sh "docker push ${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
            }

        }
    }
    post{
        success{
            echo "========pipeline executed successfully ======="
            echo "======== DOCKER ======="
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}
