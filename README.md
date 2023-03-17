[![Build Status](http://54.38.159.42:8080/buildStatus/icon?job=MatVoc%20Ontology&style=plastic)](http://54.38.159.42:8080/job/MatVoc%20Ontology/)

# Ontology

The official ontology produced in the context of the STREAM project.
The documentation of the MatVoc concepts could be found under [stream-project.github.io](https://stream-project.github.io/).
There exists also a link from [w3id.org/STREAM/MatVoc](w3id.org/STREAM/MatVoc) to the documentation and the RDF files.

This repository does contain:
* turtle file of the MatVoc vocabulary
* owl files of the MSLE vocabulary
* a set of competency questions used in the project
* a Jenkinsfile for detecting basic problems in the MatVoc.ttl file
* scripts in the Jenkins folder for the Jenkins CI execution
* (old) a datasets folder
* basic inferred classification in the infered_classes.owl file


## Jenkins CI

This pipeline is also an artifact of the STREAM project but the server used will not be available after the project.
For future development we propose to switch to another CI like Github Actions.
The Ci has the following steps:
* Stop if the current commit was already verified
* Execute RDFUnit to detect basic errors in the owl and rdfs use
* Call the OOPS common pitfall scanner
* Create an email out of the two reports
* Start HermiT to generate a basic classification
* If all of the above steps didn't create an error, the commit gets a verified tag and the tag plus the classification is pushed to this repository
* sending an email to the author of the commit


## (Outdated) Vocol Installation
In order to publish the ontology on the official website of the STREAM project, the following steps should be taken:
1. Log in to the server
   1. SSH to `stream-ontology.com` using proper credentials.
2. Install prerequisites
   1. `apt-get update`
   2. `apt-get install unzip`
   3. `sudo apt-get install docker`
3. Install the ontology visulization and documentation tool (VoCol)
   1. `mkdir stream`
   2. `cd stream`
   3. `git clone https://github.com/tibhannover/vocol.git`
   4. `cd /vocol`
   5. `docker build -t tib/vocol .` Watch the tailing dot.
   6. `docker run --name streamOntoVocol --restart=always -d -p 8081:3000 tib/vocol`
4. Deploy and run NginX from its offical image
   1. `docker run -it -d -p 80:80 --network=ontologyNetwork --name ontologyReverseProxy nginx`
5. Prepare the Docker network and add the Nginx and the Vocol conatiners to it
   1. `docker network create ontologyNetwork`
   2. `docker network connect ontologyNetwork ontologyReverseProxy`
   3. `docker network connect ontologyNetwork streamOntoVocol`
6. Log into the NginX container and set it to serve the ontology
   1. `docker exec -it ontologyReverseProxy "/bin/bash"`
   2. `apt-get update`
   3. `apt-get install nano`
   4. `nano /etc/nginx/conf.d/default.conf`
        - `server_name stream-ontology.com;`
        - `location / { proxy_pass http://streamOntoVocol:3000/; }` Watch the tailing slash.
        - Save and exit editor (nano: Ctrl+X, Y, Enter)
   5. `nginx -s reload`    
   6. `exit`
7. Visit the VoCol instance at `stream-ontology.com` and configure the tool to install the ontology on it.
