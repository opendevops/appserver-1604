# PREFERENCES

$prodMode = false
$defaultUser = 'mrrobot'
# $repos            = ['appserver']
# $branch           = 'master'
$dashboardDomain = 'dashboard'
$interface = 'enp0s3'
$projectsFolder = '/vagrant/www/projects'
$wwwFolder = '/var/www'
$dbNames          = ['appserver', 'test']
$dbUser           = 'dbuser'
$dbPassword       = 'strongpassword'
$dbRootPassword   = 'verystrongpassword'



# CHANGING BELOW NOT REQUIRED

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
users { "${defaultUser}": db_user => $dbUser, db_password => $dbPassword }
# Ensure id_rsa & id_rsa.pub are in this folder: www/puppet/modules/ssh/files/$user/id_rsa",
# users::ssh{ $defaultUser: }

# APACHE
include apache
apache::config { "apache_config": }
apache::vhost { $dashboardDomain:
  server_name    => "$dashboardDomain.dev",
  document_root  => "$wwwFolder/$dashboardDomain",
  project_path   => $projectsFolder,
  owner          => $defaultUser,
  group          => $defaultGroup,
}


# PHP - install and configure php
include php
php::config { 'php_config': max_execution_time => 300, upload_max_filesize => '20M', display_errors => 'On', display_startup_errors => 'On' }

# X-DEBUG - install and configure xdebug
include xdebug
xdebug::config { 'local_xdebug': default_enable => 1, profiler_enable => 1, remote_port => 9009 }

# MYSQL - install and start mysql + set root password
include mysql
mysql::config { 'mysql_config': password => $dbRootPassword }
mysql::user { $dbUser: password => $dbPassword }
mysql::database { $dbNames: user => $dbUser }

# NODE - install and configure nodejs
include nodejs

# RUBY
include ruby

# PYTHON - install and configure python
include python
python::pip{ 'python_pip': user => $defaultUser }

# DASHBOARD
dashboard::config { 'dashboard_config':
  path      => "$projectsFolder/$dashboardDomain",
  interface => $interface,
  user      => $defaultUser,
}

# PROJECTS
class { 'projects': env => 'local', repos => $repos, projectFolder => $projectsFolder, user => $defaultUser, branch => $branch }
# projects::local {'projects': repos => $repos, projectFolder => $projectsFolder, user => $defaultUser, group => $defaultGroup }


# CACHE
include cache
cache::memcached { 'memcached': }
cache::opcache { 'opcache': prod_mode => $prodMode }

# COMPOSER
::composer{ 'composer': target_dir => '/usr/local/bin', user => $defaultUser }

# ROBO
::robo{ 'robo': target_dir => '/usr/local/bin', force_update => false, user => $defaultUser }

# PHANTOMJS
::phantomjs{ 'phantomjs': package_version => '2.1.1', force_update => false, user => $defaultUser }


#TODO: install java
