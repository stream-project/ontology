pipeline {
    agent none
    stages {
        stage('Test') {
            agent {
                docker { image 'aksw/rdfunit'
                    args '--entrypoint=""'}
            }
            steps {
                sh 'pwd'
                sh 'ls -hal'
                sh 'java -jar /app/rdfunit-validate.jar -d ./MatVoc-Core.ttl -f /tmp/ -o turtle -s owl,rdfs'
                sh 'cat /tmp/results/._MatVoc-Core.ttl.aggregatedTestCaseResult.ttl #Show results'
            }
        }
        stage('Test2') {
            agent {
                docker { image 'tboonx/oops_caller:0.1'
                    args '--entrypoint="" -v $pwd/MatVoc-Core.ttl:/builds/root/test/MatVoc-Core.ttl'}
            }
            steps {
                sh '/bin/sh /script.sh MatVoc-Core'
            }
        }
    }
    post {
        always {
            emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
                recipientProviders: [[[$class: 'RequesterRecipientProvider']],
                subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
        }
    }
}
