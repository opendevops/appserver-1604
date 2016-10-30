$prodMode = false
$defaultUser = 'mrrobot'
$dashboardDomain = 'dashboard'
$interface = 'enp0s3'
$projectsFolder = '/vagrant/www/projects'
$wwwFolder = '/var/www'
# $dbName = 'appserver'
# $dbUser = 'dbuser'
$dbPassword = 'strongpassword'
# $dbRootPassword = 'verystrongpassword'


# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

# SERVER
include server
server::packages { 'server_packages': wkhtmltopdf => true, testing => true }
server::config { 'server_config': }

# SSH
include ssh
ssh::config{ 'ssh_config': }

# USERS
users { "${defaultUser}": db_password => $dbPassword }
# Ensure id_rsa & id_rsa.pub are in this folder: puppet:///modules/ssh/$user",
# users::ssh{ $defaultUser: }

# APACHE
include apache
apache::config { "apache_config": }
apache::vhost { $dashboardDomain:
  server_name   => "$dashboardDomain.dev",
  document_root => "$wwwFolder/$dashboardDomain",
  project_path  => $projectsFolder,
}

# PHP - install and configure php
include php
php::config { 'php_config': }

# X-DEBUG - install and configure xdebug
include xdebug
xdebug::config { 'local_xdebug': default_enable => '1' }

# MYSQL - install and start mysql + set root password
include mysql
mysql::config { 'mysql_config': password => 'verystrongpassword' }
mysql::user { 'dbuser': password => 'strongpassword' }
mysql::database { 'appserver': user => 'dbuser' }

# NODE - install and configure nodejs
include nodejs

# RUBY
include ruby

# PYTHON - install and configure python
include python
python::pip{ 'python_pip': }

# DASHBOARD
dashboard::config { 'dashboard_config': path => "$projectsFolder/$dashboardDomain", interface => $interface }

# CACHE
include cache
cache::memcached { 'memcached': }
cache::opcache { 'opcache': prod_mode => $prodMode }

# COMPOSER
::composer{ 'composer': target_dir => '/usr/local/bin' }

# ROBO
::robo{ 'robo': target_dir => '/usr/local/bin', force_update => false }

# PHANTOMJS
::phantomjs{ 'phantomjs': package_version => '2.1.1', force_update => false }


#TODO: install java
