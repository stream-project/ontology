pipeline {
    agent {
        docker { image 'aksw/rdfunit'
            args '--entrypoint=""'}
    }
    stages {
        stage('Test') {
            steps {
                sh 'pwd'
                sh 'ls -hal'
                sh 'java -jar /app/rdfunit-validate.jar -d ./MatVoc-Core.ttl -f /tmp/ -o turtle -s owl,rdfs'
                sh 'cat /tmp/results/_builds_root_test_PS.ttl.aggregatedTestCaseResult.ttl #Show results'
            }
        }
    }
}
