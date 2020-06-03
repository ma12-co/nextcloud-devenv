export DEBIAN_FRONTEND=noninteractive

echo ''
echo '##########################################'
echo '# Update and install required packages'
echo '##########################################'
echo ''

# make debconf use a frontend that expects no interactive input at all, preventing it from even trying to access stdin
apt-get update
apt-get install -y git
apt-get install -y apache2 mariadb-server libapache2-mod-php7.2  
apt-get install -y php7.2-gd php7.2-json php7.2-mysql php7.2-curl php7.2-mbstring
apt-get install -y php7.2-intl php-imagick php7.2-xml php7.2-zip
apt-get install -y nano
apt-get install -y make

echo ''
echo '##########'
echo '# Docker'
echo '##########'
echo ''

# Docker
# Remove old docker installs
apt-get remove docker docker-engine docker.io containerd runc

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get -y install docker-ce docker-ce-cli containerd.io


echo ''
echo '##########'
echo '# Nodejs'
echo '##########'
echo ''

# install nvm and node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
command -v nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install node


echo ''
echo '##########'
echo '# SSL'
echo '##########'
echo ''

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common
