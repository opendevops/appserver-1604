# = Class: apache::vhost
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
#   include apache
#   apache::vhost{ 'appserver1604':
#     projectPath => '/vagrant/www/projects'
#   }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define apache::vhost (
  # eg. appserver1604.dev
  $project_name = $title,
  $domain            = 'appserver.dev',
  $projects_root     = '/vagrant/www/projects',
  $project_path      = '/vagrant/www/projects/appserver',
  $project_webroot   = '/vagrant/www/projects/appserver/web',
  $symlinked_webroot = '/var/www/appserver',
  # link or directory
  # $ensure = 'link',
  $ensure = 'directory',
  $owner = 'vagrant',
  $group = 'www-data',
) {

  # eg. www.appserver.dev
  $server_name = $domain
  # eg. /var/www/healthkit
  $document_root = $project_webroot


  # Ensure project_path exists
  if ! defined (File[$projects_root]) {
    file { "$projects_root":
      # path => $project_path,
      ensure  => 'directory',
      # recurse => true,
      owner   => $owner,
      group   => $group
    }
  }

  # Ensure project_path/project_name exists
  if ! defined (File["$project_path"]) {
    file { "$project_path":
      # path => $project_path,
      ensure  => 'directory',
      # recurse => true,
      owner   => $owner,
      group   => $group
    }
  }


  # create vhost in sites-available
  file { "/etc/apache2/sites-available/$project_name.conf":
    ensure    => file,
    path      => "/etc/apache2/sites-available/$project_name.conf",
    content   => template('apache/vhost.conf.erb'),
    require   => Package["apache2"],
    subscribe => Package["apache2"],
  }

  # symlink apache site to the site-enabled directory
  file { "/etc/apache2/sites-enabled/$project_name.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/$project_name.conf",
    require => File["/etc/apache2/sites-available/$project_name.conf"],
    # notify => Service["apache2"],
  }

  # symlink apache site to the site-enabled directory
  # if $symlinked_webroot and $project_webroot are different, for example
  # $symlinked_webroot = '/var/www/dashboard' and $project_webroot = '/var/www/projects/dashboard'
  # the domain will point to the '/var/www/dashboard' and point to '/var/www/projects/dashboard'
  if $ensure == 'link' {
    file { "$project_webroot":
      ensure  => $ensure,
      # path => "/var/www/$project_name",
      path    => $symlinked_webroot,
      target  => $project_webroot,
      require => File["/etc/apache2/sites-available/$project_name.conf"],
      # notify => Service["apache2"],
    }
  } else {

    if ! defined (File[$project_webroot]) {
      file { "$project_webroot":
        ensure  => 'directory',
        recurse => true,
      }
    }

  }

}
