# == Class: projects
#
# Full description of class projects here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'projects':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Opendevops
#
class project (
  # eg. local, staging, live - used in the maual setup script
  $env                  = 'staging',
  $projects_folder      = '/home/ubuntu/projects',
  $www_folder           = '/var/www',
  $www_dashboard_folder = '/var/www/dashboard',
  $www_devops_folder    = '/var/www/devops_dashboard',
  $default_domain       = '',
  $redirect_from        = '',
  $redirect_to          = '',
  $dashboard_domain     = '',
  $devops_domain        = '',
  $dashboard_branch     = '',
  $user                 = 'ubuntu',
  $apache_user          = 'www-data',
  $vhost                = 'aws',
  $git_ssh              = 'git@github.com',
  $git_username         = 'HealthKit Deploy',
  $git_email            = 'webmaster@healthkit.com',
  $repo_team            = 'healthkit',
  $server_build_repo    = 'server-build',
  $default_branch       = 'master',
  # project log location
  $default_log_path     = '/var/www/logs',
  # project cache location
  $default_cache_path   = '/var/www/cache',
  # $default_tmp_path     = '/var/www/tmp',
  $apache_log_folder    = '/var/log/apache2',
  $mysql_enabled        = true,
  $bucket               = 'hkprod-sydney-server-build',
  $local_mode           = false,
  $db_user              = '',
  $user_manual_db       = false,
) {

  #
  # * Params
  #
  $user_home = "/home/$user"


  #
  # * Create www folder
  #
  file { $www_folder:
    ensure => directory,
    group  => $apache_user,
    mode   => '0755',
    owner  => $user,
  }


  file { "$www_folder/.htpasswd":
    ensure  => present,
    path    => "/var/www/.htpasswd",
    owner   => $project::user,
    group   => $project::user,
    content => template("project/htpasswd.erb"),
    require => File[$www_folder],
  }


  file { $www_dashboard_folder:
    ensure => directory,
    group  => $apache_user,
    mode   => '0755',
    owner  => $user,
  }


  #
  # * Create project folder
  #
  file { $projects_folder:
    ensure => directory,
    group  => $apache_user,
    mode   => '0755',
    owner  => $user,
  }

  #  file { "$projects_folder/repos":
  #    ensure  => directory,
  #    group   => $apache_user,
  #    mode    => '0755',
  #    owner   => $user,
  #    require => File[$projects_folder],
  #  }

}
