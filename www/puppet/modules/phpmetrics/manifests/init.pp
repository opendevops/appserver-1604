# == Class: phpmetrics
#
# Full description of class phpmetrics here.
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
#   ::phpmetrics{ 'phpmetrics': target_dir => '/usr/local/bin', force_update => false}
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define phpmetrics (
  $target_dir       = '/usr/local/bin',
  $command_name     = 'phpmetrics',
  $user             = 'root',
  $group            = undef,
  $download_timeout = '0',
) {

  include phpmetrics::params

  $phpmetrics_target_dir = $target_dir ? {
    '/usr/local/bin' => $::phpmetrics::params::target_dir,
    default => $target_dir
  }

  $phpmetrics_command_name = $command_name ? {
    'phpmetrics' => $::phpmetrics::params::command_name,
    default => $command_name
  }

  $phpmetrics_user = $user ? {
    'root' => $::phpmetrics::params::user,
    default => $user
  }

  $target = $::phpmetrics::params::phar_location

  $phpmetrics_full_path = "${phpmetrics_target_dir}/${phpmetrics_command_name}"

  exec { 'phpmetrics-install':
    command => "/usr/bin/wget --no-check-certificate -O ${phpmetrics_full_path} ${target}",
    user    => $phpmetrics_user,
    creates => $phpmetrics_full_path,
    timeout => $download_timeout,
  }

  file { "${phpmetrics_target_dir}/${phpmetrics_command_name}":
    ensure  => file,
    owner   => $phpmetrics_user,
    mode    => '0755',
    group   => $group,
    require => Exec['phpmetrics-install'],
  }

}