# PREFERENCES

#
# * SERVER CONFIG
#
$server_timezone   = 'Etc/UTC'
#$server_timezone = 'Australia/Melbourne'

#
# * Enable / Disable
#
$cache_prod_mode = false
$phpmyadmin_enabled = true
$testing_enabled = false
$wkhtmltopdf_enabled = false
$xdebug_enabled = true
$sudo_www_data = true

#
# * DATABASE CONFIG
#
$db_names = ['invoiceignition']
$db_user = 'dbuser'
$db_password = 'strongpassword'
$db_root_password = 'verystrongpassword'

#
# * PROJECT CONFIG (more project config at the end)
#
# $healthkits = ['integration', 'yesterday', 'braintree']
# $sub_domains = ['www']
# $user_manuals = ['manual']
class { 'project':
  env              => 'local',
  default_domain   => 'healthkit.dev',
  dashboard_domain => 'dashboard.healthkit.dev',
  devops_domain    => 'devops.healthkit.dev',
  dashboard_branch => 'master',
  projects_folder  => '/vagrant/www/projects',
  vhost            => 'http',
  user             => 'vagrant',
  # mysql_enabled    => true,
  local_mode       => true,
  db_user          => $db_user,
  user_manual_db   => true,
}


################################################################################################
#
# * CHANGING BELOW NOT REQUIRED
#

# NOTE: composer, phantomjs, robo etc are installed here: /usr/local/bin

#
# * Default paths
#
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

#
# * SERVER
#
class { 'server': sudo_www_data => $sudo_www_data }
server::config { 'server_config': timezone => $server_timezone }
server::packages { 'server_packages': }
if $testing_enabled == true {
  #
  # * PHANTOMJS
  #
  # ::phantomjs { 'phantomjs': package_version => '1.9.8', force_update => false }
}

#
# * wkhtmltopdf
#
if $wkhtmltopdf_enabled == true {
  class { 'wkhtmltopdf': target_dir => "/usr/local/bin" }
}

#
# * SSH
#
include ssh
ssh::config { 'ssh_config': passwordAuthentication => 'yes' }

#
# * USERS
#
users { $project::user: db_user => $db_user, db_password => $db_password }
# Ensure id_rsa & id_rsa.pub are in this folder: www/puppet/modules/ssh/files/$user/id_rsa",
# users::ssh{ $project::user: }

#
# * APACHE
#
include apache
apache::config { "apache_config":
  server_limit        => 25,
  start_servers       => 4,
  min_spare_threads   => 75,
  max_spare_threads   => 250,
  thread_limit        => 64,
  threads_per_child   => 32,
  # 800 concurrent users
  max_request_workers => 800,
}

#
# * PHP - install and configure php
#
include php
php::config { 'php_config':
  upload_max_filesize    => '30M',
  post_max_size          => '30M',
  display_errors         => 'On',
  display_startup_errors => 'On',
  process_manager        => 'static',
  max_children           => 25,
  start_servers          => 4,
  min_spare_servers      => 2,
  max_spare_servers      => 4,
}


#
# * CACHE
#
include cache
cache::memcached { 'memcached': memory => 128 }
cache::opcache { 'opcache':
  prod_mode               => $cache_prod_mode,
  max_accelerated_files   => 2000,
  memory_consumption      => 128,
  interned_strings_buffer => 32,
}


#
# * X-DEBUG - install and configure xdebug
#
if $xdebug_enabled {
  include xdebug
  xdebug::config { 'local_xdebug':
    default_enable      => 1,
    profiler_enable     => 0,
    remote_port         => 9000,
    profiler_output_dir => '/vagrant/www/projects/profiler_output'
  }


  #
  # * PHPMETRICS
  #
  # ::phpmetrics { 'phpmetrics': target_dir => '/usr/local/bin' }
}

#
# * MYSQL - install and start mysql + set root password
#
if $project::mysql_enabled {
  include mysql
  mysql::config { 'mysql_config': password => $db_root_password }
  mysql::user { $db_user: user_password => $db_password }
  mysql::database { $db_names: user => $db_user }
}

#
# * NODE - install and configure nodejs
#
include nodejs

#
# * RUBY
#
include ruby

#
# * PYTHON - install and configure python
#
# include python
# python::pip { 'python_pip': }



#
# * COMPOSER
#
::composer { 'composer': target_dir => '/usr/local/bin' }

#
# * ROBO
#
# class { 'robo': target_dir => '/usr/local/bin' }


#
# * AWS CLI
#
#include aws


#
# * CRON
#
class { 'cron': env => $project::env }


#
# * CHANGING ABOVE NOT REQUIRED
#
################################################################################################


#
# * PHPMYADMIN
#
if $phpmyadmin_enabled {
  include phpmyadmin
  phpmyadmin::config { 'localhost': host => 'localhost' }
}

#
# * invoice.dev
#
project::site { 'www.invoice.dev': vhost_webroot => "$project::projects_folder/invoice" }


#
# apache::vhost { 'appserver1604.dev':
#   domain            => 'appserver1604.dev',
#   project_webroot   => "$projects_root/appserver/web",
#   project_path      => "$projects_root/appserver",
#   projects_root     => $projects_root,
#   ensure            => 'directory',
# }
#
# apache::vhost { 'www.invoice.dev':
#   domain            => 'www.invoice.dev',
#   project_webroot   => "$projects_root/invoice",
#   project_path      => "$projects_root/invoice",
#   projects_root     => $projects_root,
#   ensure            => 'directory',
# }
#
# apache::vhost { 'www.dashboard.dev':
#   domain            => 'www.dashboard.dev',
#   project_webroot   => "$projects_root/dashboard/ui-angular2/dist/prod",
#   project_path      => "$projects_root/dashboard/ui-angular2",
#   projects_root     => $projects_root,
#   ensure            => 'directory',
# }
#
# apache::vhost { 'api.hiphiparray.dev':
#   domain            => 'api.hiphiparray.dev',
#   project_webroot   => "$projects_root/hiphiparray/api-symfony3/web",
#   project_path      => "$projects_root/hiphiparray/api-symfony3",
#   projects_root     => $projects_root,
#   ensure            => 'directory',
# }
#
# apache::vhost { 'react.hiphiparray.dev':
#   domain            => 'react.hiphiparray.dev',
#   project_webroot   => "$projects_root/hiphiparray/ui-react/public",
#   project_path      => "$projects_root/hiphiparray/ui-react/public",
#   projects_root     => $projects_root,
#   ensure            => 'directory',
# }
# apache::vhost { 'angular2.hiphiparray.dev':
#   domain            => 'angular2.hiphiparray.dev',
#   project_webroot   => "$projects_root/hiphiparray/ui-angular2",
#   project_path      => "$projects_root/hiphiparray/ui-angular2",
#   projects_root     => $projects_root,
#   ensure            => 'directory',
# }
