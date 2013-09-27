#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update

sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server
sudo apt-get install -q -y --force-yes apache2 libapache2-mod-php5 php5-mysql php5-curl php5-gd php-db php5-mysql php-pear mysql-server git-core patch unzip ssmtp
sudo pear channel-discover pear.drush.org
sudo pear install drush/drush
cd /vagrant
drush make build-commons.make --no-cache -y packaged


# Point a minimal default vhost to the commons dir
rm -f /etc/apache2/sites-available/default
touch /etc/apache2/sites-available/default
sudo chown vagrant /etc/apache2/sites-available/default
echo "<VirtualHost *:80>" > /etc/apache2/sites-available/default
echo "    DocumentRoot /vagrant/packaged" >> /etc/apache2/sites-available/default
echo "</VirtualHost>" >> /etc/apache2/sites-available/default
sudo chown www-data /etc/apache2/sites-available/default

# Bump the PHP memory limit for commons
sudo sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php5/apache2/php.ini


sudo a2enmod rewrite
sudo a2enmod actions
sudo service apache2 restart
cd packaged
drush -v site-install --db-url=mysql://root:root@localhost/commons --site-name=QASite --account-name=admin --account-pass=commons --account-mail=admin@example.com --site-mail=site@example.com -v -y commons commons_anonymous_welcome_text_form.commons_anonymous_welcome_title="Oh hai" commons_anonymous_welcome_text_form.commons_anonymous_welcome_body="No shirts, no shoes, no service." commons_create_first_group.commons_first_group_title="Internet People" commons_create_first_group.commons_first_group_body="This is the first group on the page."
echo "You should have a running Drupal Commons site available on http://localhost:8080/"