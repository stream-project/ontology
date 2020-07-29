pipeline {
    agent none
    stages {
        stage('Test RDFUnit') {
            agent {
                docker { image 'aksw/rdfunit'
                    args '--entrypoint=""'}
            }
            steps {
                sh 'java -jar /app/rdfunit-validate.jar -d ./MatVoc-Core.ttl -f /tmp/ -o json-ld -s owl,rdfs'
                sh 'cp /tmp/results/._MatVoc-Core.ttl.aggregatedTestCaseResult.jsonld ./RDFUnit_results.jsonld'
            }
        }
        stage('Test OOPS') {
            agent {
                docker { image 'tboonx/oops_caller:0.2'
                    args '--entrypoint=""'}
            }
            steps {
                sh '/bin/sh /script.sh MatVoc-Core > OOPS_result.xml'
                sh 'ls -hal'
            }
        }
    }
    post {
        always {
            emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}<br> More info at: <a href=\"${env.BUILD_URL}\">${env.BUILD_URL}</a>",
                recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
                subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
        }
    }
}
