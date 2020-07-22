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
                    args 'entrypoint=""'}
            }
            steps {
                sh '/bin/sh /script.sh'
            }
        }
    }
}
