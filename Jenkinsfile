pipeline{
    // 定义groovy脚本中使用的环境变量
    environment{        
    // IMAGE_TAG =  sh(returnStdout: true,script: 'echo $image_tag').trim()
    IMAGE_TAG = "latest"
    ORIGIN_REPO =  sh(returnStdout: true,script: 'echo $origin_repo').trim()
    REPO =  sh(returnStdout: true,script: 'echo $repo').trim()
    BRANCH =  sh(returnStdout: true,script: 'echo $branch').trim()
    }

    agent{
        node{
            label 'slave-pipeline'
        }
        // docker {
        //     image 'node:6-alpine' 
        //     args '-p 3000:3000' 
        // }
    }

    stages{
        stage('Git'){
            steps{
            // git branch: '${BRANCH}', credentialsId: 'bintang_lenovo', url: 'git@bitbucket.org:m_bintang/jenkins-demo.git'
            git branch: '${BRANCH}', credentialsId: 'github_bintang', url: 'https://github.com/halilintar8/emoji-search2.git'
            }
        }

        stage('Package'){
            steps{
                echo 'Running build automation'
                //   sh 'cd emoji-search2'
                //   sh 'npm install'
                //   sh 'npm audit fix'
                //   sh 'yarn build'

                //   container("maven") {
                //   sh "mvn package -B -DskipTests"
                //   }
                container("npm-yarn") {
                    sh "npm install"
                    sh "npm audit fix"
                    sh "yarn build"
                }
            }
        }

        stage('Docker Build Image') {
            steps{
                echo "building docker image"                
                container('docker') {
                    sh "docker ps -a"
                    sh "docker build -t ${ORIGIN_REPO}/${REPO} ."
                    // sh "docker run -d -p 5000:5000 --restart=always --name registry registry:2"
                    // sh "docker run -d -p 5000:5000 --name registry registry:2"
                    // sh "docker build -t halilintar8/my-emoji-search:latest ."
                    // echo "build docker image selesai"
                }
            }          
        }

        stage('Push Docker Image') {       
            steps {
                echo "${ORIGIN_REPO}/${REPO}"
                // echo "${ORIGIN_REPO}/${REPO}:${IMAGE_TAG}"
                container('docker') {
                  echo "Push docker image to hub.docker.com"
                    script {                      
                      docker.withRegistry('', 'hub_docker_halilintar8') {
                        //app.push("${env.BUILD_NUMBER}")
                        
                        //app.push("${env.DOCKER_IMAGE_NAME}")
                        //app.push("latest")

                        // sh "docker tag ${ORIGIN_REPO}/${REPO} ${ORIGIN_REPO}/${REPO}:latest"
                        // sh "docker push ${ORIGIN_REPO}/${REPO}:latest"
                        sh "docker tag ${ORIGIN_REPO}/${REPO} ${ORIGIN_REPO}/${REPO}:${IMAGE_TAG}"
                        sh "docker push ${ORIGIN_REPO}/${REPO}:${IMAGE_TAG}"


                      }
                    }
                }
            }
        }

        // stage("Push image to Docker Hub") {
        //     steps {
        //         echo "${IMAGE_TAG}"
        //         echo "latestb"
        //         container('docker') {
        //             echo "Push docker image to hub.docker.com"
        //             script {
        //                 docker.withRegistry('', 'hub_docker_halilintar8') {
        //                     sh "docker tag ${ORIGIN_REPO}/${REPO} ${ORIGIN_REPO}/${REPO}:${IMAGE_TAG}"
        //                     sh "docker push ${ORIGIN_REPO}/${REPO}:${IMAGE_TAG}"

        //                     // sh "docker tag halilintar8/my-emoji-search halilintar8/my-emoji-search:latest"
        //                     // sh "docker push halilintar8/my-emoji-search:latest"
        //                 }
        //             }
        //         }
        //     }
        // }
        
        stage('Deploy to Kubernetes') {
            steps {
                /// echo "${ORIGIN_REPO}/${REPO}:${IMAGE_TAG}"
                container('kubectl') {
                    echo "Deploy to Kubernetes Cluster"
                    script {
                        step([$class: 'KubernetesDeploy', authMethod: 'certs', apiServerUrl: 'https://10.8.1.120:6443', credentialsId:'k8sCertAuth', config: 'deployment.yaml',variableState: 'ORIGIN_REPO,REPO,IMAGE_TAG'])
                    }
                }
            }
            
        }
    }
}
