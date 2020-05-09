!/bin/bash
#
# Checkout and update the branch on all repos

DATABASE_PASSWORD=123456

SERVER_VERSION=$1
SERVER_COLOR=$2
SERVER_PATH=$3
SERVER_MODE=$4

echo ''
echo '##########################################'
echo '# Reset data dir'
echo '##########################################'

# prepare data dir
 rm -r data/
 rm config/vagrant.nextcloud.log

mkdir data/
 chown vagrant:www-data -R data/
chmod g+w data/

 chown vagrant:www-data -R config/
 chmod g+w -R config/

echo ''
echo '##########################################'
echo '# Reset database'
echo '##########################################'

mysql -u root -p"$DATABASE_PASSWORD" -e "DROP DATABASE nextcloud$SERVER_VERSION"
if [ "$SERVER_MODE" != "sqlite" ]; then
    mysql -u root -p"$DATABASE_PASSWORD" -e "CREATE DATABASE nextcloud$SERVER_VERSION CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    #mysql -u root -p"$DATABASE_PASSWORD" -e "CREATE DATABASE nextcloud$SERVER_VERSION CHARACTER SET utf8 COLLATE utf8_general_ci"
fi

echo ''
echo '##########################################'
echo '# Install'
echo '##########################################'

# install
if [ "$SERVER_MODE" == "sqlite" ]; then
     -u vagrant ./occ maintenance:install -v --no-warnings \
    --admin-user admin --admin-pass admin --data-dir /home/vagrant/Nextcloud/$SERVER_PATH/server/data
elif [ "$SERVER_MODE" == "oci" ]; then
     -u vagrant ./occ maintenance:install -v --no-warnings \
    --admin-user admin --admin-pass admin --data-dir /home/vagrant/Nextcloud/$SERVER_PATH/server/data \
    --database oci --database-host localhost --database-name xe --database-user nextcloud_user --database-pass nextcloud --database-table-space xe
else
     -u vagrant ./occ maintenance:install -v --no-warnings \
    --admin-user admin --admin-pass admin --data-dir /home/vagrant/Nextcloud/$SERVER_PATH/server/data \
    --database mysql --database-name nextcloud$SERVER_VERSION --database-user root --database-pass I5a1L0g8
fi


echo ''
echo '##########################################'
echo '# Ignore some apps'
echo '##########################################'

 chown vagrant:www-data -R config/
 chmod g+w -R config/

 -u vagrant ./occ config:system:set logfile --value="/home/vagrant/Nextcloud/$SERVER_PATH/server/config/vagrant.nextcloud.log"
if [ "$SERVER_MODE" != "sqlite" ]; then
     -u vagrant ./occ config:app:set theming color --value="$SERVER_COLOR"
else
     -u vagrant ./occ config:app:set theming color --value="#000000"
fi

if [ "$SERVER_MODE" != "shipped" ]; then
	 -u vagrant ./occ config:app:set admin_audit enabled --value="no"
	 -u vagrant ./occ config:app:set comments enabled --value="no"
	# -u vagrant ./occ config:app:set dav enabled --value="no"
	 -u vagrant ./occ config:app:set encryption enabled --value="no"
	# -u vagrant ./occ config:app:set federatedfilesharing enabled --value="no"
	 -u vagrant ./occ config:app:set federation enabled --value="no"
	# -u vagrant ./occ config:app:set files enabled --value="no"
	 -u vagrant ./occ config:app:set files_external enabled --value="no"
	# -u vagrant ./occ config:app:set files_sharing enabled --value="no"
	# -u vagrant ./occ config:app:set files_trashbin enabled --value="no"
	# -u vagrant ./occ config:app:set files_versions enabled --value="no"
	# -u vagrant ./occ config:app:set provisioning_api enabled --value="no"
	 -u vagrant ./occ config:app:set systemtags enabled --value="no"
	 -u vagrant ./occ config:app:set testing enabled --value="no"
	# -u vagrant ./occ config:app:set theming enabled --value="no"
	 -u vagrant ./occ config:app:set updatenotification enabled --value="no"
	 -u vagrant ./occ config:app:set user_ldap enabled --value="no"
	# -u vagrant ./occ config:app:set workflowengine enabled --value="no"

echo ''
echo '##########################################'
echo '# Add some users'
echo '##########################################'

if [ "$SERVER_MODE" == "shipped" ]; then
	./occ app:disable -v password_policy
fi

 -u vagrant OC_PASS="123456" ./occ user:add --password-from-env --display-name "User One" -g ug-test test1
 -u vagrant OC_PASS="123456" ./occ user:add --password-from-env --display-name "User Two" -g ug-test test2
 -u vagrant OC_PASS="123456" ./occ user:add --password-from-env --display-name "User Three" -g ug-test test3
 -u vagrant OC_PASS="123456" ./occ user:add --password-from-env --display-name "User Four" -g ug-test test4
 -u vagrant OC_PASS="123456" ./occ user:add --password-from-env --display-name "User Five" -g ug-test test5

if [ "$SERVER_MODE" == "shipped" ]; then
	./occ app:enable -v password_policy
fi

echo ''
echo '##########################################'
echo '# Fill config'
echo '##########################################'

 chown vagrant:www-data -R config/
 chmod g+w -R config/

./occ app:list

 chown vagrant:www-data -R config/
 chmod g+w -R config/

# Revert the htaccess change (error pages etc.)
git checkout -- .htaccess

echo ''
echo '##########################################'
echo '# Fix permissions'
echo '##########################################'

# fix permissions once again
 chown vagrant:www-data -R data/
 chmod g+w -R data/
 chmod o-r -R data/
 chmod o-x -R data/