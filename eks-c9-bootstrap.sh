
# Yum installs

echo ""
echo "###########################
Installling Kubernetes tools
###########################"
echo ""
sudo yum -y install awscli kubectl

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client

# Helm install
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo ""
echo "###########################
Installling scripting tools
###########################"
echo ""

sudo yum -y install jq gettext bash-completion moreutils

# Install yq yaml parser
echo 'yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}' | tee -a ~/.bashrc && source ~/.bashrc

# Verify the binaries are in the path and executable
for command in kubectl jq envsubst aws
  do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
  done
  
# Enable kubectl bash_completion
if type _init_completion > /dev/null
then echo "bash completion ready"
else 
  source /usr/share/bash-completion/bash_completion
  type _init_completion | echo "installed bash completion"
fi

#echo 'source <(kubectl completion bash)' >>~/.bashrc
source ~/.bashrc
## Create k alias
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc
