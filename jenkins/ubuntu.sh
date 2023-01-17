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
git clone https://github.com/Pokaori/devops.git
cd devops/jenkins
docker build -f custom-jenkins-docker . -t custom-jenkins-image

docker run -p 8080:8080 -p 5000:5000 --restart=on-failure -t custom-jenkins-image