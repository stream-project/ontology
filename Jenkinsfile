myVar = 'An error occurred. Please read the jobs console output.'

pipeline {
    agent {
        label 'Developer30'
    }
    environment {
        now = """${sh(
                returnStdout: true,
                script: 'date "+%Y.%m.%d_%H.%M"'
            )}"""
        git_credentials = credentials('github_credentials')
        git_email = credentials('git_email')
    }
    stages {
        stage('Stop on git tag') {
            agent {
                docker { image 'tboonx/git:0.1'
                    args '--entrypoint=""'
                    reuseNode true
                }
            }
            steps {
                script {
                    env.PROCEED_TO_DEPLOY = 1
                    try {
                        '''cp -a "jenkins/*" ./
                        ./abortWhenTagPresent.sh'''
                    } catch (err) {
                        env.PROCEED_TO_DEPLOY = 0
                    }
                }
            }
        }
        stage('Test RDFUnit') {
            when {
                expression {
                    env.PROCEED_TO_DEPLOY == 1
                }
            }
            agent {
                docker { image 'aksw/rdfunit'
                    args '--entrypoint=""'
                    reuseNode true
                }
            }
            steps {
                // Cleanup of files from last job
                sh 'rm -fr  temp_ infered_classes.owl oops_result.xml OOPS_result.xml result.xml reports.txt all_reports.txt RDFUnit_errors_.txt RDFUnit_errors.txt RDFUnit_results.jsonld repo_clon'
                // Run RDFUnit
                sh 'java -jar /app/rdfunit-validate.jar -d ./MatVoc-Core.ttl -f /tmp/ -o json-ld -s owl,rdfs'
                // copy results to workdir and print it out
                sh 'cp /tmp/results/._MatVoc-Core.ttl.aggregatedTestCaseResult.jsonld ./RDFUnit_results.jsonld'
                //sh 'cat ./RDFUnit_results.jsonld'
            }
        }
        stage('Test OOPS') {
            when {
                expression {
                    env.PROCEED_TO_DEPLOY == 1
                }
            }
            agent {
                docker { image 'tboonx/oops_caller:0.3'
                    args '--entrypoint=""'
                    reuseNode true
                }
            }
            steps {
                sh 'cp /script.sh ./script.sh && sed -i -e "s/http/https/g" ./script.sh'
                sh '/bin/sh ./script.sh MatVoc-Core'
                sh 'cp result.xml oops_result.xml'
                sh 'cat oops_result.xml'
            }
        }
        stage('Interprete reports') {
            when {
                expression {
                    env.PROCEED_TO_DEPLOY == 1
                }
            }
            agent {
                docker { image 'alpine/xml:2019'
                    reuseNode true
                }
            }
            steps {
                // filter RDFUnit report
                sh 'sh -c " cat ./RDFUnit_results.jsonld | jq -c \'.[\\"@graph\\"] | .[] | select(.resultStatus | . and contains (\\"rut:ResultStatusFail\\"))\'  | jq -c \'select(.[\\"description\\"] != \\"http://www.w3.org/2000/01/rdf-schema#label is missing proper range\\") | select(.[\\"description\\"] != \\"http://www.w3.org/2000/01/rdf-schema#comment is missing proper range\\") | (.[\\"rut:resultCount\\"]), (.[\\"description\\"])\'" > RDFUnit_errors_.txt'
                // filter OOPS report
                sh './interprete.sh'
                // prepare email content
                script {
                  myVar = readFile('reports.txt')
                }
                sh 'cat reports.txt'
                // Chef if RDFUnit reported error, if yes than the job will fail
                sh './interprete2.sh'
            }
        }
        stage('Reasoner') {
            when {
                expression {
                    env.PROCEED_TO_DEPLOY == 1
                }
            }
            agent {
                docker { image 'tboonx/hermit:0.1'
                    args '--entrypoint=""'
                    reuseNode true
                }
            }
            steps {
                sh 'java -jar /hermit/HermiT.jar -cO -v2 -o infered_classes.owl ./MatVoc-Core.ttl'
                sh 'cat infered_classes.owl'
            }
        }
        stage('Add git tag') {
            when {
                expression {
                    env.PROCEED_TO_DEPLOY == 1
                }
            }
            agent {
                docker { image 'tboonx/git:0.1'
                    args '--entrypoint=""'
                    reuseNode true
                }
            }
            steps {
                // setup git
                sh 'git config user.email "$git_email" &&  git config user.name "TBoonX"'
                // Update the classes
                sh 'git add infered_classes.owl && bash ./try_commit.sh'
                // Add the tag
                sh 'git tag -a -m "Verified by CI" verified$now'
                // Push it to the repository
                sh 'git push https://TBoonX:$git_credentials@github.com/stream-project/ontology.git HEAD:master --follow-tags'
            }
        }
    }
    post {
        always {
            emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}<br> More info at: <a href=\"${env.BUILD_URL}\">${env.BUILD_URL}</a><br><br>At the end you find the summary of RDFUnit and OOPS.<br><br>For more information read the job result.<br>If there is no text, then the pipeline did not run and this email could be ignored.<br><br><pre>${myVar}</pre>",
                recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
                subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
        }
    }
}
