# = Class: server::packages::log
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
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
#
# === Authors
#
# Matthew Hansen
#
class server::packages::log {

  $packages = [
    'logrotate',
    'multitail',
  ]

  package { $packages:
    ensure  => latest,
    require => Exec['apt-update'],
  }


  $logrotate_file = [
    'apache2',
    'apport',
    'apt',
    'clamav-daemon',
    'clamav-freshclam',
    'dbconfig-common',
    'dpkg',
    'fail2ban',
    'lxd',
    'mysql-server',
    'php7.0-fpm',
    'rsyslog',
    'ufw',
    'unattended-upgrades',
  ]

  server::logrotate_d { $logrotate_file: }
}