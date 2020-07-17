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
                sh 'cat /tmp/results/_builds_root_test_MatVoc-Core.ttl.aggregatedTestCaseResult.ttl #Show results'
            }
        }
    }
    stages {
        stage('Test2') {
            agent {
                docker { image 'kurt/raptor:1.4'
                    args '--entrypoint=""'}
            }
            steps {
                sh 'chmod 777 /prepareFile.sh && touch /builds/root/test/PS.xml && touch /builds/root/test/PS_correct.xml && /prepareFile.sh'
                sh 'curl -X POST -H "Content-Type: text/xml" http://oops-ws.oeg-upm.net/rest --data @/builds/root/test/PS_correct.xml'
            }
        }
    }
}
