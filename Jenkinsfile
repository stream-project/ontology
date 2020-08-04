myVar = 'initial_value'

pipeline {
    agent { 
        label 'Developer30' 
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
                sh 'rm -f ./RDFUnit_results.jsonld'
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
                sh 'cp result.xml oops_result.xml && ls -hal'
            }
        }
        stage('Interprete reports') {
            agent {
                docker { image 'alpine/xml'}
            }
            steps {
                sh 'ls -hal'
                sh 'sh -c " cat ./RDFUnit_results.jsonld | jq -c \'.[\\"@graph\\"] | .[] | select(.resultStatus | . and contains (\\"rut:ResultStatusFail\\"))\'  | jq . " > RDFUnit_errors_.txt'
                sh './interprete.sh'
                script {
                  // OPTION 1: set variable by reading from file.
                  // FYI, trim removes leading and trailing whitespace from the string
                  myVar = readFile('RDFUnit_errors.txt').trim()
                }
                sh './interprete.sh'
            }
        }
    }
    post {
        always {
            emailext attachmentsPattern: '**/RDFUnit_errors.txt',
                body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}<br> More info at: <a href=\"${env.BUILD_URL}\">${env.BUILD_URL}</a><br><br>As an attachment you find the summary of RDFUnit and OOPS.<br><br>For more information read the job result<br><br>${myVar}",
                recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
                subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
        }
    }
}
