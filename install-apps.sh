export DEBIAN_FRONTEND=noninteractive

echo ''
echo '##########################################'
echo '# Install apps'
echo '##########################################'

cd /var/www/html/apps
git clone https://github.com/nextcloud/spreed.git
cd spreed
make dev-setup
make build-js
../OCC app:enable spreed