# PREFERENCES

$prodMode         = false
$default_user      = 'vagrant'
$default_group    = 'www-data'
$projects_root    = '/vagrant/www/projects'
$interface        = 'enp0s3'
$wwwFolder        = '/var/www'
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
users { "${default_user}": db_user => $dbUser, db_password => $dbPassword }
# Ensure id_rsa & id_rsa.pub are in this folder: www/puppet/modules/ssh/files/$user/id_rsa",
# users::ssh{ $default_user: }

# APACHE
include apache
apache::config { "apache_config": }
apache::vhost { 'dashboard':
  domain            => 'dashboard.dev',
  projects_root     => "/vagrant/www/projects",
  project_path      => "/vagrant/www/projects/dashboard",
  project_webroot   => "/vagrant/www/projects/dashboard",
  owner             => $default_user,
  group             => $default_group,
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
python::pip{ 'python_pip': user => $default_user }

# DASHBOARD
dashboard::config { 'dashboard_config':
  path      => "$projects_root/dashboard",
  interface => $interface,
  user      => $default_user,
}

# PROJECTS
projects::local { 'appserver1604.dev':
  domain            => 'www.appserver1604.dev',
  projects_root     => $projects_root,
  project_path      => "$projects_root/appserver",
  project_webroot   => "$projects_root/appserver/web",
  user              => $default_user
}


# CACHE
include cache
cache::memcached { 'memcached': }
cache::opcache { 'opcache': prod_mode => $prodMode }

# COMPOSER
::composer { 'composer': target_dir => '/usr/local/bin', user => $default_user }

# ROBO
::robo { 'robo': target_dir => '/usr/local/bin', force_update => false, user => $default_user }

# PHANTOMJS
::phantomjs { 'phantomjs': package_version => '2.1.1', force_update => false, user => $default_user }


#TODO: install java?
