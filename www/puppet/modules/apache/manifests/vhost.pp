# == Class: project::build
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
#    servers  => [ 'pool.ntp.org', 'ntp.tools.company.com' ],
#  }
#
# === Authors
#
# Matthew Hansen
#
define apache::vhost (
  # eg. www.test.dev
  $domain         = $title,
  # if this is set then use it as the vhost document_root eg. /var/www/user-manuals
  $vhost_webroot  = '',
  # eg. access.log
  $access_log     = '',
  # eg. error_log
  $error_log      = '',
) {


  #
  # * server_name - domain name, used in the vhost template
  #
  $server_name = $domain


  #
  # * document_root - ensure it exists + vhost template uses it
  # eg. /var/www/healthkit
  #
  $document_root = $vhost_webroot
  # if $vhost_webroot != '' {
  #   $document_root = $vhost_webroot
  # } else {
  #   $document_root = "${::project::www_folder}/$www_folder"
  # }

  # create document root folder
  if !defined(Project::Tools::Mkdir[$document_root]) {
    project::tools::mkdir { $document_root: mode => '0775' }
  }


  #
  # * apache access log
  #
  if $access_log != '' {
    # eg. access.log
    $apache_access_log = $access_log
  } else {
    # eg. /var/log/apache/www.healthkit.dev_access.log
    $apache_access_log = "$project::apache_log_folder/${server_name}_access.log"
  }


  #
  # * error log
  #
  if $error_log != '' {
    # eg. error.log
    $apache_error_log = $error_log
  } else {
    # eg. /var/log/apache/www.healthkit.dev_access.log
    $apache_error_log = "$project::apache_log_folder/${server_name}_error.log"
  }


  #
  # * Sites available
  #
  # create vhost in sites-available
  if !defined(File["/etc/apache2/sites-available/$server_name.conf"]) {
    file { "/etc/apache2/sites-available/$server_name.conf":
      ensure    => file,
      path      => "/etc/apache2/sites-available/$server_name.conf",
      content   => template("apache/vhost_$project::vhost.conf.erb"),
      require   => Package["apache2"],
      subscribe => Package["apache2"],
    }
  }

  #
  # * Sites enabled
  #
  if !defined(File["/etc/apache2/sites-enabled/$server_name.conf"]) {
    # symlink apache site to the site-enabled directory
    file { "/etc/apache2/sites-enabled/$server_name.conf":
      ensure  => link,
      target  => "/etc/apache2/sites-available/$server_name.conf",
      require => File["/etc/apache2/sites-available/$server_name.conf"],
      notify  => Service["apache2"],
    }
  }

}
