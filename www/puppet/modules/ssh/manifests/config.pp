# = Class: ssh::config
#
# Description
#
# === Parameters
#
# Document parameters here.
#
# [*permitRootLogin*]
#   Used to disable root login, eg. sets "PermitRootLogin no" in "/etc/ssh/sshd_config".
#   Server default is "PermitRootLogin prohibit-password".
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
#  class { 'ssh':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define ssh::config (
  $permitRootLogin = 'PermitRootLogin no'
) {

  # add a notify to the file resource
  file { '/etc/ssh/sshd_config':
    path    => "/etc/ssh/sshd_config",
    # this sets up the relationship
    notify  => Service['sshd'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['openssh-server'],
    content => template('ssh/sshd_config.erb'),
  }

  # add a notify to the file resource
  file { '/etc/ssh/ssh_config':
    path    => "/etc/ssh/ssh_config",
    # this sets up the relationship
    notify  => Service['sshd'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['openssh-server'],
    content => template('ssh/ssh_config.erb'),
  }
}
