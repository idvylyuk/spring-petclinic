pipeline{
    agent{
        label "ubuntu-agent"
    }
    environment {
        NEXUS_URL = 'http://10.0.2.2:8081/repository/maven-central/'
        NEXUS_USER = "admin"
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
                changeRequest()
            }
            steps{
                sh 'printenv'
                echo "===================== Running Checkstyle ====================="
                sh './gradlew checkstyleMain checkstyleTest'
                archiveArtifacts artifacts: 'build/reports/checkstyle/main.html', fingerprint: true
                echo "===================== Running Tests ====================="
                sh "./gradlew test --info --stacktrace"
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
                    env.DOCKER_TAG = env.GIT_COMMIT.take(7)
                    if (env.BRANCH_NAME == 'main') {
                        env.DOCKER_REPO = "${DOCKER_MAIN_REPO}"
                        env.DOCKERFILE = "Dockerfile --build-arg HOME=$HOME"
                    } else if (env.BRANCH_NAME ==~ /^PR-.*/) {
                        env.DOCKER_REPO = "${DOCKER_MR_REPO}"
                        env.DOCKERFILE = "Simple_Dockerfile"
                    }
                    echo "Shortened Git Commit: ${env.DOCKER_TAG}"
                }
            sh "docker build -t ${DOCKER_IMAGE}:${env.DOCKER_TAG} -f ${env.DOCKERFILE} ."
            sh "docker tag ${DOCKER_IMAGE}:${env.DOCKER_TAG} ${env.DOCKER_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG}"
            withCredentials([usernamePassword(credentialsId: 'nexus-creds', passwordVariable: 'password', usernameVariable: 'username')]) {
                    sh '''
                        echo $password | docker login -u $username --password-stdin ${env.DOCKER_REPO}
                    '''
                }

            sh 'docker login -u $NEXUS_USER -p $NEXUS_PASSWORD ${env.DOCKER_REPO}'
            sh "docker push ${env.DOCKER_REPO}/${DOCKER_IMAGE}:${env.DOCKER_TAG}"
           }
           post {
            always {
                sh "docker system prune -f"
                sh "docker logout"
            }
           }

        }
    }
    post{
        success{
            echo "========pipeline executed successfully ======="
            echo "---> Docker build: ${DOCKER_IMAGE}:${env.DOCKER_TAG}"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}
