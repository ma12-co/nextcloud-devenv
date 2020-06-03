export DEBIAN_FRONTEND=noninteractive

echo ''
echo '##########################################'
echo '# Reset data dir'
echo '##########################################'

cd /var/www/html

# prepare data dir
rm -r ../data
rm config/vagrant.nextcloud.log

mkdir ../data
chown vagrant:www-data -R ../data
chmod g+w ../data

chown vagrant:www-data -R config/
chmod g+w -R config/


echo ''
echo '##########################################'
echo '# Reset db'
echo '##########################################'

mysql -uroot -proot -e "DROP DATABASE nextcloud"
  echo "#### Create db ####"
  mysqladmin -uroot password root
  mysql -uroot -proot -e "CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
  mysql -uroot -proot -e "CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'nextcloud'"
  mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost'"
  systemctl restart mysql.service


echo ''
echo '##########################################'
echo '# Install'
echo '##########################################'
./occ maintenance:install -v --no-warnings \
--admin-user admin --admin-pass admin --data-dir /var/www/data \
--database mysql --database-name nextcloud --database-user root --database-pass root


echo ''
echo '##########################################'
echo '# Configure nextcloud'
echo '##########################################'

./occ config:app:set -vvv "core" "backgroundjobs_mode" --value "cron"
./occ config:app:set -vvv "spreed" "signaling_dev" --value="yes"


echo ''
echo '##########################################'
echo '# Add some users'
echo '##########################################'

USERID=$(uuidgen)
./occ -vvv user:add --password-from-env --display-name "Joas" -g "Talk team" $USERID
./occ -vvv user:setting $USERID settings email test1@admin.net

USERID=$(uuidgen)
./occ -vvv user:add --password-from-env --display-name "Daniel" -g "Talk team" $USERID
./occ -vvv user:setting $USERID settings email test1@admin.net

USERID=$(uuidgen)
./occ -vvv user:add --password-from-env --display-name "Ivan" -g "Talk team" $USERID
./occ -vvv user:setting $USERID settings email test1@admin.net

USERID=$(uuidgen)
./occ -vvv user:add --password-from-env --display-name "Mario" -g "Talk team" $USERID
./occ -vvv user:setting $USERID settings email test1@admin.net

echo ''
echo '##########################################'
echo '# Disable unneeded apps'
echo '##########################################'
./occ config:app:set admin_audit enabled --value="no"
./occ config:app:set comments enabled --value="no"
./occ config:app:set dav enabled --value="no"
./occ config:app:set encryption enabled --value="no"
#./occ config:app:set federatedfilesharing enabled --value="no"
./occ config:app:set federation enabled --value="no"
#./occ config:app:set files enabled --value="no"
./occ config:app:set files_external enabled --value="no"
#./occ config:app:set files_sharing enabled --value="no"
#./occ config:app:set files_trashbin enabled --value="no"
#./occ config:app:set files_versions enabled --value="no"
#./occ config:app:set provisioning_api enabled --value="no"
./occ config:app:set systemtags enabled --value="no"
./occ config:app:set testing enabled --value="no"
#./occ config:app:set theming enabled --value="no"
./occ config:app:set updatenotification enabled --value="no"
./occ config:app:set user_ldap enabled --value="no"
#./occ config:app:set workflowengine enabled --value="no"
