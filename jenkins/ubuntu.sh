#! /bin/bash
sudo touch /dev/i_worked.txt
sudo apt update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt update
sudo apt-get install docker-ce -y
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo systemctl start docker
sudo systemctl enable docker
cd /home/ubuntu
sudo echo "amazon-ecs
ansicolor
antisamy-markup-formatter
artifactory
aws-codebuild
aws-credentials
aws-java-sdk
aws-parameter-store
aws-secrets-manager-credentials-provider
aws-secrets-manager-secret-source
blueocean
build-timeout
build-user-vars-plugin
code-coverage-api
codedeploy
configuration-as-code
dashboard-view
description-setter
docker-java-api
docker-plugin
docker-workflow
ec2
email-ext
envinject
environment-variable-page-decoration
extended-choice-parameter
generic-webhook-trigger
ghprb
git
git-client
git-parameter
gitlab-plugin:1.6.0
github
github-api
github-branch-source
http_request
jacoco
jdk-tool
job-dsl
junit
mailer
matrix-project
parameterized-trigger
pipeline-aws
pipeline-input-step
pipeline-stage-view
pipeline-utility-steps
rebuild
repo
rich-text-publisher-plugin
robot
role-strategy
saml
script-security
simple-theme-plugin
slack
sonar
ssh-agent
startup-trigger-plugin
sumologic-publisher
timestamper
trilead-api
warnings-ng
workflow-aggregator
ws-cleanup
xunit" > plugins.txt
sudo echo "FROM jenkins/jenkins:lts-jdk11

COPY --chown=jenkins:jenkins plugins.txt /plugins.txt

RUN jenkins-plugin-cli --plugin-file /plugins.txt

USER root
RUN apt-get update && apt-get install -y python3
RUN apt-get -y install python3-pip
EXPOSE 5000
" > custom-jenkins-docker

docker build -f custom-jenkins-docker . -t custom-jenkins-image

docker run -p 8080:8080 -p 5000:5000 --restart=on-failure -t custom-jenkins-image