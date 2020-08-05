myVar = 'initial_value'

pipeline {
    agent { 
        label 'Developer30' 
    }
    environment {
        now = """${sh(
                returnStdout: true,
                script: 'date "+%F_%H:%M"'
            )}"""
        git_credentials = credentials('github_credentials')
    }
    stages {
        stage('Test RDFUnit') {
            agent {
                docker { image 'aksw/rdfunit'
                    args '--entrypoint=""'}
            }
            steps {
                sh 'rm -f oops_result.xml OOPS_result.xml result.xml reports.txt all_reports.txt RDFUnit_errors_.txt RDFUnit_errors.txt RDFUnit_results.jsonld'
                sh 'java -jar /app/rdfunit-validate.jar -d ./MatVoc-Core.ttl -f /tmp/ -o json-ld -s owl,rdfs'
                sh 'cp /tmp/results/._MatVoc-Core.ttl.aggregatedTestCaseResult.jsonld ./RDFUnit_results.jsonld'
                sh 'cat ./RDFUnit_results.jsonld'
            }
        }
        stage('Test OOPS') {
            agent {
                docker { image 'tboonx/oops_caller:0.3'
                    args '--entrypoint=""'}
            }
            steps {
                sh '/bin/sh /script.sh MatVoc-Core'
                sh 'cp result.xml oops_result.xml'
            }
        }
        stage('Interprete reports') {
            agent {
                docker { image 'alpine/xml'}
            }
            steps {
                sh 'sh -c " cat ./RDFUnit_results.jsonld | jq -c \'.[\\"@graph\\"] | .[] | select(.resultStatus | . and contains (\\"rut:ResultStatusFail\\"))\'  | jq . " > RDFUnit_errors_.txt'
                sh './interprete.sh'
                script {
                  myVar = readFile('reports.txt')
                }
                sh './interprete2.sh'
            }
        }
        stage('Add git tag') {
            agent {
                docker { image 'tboonx/git:0.1'
                    args '--entrypoint=""'}
            }
            steps {
                sh 'git clone https://$git_credentials_USR:git_credentials_PSW@github.com/TBoonX/ontology.git'
                sh 'git tag -a -m "Verified by CI" verified-$now'
                sh 'git push --follow-tags'
            }
        }
    }
    post {
        always {
            emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}<br> More info at: <a href=\"${env.BUILD_URL}\">${env.BUILD_URL}</a><br><br>At the end you find the summary of RDFUnit and OOPS.<br><br>For more information read the job result.<br><br><pre>${myVar}</pre>",
                recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
                subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
        }
    }
}
