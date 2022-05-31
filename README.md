[![Build Status](http://54.38.159.42:8080/buildStatus/icon?job=MatVoc%20Ontology&style=plastic)](http://54.38.159.42:8080/job/MatVoc%20Ontology/)

# Ontology
The official ontology produced in the context of the STREAM project.
## (Outdated) Installation
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
