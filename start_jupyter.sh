#!/bin/sh
apt install git -y
apt install wget -y
apt install tmux -y
#安装显卡驱动
git config --global url."https://zyssyz123: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@github.com/".insteadOf "https://github.com/"
wget  -P /root https://storage.googleapis.com/sos-aiplayground-operating-environment/environment-docker/install_gpu_driver.py
sudo python3 /root/install_gpu_driver.py

#安装docker
sudo apt-get update

sudo apt-get install --yes --no-install-recommends \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg \
     lsb-release

sudo rm -rf /usr/share/keyrings/docker-archive-keyring.gpg
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
 "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo systemctl enable docker
sudo systemctl start docker

sudo groupadd docker
sudo usermod -aG docker $USER

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker

#登陆docker
docker login --username=wen020 --password=dckr_pat_rGCOrzJBpSHAfIVUh3f2-1kQY74

#拉取image
docker pull wen020/ml_server:jupyter

#运行image
docker run -tid -p 8888:8888 --env JUPYTER_PASSWORD='8glabs' --gpus all -v $PWD:/worksapce wen020/ml_server:jupyter
