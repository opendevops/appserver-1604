# == Class: robo
#
# Full description of class robo here.
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
#   ::robo{ 'robo': target_dir => '/usr/local/bin', force_update => false}
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define robo (
  $target_dir       = '/usr/local/bin',
  $command_name     = 'robo',
  $user             = 'root',
  $force_update     = false,
  $group            = undef,
  $download_timeout = '0',
) {

  include robo::params

  $robo_target_dir = $target_dir ? {
    '/usr/local/bin' => $::robo::params::target_dir,
    default => $target_dir
  }

  $robo_command_name = $command_name ? {
    'robo' => $::robo::params::command_name,
    default => $command_name
  }

  $robo_user = $user ? {
    'root' => $::robo::params::user,
    default => $user
  }

  $target = $::robo::params::phar_location

  $robo_full_path = "${robo_target_dir}/${robo_command_name}"

  exec { 'robo-install':
    command => "/usr/bin/wget --no-check-certificate -O ${robo_full_path} ${target}",
    user    => $robo_user,
    creates => $robo_full_path,
    timeout => $download_timeout,
  }

  file { "${robo_target_dir}/${robo_command_name}":
    ensure  => file,
    owner   => $robo_user,
    mode    => '0755',
    group   => $group,
    require => Exec['robo-install'],
  }

  if $force_update {
    # removed `creates` to ensure it will always update
    exec { 'robo-update':
      command => "/usr/bin/wget --no-check-certificate -O ${robo_full_path} ${target}",
      user    => $robo_user,
      timeout => $download_timeout,
    }
  }

  # exec { 'robo-fix-permissions':
  #   command => "chmod a+x ${robo_command_name}",
  #   path    => '/usr/bin:/bin:/usr/sbin:/sbin',
  #   cwd     => $robo_target_dir,
  #   user    => $robo_user,
  #   unless  => "test -x ${robo_target_dir}/${robo_command_name}",
  #   require => Exec['robo-install'],
  # }
}