# == Class: projects::build
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
#    servers  => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Opendevops
#
# === Copyright
#
# Copyright 2016 Opendevops
#
define projects::local(
  $repo           = $title,
  $projectFolder  = '/vagrant/www/projects',
  $wwwFolder      = '/var/www',
  $user           = 'vagrant',
  $group          = 'www-data',
  $branch         = 'master',
) {


  apache::vhost { $repo:
    server_name    => "www.$repo.dev",
    document_root  => "$wwwFolder/$repo",
    project_path   => $projectsFolder,
    ensure         => 'directory',
  }

  # file permissions
  file { "$wwwFolder/$repo":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    # recursive => true,
    # force => true,
    mode    => 0775,
  }


}