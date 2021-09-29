cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Yum installs

echo ""
echo "###########################
Installling Kubernetes tools
###########################"
echo ""
sudo yum -y install awscli kubectl

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