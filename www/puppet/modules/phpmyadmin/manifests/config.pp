# = Class: mysql::config
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
define phpmyadmin::config (
  # eg. localhost, staging
  $verbose       = $title,
  $host          = 'localhost',
  $sub_domain    = 'phpmyadmin',
  # $verbose        = 'localhost',
  # $vhost          = '',
  # $owner          = 'ubuntu',
  $vhost_webroot = '/usr/share/phpmyadmin',
) {

  if $verbose != 'localhost' {
    # phpmyadmin config file
    file { "$verbose.config.php":
      ensure  => file,
      mode    => '0644',
      path    => "/etc/phpmyadmin/conf.d/$verbose.config.php",
      content => template('phpmyadmin/server.config.erb'),
      require => Package["phpmyadmin"],
    }
  }

  if $sub_domain != '' {
    $domain = "$sub_domain.${project::default_domain}"
    if !defined(Apache::Vhost[$domain]) {
      apache::vhost { $domain:
        vhost_webroot => $vhost_webroot,
      }
    }
    # apache::vhost { $domain:
    #   domain          => $domain,
    #   projects_root   => $project_folder,
    #   project_path    => $project_folder,
    #   project_webroot => $project_folder,
    #   owner           => $owner,
    #   # group           => $default_group,
    #   template        => "apache/vhost_$vhost.conf.erb",
    #   ensure          => 'directory',
    # }
  }

}